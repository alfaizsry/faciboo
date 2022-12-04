import 'package:faciboo/components/empty_facilities.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/components/request_booking_card.dart';
import 'package:faciboo/screens/detail_facility.dart';
import 'package:faciboo/screens/detail_request_booking.dart';
import 'package:flutter/material.dart';

class MyBookedPage extends StatefulWidget {
  const MyBookedPage({Key key}) : super(key: key);

  @override
  State<MyBookedPage> createState() => _MyBookedPageState();
}

class _MyBookedPageState extends State<MyBookedPage>
    with SingleTickerProviderStateMixin {
  HttpService http = HttpService();
  bool _isLoading = false;
  // var dummyApi = DummyApi();
  dynamic userDetail;

  List<dynamic> allMyBook = [];
  List<dynamic> onPayMyBook = [];
  List<dynamic> onBookingMyBook = [];
  List<dynamic> historyMyBook = [];

  List<dynamic> userBookingList = [];

  int _currentIndex = 0;

  TabController _tabController;

  List<Tab> tabs = <Tab>[
    const Tab(
      text: 'All',
    ),
    const Tab(
      text: 'On Pay',
    ),
    const Tab(
      text: 'On Booking',
    ),
    const Tab(
      text: 'History',
    ),
  ];

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
    _getUserBooking();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _callGetData() async {
    // setState(() {
    //   userDetail = dummyApi.getuserdetail["data"];
    //   allMyBook = dummyApi.getAllMyBooking["data"];
    //   onPayMyBook = dummyApi.getOnPayMyBook["data"];
    //   onBookingMyBook = dummyApi.getOnBookingMyBook["data"];
    //   historyMyBook = dummyApi.getHistoryMyBook["data"];
    // });
    _getUserBooking();
  }

  _getUserBooking() async {
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "status": (_currentIndex != 0) ? _currentIndex - 1 : null,
    };
    await http.post('booking/get-user-booking', body: body).then((res) {
      if (res["success"]) {
        setState(() {
          userBookingList = res["data"];
        });
        print("================USERBOOKINGLIST $userBookingList");
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-user-booking $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingFallback(
      isLoading: _isLoading,
      child: Column(
        children: [
          const SizedBox(
            height: 64,
          ),
          _buildHeader(),
          const SizedBox(
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
      margin: const EdgeInsets.only(
        right: 24,
        left: 24,
      ),
      alignment: Alignment.topLeft,
      child: const Text(
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
      margin: const EdgeInsets.symmetric(
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
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
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
          _buildBookingList(),
          _buildBookingList(),
          _buildBookingList(),
          _buildBookingList(),
          // _buildListFacilities(facilities: onPayMyBook),
          // _buildListFacilities(facilities: onPayMyBook),
          // _buildListFacilities(facilities: onBookingMyBook),
          // _buildListFacilities(facilities: historyMyBook),
        ],
      ),
    );
  }

  Widget _buildBookingList() {
    return (userBookingList.isNotEmpty)
        ? ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            itemCount: userBookingList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Map item = userBookingList[index];
              return (item != null)
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 12),
                      child: RequestBookingCard(
                        facilityName: item["facility"]["name"],
                        facilityImage: item["facility"]["image"][0],
                        invoice: item["booking"]["invoice"],
                        date: (item["booking"]["bookingDate"].toString()) +
                            "/" +
                            (item["booking"]["bookingMonth"].toString()) +
                            "/" +
                            (item["booking"]["bookingYear"].toString()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailRequestBooking(
                                idBooking: item["booking"]["_id"],
                                onPop: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ).then((value) => _callGetData());
                        },
                      ),
                    )
                  : Container();
            },
          )
        : const EmptyFacilities(
            message: "There are no facility at this status",
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
      margin: const EdgeInsets.only(
        right: 24,
        left: 24,
      ),
      child: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  FacilityBanner(
                    detailFacility: facilities[index],
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailFacility(
                            idFacility: facilities[index]["_id"],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
