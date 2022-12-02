import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/facility_card.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:faciboo/screens/create_facilities.dart';
import 'package:flutter/material.dart';

class MyFacilitiesPage extends StatefulWidget {
  const MyFacilitiesPage({Key key}) : super(key: key);

  @override
  State<MyFacilitiesPage> createState() => _MyFacilitiesPageState();
}

class _MyFacilitiesPageState extends State<MyFacilitiesPage> {
  HttpService http = HttpService();
  var dummyApi = DummyApi();
  dynamic userDetail = {};
  List<dynamic> myFacilities = [];
  List<dynamic> myFacilitiesByCategory = [];

  int selectedCategory = 0;

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    super.initState();
  }

  _callGetData() async {
    setState(() {
      // userDetail = dummyApi.getuserdetail["data"];
      myFacilitiesByCategory = dummyApi.getMyFacilitiesByCategory["data"];
    });
    await _getProfile();
    await _getMyFacilities();
  }

  _getProfile() async {
    await http.post('profile/get-profile').then((res) {
      if (res["success"]) {
        setState(() {
          userDetail = res["data"];
        });
        print("================USERDETAIL $userDetail");
      }
    }).catchError((err) {
      print("ERROR get-profile $err");
    });
  }

  _getMyFacilities() async {
    await http.post('facility/get-my-facility').then((res) {
      if (res["success"]) {
        setState(() {
          myFacilities = res["data"];
        });
        print("================MYFACILITIES $myFacilities");
      }
    }).catchError((err) {
      print("ERROR get-my-facility $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 48,
        ),
        _buildCardProfile(),
        const SizedBox(
          height: 16,
        ),
        _buildCategory(),
        _buildMyFacilities(),
      ],
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 175,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              color: Colors.grey.shade400,
              size: 50,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "There are no facilities",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title: "All My Facility"),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              // primary: false,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.green,
                  width: 10,
                  height: 10,
                );
              }),
        ),
      ],
    );
  }

  Widget _buildTitle({@required String title}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCardProfile() {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(25),
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.green[50],
          // border: Border.all(width: 2, color: Colors.black),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: userDetail["imageUrl"] ??
                  "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669888811~exp=1669889411~hmac=ab35157190db779880c061298b0fa239e5bc753da4191dd09b0df84726227f4a",
              imageBuilder: (context, imageProvider) => Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: Colors.red,
                    ),
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                  ),
                );
              },
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userDetail["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${myFacilitiesByCategory[0].length} Facilities",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomButton(
                  textButton: "Add New Facilities",
                  prefixIcon: Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.green[900],
                  ),
                  colorButton: Colors.white,
                  colorTextButton: Colors.green[900],
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateFacilities(),
                      ),
                    ).then((value) => _callGetData());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(
                width: 24,
              ),
              _customTabBar(),
            ],
          ),
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(
        //     horizontal: 24,
        //   ),
        //   child: _titleSeeMore(
        //     title: "${facilitiesByCategory[0]["category"]}",
        //     hasSeeMore: true,
        //     onClickSeeMore: () {},
        //   ),
        // ),
        const SizedBox(
          height: 8,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 24,
              ),
              for (var i = 0;
                  i <
                      myFacilitiesByCategory[selectedCategory]["facilities"]
                          .length;
                  i++)
                Row(
                  children: [
                    FacilityCard(
                      detailFacility: myFacilitiesByCategory[selectedCategory]
                          ["facilities"][i],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customTabBar() {
    return Row(
      children: [
        for (var i = 0; i < myFacilitiesByCategory.length; i++)
          Row(
            children: [
              InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  setState(() {
                    selectedCategory = i;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      myFacilitiesByCategory[i]["category"],
                      style: TextStyle(
                        fontWeight: (selectedCategory == i)
                            ? FontWeight.w700
                            : FontWeight.normal,
                        fontSize: 18,
                        color: (selectedCategory == i)
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    if (selectedCategory == i)
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 8,
                          top: 4,
                        ),
                        width: 10,
                        height: 2.5,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                width: 24,
              ),
            ],
          )
      ],
    );
  }
}
