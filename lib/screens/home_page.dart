import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dummyApi = DummyApi();
  dynamic userDetail;
  //categori 1: sports, 2:entertainment, 3:workspace,
  List<dynamic> facilities = [];
  List<dynamic> facilitiesByCategory = [];

  @override
  void initState() {
    setState(() {
      userDetail = dummyApi.getuserdetail["data"];
      facilities = dummyApi.getfacilities["data"];
      facilitiesByCategory = dummyApi.getfacilitiesByCartegory["data"];
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildUserBanner(),
          SizedBox(
            height: 16,
          ),
          _buildFacilitiesBanner(),
        ],
      ),
    );
  }

  Widget _buildUserBanner() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 4.5,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: 32,
      ),
      margin: EdgeInsets.only(
        top: 48,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
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
                  Text(
                    "Welcome, ${userDetail["name"]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_pin_circle_outlined,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 4,
                          ),
                          child: Text(
                            "${userDetail['location']}",
                            style: TextStyle(
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
                imageUrl: userDetail["image"],
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
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          _searchBar(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.only(
        right: 24,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/map_unsplash.png'),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(
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
        style: TextStyle(
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

  Widget _buildFacilitiesBanner() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: _titleSeeMore(
            title: "New Facilities",
            hasSeeMore: true,
            onClickSeeMore: () {},
          ),
        ),
        SizedBox(
          height: 8,
        ),
        CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1.0,
              autoPlay: true,
              // height: 160,
              aspectRatio: 26 / 10,
              autoPlayInterval: Duration(seconds: 5),
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
                    onClick: () {},
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

  // Widget _facilityBanner({
  //   @required dynamic detailFacility,
  // }) {
  //   return Container(
  //     alignment: Alignment.bottomLeft,
  //     padding: EdgeInsets.only(
  //       top: 80,
  //       left: 20,
  //       right: 20,
  //       bottom: 24,
  //     ),
  //     width: MediaQuery.of(context).size.width - 48,
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         colorFilter: new ColorFilter.mode(
  //             Colors.black.withOpacity(0.3), BlendMode.darken),
  //         image: NetworkImage(
  //           detailFacility["image"],
  //         ),
  //         fit: BoxFit.cover,
  //       ),
  //       // border: Border.all(width: 2, color: Colors.black),
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(25),
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           detailFacility["name"],
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.w500,
  //             fontSize: 16,
  //           ),
  //         ),
  //         SizedBox(
  //           height: 4,
  //         ),
  //         Text(
  //           detailFacility["location"],
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.w300,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
          style: TextStyle(
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
}
