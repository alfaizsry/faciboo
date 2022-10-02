import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:flutter/material.dart';

class MyBookedPage extends StatefulWidget {
  const MyBookedPage({Key key}) : super(key: key);

  @override
  State<MyBookedPage> createState() => _MyBookedPageState();
}

class _MyBookedPageState extends State<MyBookedPage>
    with SingleTickerProviderStateMixin {
  var dummyApi = DummyApi();
  dynamic userDetail;

  List<dynamic> allMyBook = [];
  List<dynamic> onPayMyBook = [];
  List<dynamic> onBookingMyBook = [];
  List<dynamic> historyMyBook = [];

  TabController _tabController;

  List<Tab> tabs = <Tab>[
    Tab(
      text: 'On Pay',
    ),
    Tab(
      text: 'On Booking',
    ),
    Tab(
      text: 'History',
    ),
  ];

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: tabs.length);
    super.initState();
  }

  _callGetData() async {
    setState(() {
      userDetail = dummyApi.getuserdetail["data"];
      allMyBook = dummyApi.getAllMyBooking["data"];
      onPayMyBook = dummyApi.getOnPayMyBook["data"];
      onBookingMyBook = dummyApi.getOnBookingMyBook["data"];
      historyMyBook = dummyApi.getHistoryMyBook["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 64,
          ),
          _buildHeader(),
          SizedBox(
            height: 20,
          ),
          _buildTabBar(),
          _buildTabView(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(
        right: 24,
        left: 24,
      ),
      alignment: Alignment.topLeft,
      child: Text(
        "My Booking",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.green[900],
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(width: 5, color: Colors.green[50]),
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.green[900],
        tabs: tabs,
      ),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildListFacilities(facilities: onPayMyBook),
          _buildListFacilities(facilities: onBookingMyBook),
          _buildListFacilities(facilities: historyMyBook),
        ],
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     margin: EdgeInsets.only(
  //       right: 24,
  //       left: 24,
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "My Booking",
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(
  //               height: 8,
  //             ),
  //             Text(
  //               "Result Found (${allMyBook.length})",
  //               style: TextStyle(
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "Sort By",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(
  //               width: 8,
  //             ),
  //             Icon(
  //               Icons.filter_list_rounded,
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _buildListFacilities({
    @required List<dynamic> facilities,
  }) {
    return Container(
      margin: EdgeInsets.only(
        right: 24,
        left: 24,
      ),
      child: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  FacilityBanner(detailFacility: facilities[index]),
                  SizedBox(
                    height: 12,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
