import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:flutter/material.dart';

class AllFacilities extends StatefulWidget {
  const AllFacilities({
    Key key,
  }) : super(key: key);

  @override
  State<AllFacilities> createState() => _AllFacilitiesState();
}

class _AllFacilitiesState extends State<AllFacilities> {
  var dummyApi = DummyApi();
  dynamic userDetail;
  List<dynamic> facilities = [];

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    super.initState();
  }

  _callGetData() async {
    setState(() {
      userDetail = dummyApi.getuserdetail["data"];
      facilities = dummyApi.getfacilities["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                  FacilityBanner(detailFacility: facilities[index]),
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
