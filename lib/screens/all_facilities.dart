import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:faciboo/screens/detail_facility.dart';
import 'package:flutter/material.dart';

class AllFacilities extends StatefulWidget {
  const AllFacilities({
    Key key,
  }) : super(key: key);

  @override
  State<AllFacilities> createState() => _AllFacilitiesState();
}

class _AllFacilitiesState extends State<AllFacilities> {
  HttpService http = HttpService();

  bool _isLoading = false;

  var dummyApi = DummyApi();
  dynamic userDetail = {};
  List<dynamic> facilities = [];

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    super.initState();
  }

  _callGetData() async {
    // setState(() {
    //   userDetail = dummyApi.getuserdetail["data"];
    //   facilities = dummyApi.getfacilities["data"];
    // });
    await _getProfile();
    await _getFacilities();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingFallback(
        isLoading: _isLoading,
        child: ListView(
          children: [
            _buildAppbar(),
            const SizedBox(
              height: 30,
            ),
            _buildHeader(),
            const SizedBox(
              height: 16,
            ),
            _buildListFacilities(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return Container(
      margin: const EdgeInsets.only(
        top: 32,
        left: 24,
        right: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomArrowBack(
            onClick: () {
              Navigator.of(context).pop();
            },
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
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(
        right: 24,
        left: 24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "All Facility",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Result Found (${facilities.length})",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Sort By",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.filter_list_rounded,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListFacilities() {
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
                  Container(
                    height: 175,
                    child: FacilityBanner(
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
