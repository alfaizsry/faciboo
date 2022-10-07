import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/facility_card.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:faciboo/screens/create_facilities.dart';
import 'package:flutter/material.dart';

class MyFacilitiesPage extends StatefulWidget {
  const MyFacilitiesPage({Key key}) : super(key: key);

  @override
  State<MyFacilitiesPage> createState() => _MyFacilitiesPageState();
}

class _MyFacilitiesPageState extends State<MyFacilitiesPage> {
  var dummyApi = DummyApi();
  dynamic userDetail;
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
      userDetail = dummyApi.getuserdetail["data"];
      myFacilitiesByCategory = dummyApi.getMyFacilitiesByCategory["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SizedBox(
            height: 48,
          ),
          _buildCardProfile(),
          SizedBox(
            height: 20,
          ),
          _buildCategory(),
        ],
      ),
    );
  }

  Widget _buildCardProfile() {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(25),
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width - 48,
        decoration: BoxDecoration(
          color: Colors.green[50],
          // border: Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: userDetail["image"],
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
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userDetail["name"],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${myFacilitiesByCategory[0].length} Facilities",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
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
              SizedBox(
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
        SizedBox(
          height: 8,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
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
                    SizedBox(
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
                        margin: EdgeInsets.only(
                          bottom: 8,
                          top: 4,
                        ),
                        width: 10,
                        height: 2.5,
                        decoration: BoxDecoration(
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
              SizedBox(
                width: 24,
              ),
            ],
          )
      ],
    );
  }
}
