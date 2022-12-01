import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/components/facility_card.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:faciboo/screens/all_facilities.dart';
import 'package:faciboo/screens/detail_facility.dart';
import 'package:faciboo/screens/schedule_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HttpService http = HttpService();
  var dummyApi = DummyApi();

  // int selectedCategory = 0;
  // //categori 1: sports, 2:entertainment, 3:workspace,
  String selectedCategory = "6384dc208821ee9c3d4c96f8";
  dynamic userDetail = {};

  List<dynamic> facilities = [];
  List<dynamic> facilitiesByCategory = [];
  List<dynamic> categories = [];

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    super.initState();
  }

  _callGetData() async {
    _getProfile();
    _getFacilities();
    _getCategories();
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

  _getFacilities() async {
    await http.post('facility/get-facility').then((res) {
      if (res["success"]) {
        setState(() {
          facilities = res["data"];
        });
        print("================FACILITIES $facilities");
      }
    }).catchError((err) {
      print("ERROR get-facility $err");
    });
  }

  _getCategories() async {
    await http.post('category/get-category').then((res) {
      if (res["success"]) {
        setState(() {
          categories = res["data"];
          print(categories);
          selectedCategory = categories[0]["_id"];
          _getFacilitiesByCategory();
        });
        print("================CATEGORY $categories");
      }
    }).catchError((err) {
      print("ERROR get-category $err");
    });
  }

  _getFacilitiesByCategory() async {
    Map body = {
      "id": selectedCategory,
    };
    await http.post('category/facility-by-category', body: body).then((res) {
      if (res["success"]) {
        setState(() {
          facilitiesByCategory = res["data"];
        });
        print("================FACILITIES BY CATEGORY $facilitiesByCategory");
      }
    }).catchError((err) {
      print("ERROR get-facility $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(
            height: 48,
          ),
          _buildUserBanner(),
          const SizedBox(
            height: 24,
          ),
          _buildFacilitiesBanner(
            title: "New Facilities",
            facilities: facilities,
          ),
          const SizedBox(
            height: 24,
          ),
          _buildCategory(),
          const SizedBox(
            height: 24,
          ),
          _buildFacilitiesBanner(
            title: "Popular",
            facilities: facilities,
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildUserBanner() {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      // height: MediaQuery.of(context).size.height / 4.5,
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: 32,
      ),
      margin: const EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/map_unsplash.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.6,
                    child: Text(
                      userDetail != null ? "Welcome, ${userDetail["name"]}" : "Loading...",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_pin_circle_outlined,
                          color: Colors.white,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 4,
                          ),
                          child: Text(
                            "${userDetail['location']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CachedNetworkImage(
                imageUrl: userDetail["image"] ??
                    "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669888811~exp=1669889411~hmac=ab35157190db779880c061298b0fa239e5bc753da4191dd09b0df84726227f4a",
                imageBuilder: (context, imageProvider) => Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return const Icon(Icons.error_outline_rounded);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          _searchBar(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.only(
        right: 24,
      ),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/map_unsplash.png'),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: TextFormField(
        // readOnly: '',
        // controller: _filter,
        // onTap: () {
        //   onTap();
        // },
        onChanged: (value) {
          // _getSearchResult();
        },
        style: const TextStyle(
          color: Colors.white,
        ),
        // autofocus: true,
        decoration: const InputDecoration(
          // contentPadding: EdgeInsets.all(8),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white,
            // size: 16,
          ),
          hintText: 'Where are you going?',
          hintStyle: TextStyle(
            color: Colors.white,
            // fontSize: 12,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFacilitiesBanner({
    @required String title,
    @required List<dynamic> facilities,
  }) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: _titleSeeMore(
            title: title,
            hasSeeMore: true,
            onClickSeeMore: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllFacilities(),
                ),
              ).then((value) => _callGetData());
            },
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        if (facilities.isNotEmpty)
          CarouselSlider(
            options: CarouselOptions(
                viewportFraction: 1.0,
                autoPlay: true,
                aspectRatio: 24 / 10,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (index, reason) {
                  // setState(() {
                  //   _current = index;
                  // });
                }),
            items: facilities.map((facility) {
              return Builder(
                builder: (BuildContext context) {
                  return IntrinsicHeight(
                    child: FacilityBanner(
                      detailFacility: facility,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailFacility(),
                          ),
                        );
                      },
                    ),
                  );
                  // GestureDetector(
                  //   onTap: () async {
                  //     print("===========facility $facility");
                  //   },
                  //   child: _facilityBanner(detailFacility: facility),
                  // );
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _titleSeeMore({
    @required String title,
    bool hasSeeMore = false,
    Function onClickSeeMore,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (hasSeeMore)
          InkWell(
            onTap: onClickSeeMore,
            splashFactory: NoSplash.splashFactory,
            child: Text(
              "See More",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue[900],
              ),
            ),
          ),
      ],
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
              if (facilitiesByCategory.isNotEmpty)
                for (var i = 0; i < facilitiesByCategory.length; i++)
                  Row(
                    children: [
                      FacilityCard(
                        detailFacility: facilitiesByCategory[i],
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
        if (categories.isNotEmpty)
          for (var i = 0; i < categories.length; i++)
            Row(
              children: [
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[i]["_id"];
                    });
                    _getFacilitiesByCategory();
                  },
                  child: Column(
                    children: [
                      Text(
                        categories[i]["name"],
                        style: TextStyle(
                          fontWeight: (selectedCategory == categories[i]["_id"])
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 18,
                          color: (selectedCategory == categories[i]["_id"])
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      if (selectedCategory == categories[i]["_id"])
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
