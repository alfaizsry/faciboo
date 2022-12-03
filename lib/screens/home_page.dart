import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:faciboo/components/empty_facilities.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/components/facility_card.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
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

  bool _isLoading = false;

  List<dynamic> facilities = [];
  List<dynamic> facilitiesByCategory = [];
  List<dynamic> searchResult = [];
  List<dynamic> categories = [];

  TextEditingController _filter = TextEditingController();

  @override
  void initState() {
    _callGetData();
    super.initState();
  }

  _callGetData() async {
    await _getProfile();
    await _getFacilities();
    _getCategories();
  }

  _getProfile() async {
    setState(() {
      _isLoading = true;
    });
    await http.post('profile/get-profile').then((res) {
      if (res["success"]) {
        setState(() {
          userDetail = res["data"];
        });
        print("================USERDETAIL $userDetail");
      }

      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-profile $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getFacilities() async {
    setState(() {
      _isLoading = true;
    });
    await http.post('facility/get-facility').then((res) {
      if (res["success"]) {
        setState(() {
          facilities = res["data"];
        });
        print("================FACILITIES $facilities");
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-facility $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getSearchResult() async {
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "search": _filter.text,
    };
    await http.post('facility/search-facility', body: body).then((res) {
      if (res["success"]) {
        setState(() {
          searchResult = res["data"];
        });
        print("================Searhced FACILITIES $facilities");
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR search-facility $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getCategories() async {
    setState(() {
      _isLoading = true;
    });
    await http.post('category/get-category').then((res) {
      if (res["success"]) {
        setState(() {
          categories = res["data"];
          selectedCategory = categories[0]["_id"];
          print(categories);
          _getFacilitiesByCategory(categories[0]["_id"]);
        });
        print("================CATEGORY $categories");
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-category $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getFacilitiesByCategory(String id) async {
    Map body = {
      "id": id,
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
      body: LoadingFallback(
        isLoading: _isLoading,
        child: ListView(
          children: [
            const SizedBox(
              height: 48,
            ),
            _buildUserBanner(),
            const SizedBox(
              height: 24,
            ),
            if (searchResult.isNotEmpty) _buildSearchResult(),
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
              title: "All Facilities",
              facilities: facilities,
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResult() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleSeeMore(title: "Search Results", hasSeeMore: false),
          SizedBox(height: 8),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: searchResult.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                height: 175,
                child: FacilityBanner(
                  detailFacility: searchResult[index],
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailFacility(
                          idFacility: searchResult[index]["_id"],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 16,
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/map_unsplash.png'),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
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
                      userDetail != null
                          ? "Welcome, ${userDetail["name"]}"
                          : "Loading...",
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
                            "${userDetail['address']}",
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
                imageUrl: userDetail["imageUrl"] ??
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
                  return Container(
                    width: 50.0,
                    height: 50.0,
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
        controller: _filter,
        // onTap: () {
        //   onTap();
        // },
        onChanged: (value) {
          if (_filter.text != "")
            _getSearchResult();
          else {
            setState(() {
              searchResult = [];
            });
          }
        },
        style: const TextStyle(
          color: Colors.white,
        ),
        // autofocus: true,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.all(8),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white,
            // size: 16,
          ),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _filter.text = "";
                searchResult = [];
              });
            },
            child: Icon(
              Icons.clear_rounded,
              color: Colors.white,
            ),
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
        (facilities.isNotEmpty)
            ? CarouselSlider(
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
                                builder: (context) => DetailFacility(
                                  idFacility: facility["_id"],
                                ),
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
              )
            : EmptyFacilities(),
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
        (facilitiesByCategory.isNotEmpty)
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    for (var i = 0; i < facilitiesByCategory.length; i++)
                      Row(
                        children: [
                          FacilityCard(
                            detailFacility: facilitiesByCategory[i],
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailFacility(
                                    idFacility: facilitiesByCategory[i]
                                            ["_id"] ??
                                        facilitiesByCategory[i]["id"],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                  ],
                ),
              )
            : EmptyFacilities(),
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

                    _getFacilitiesByCategory(categories[i]["_id"]);
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
