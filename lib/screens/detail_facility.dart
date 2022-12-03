import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/screens/schedule_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailFacility extends StatefulWidget {
  const DetailFacility({
    Key key,
    @required this.idFacility,
  }) : super(key: key);

  final String idFacility;

  @override
  State<DetailFacility> createState() => _DetailFacilityState();
}

class _DetailFacilityState extends State<DetailFacility> {
  HttpService http = HttpService();
  bool _isLoading = false;

  dynamic detailFacility = {};

  @override
  void initState() {
    // TODO: implement initState
    _callGetData();
    super.initState();
  }

  _callGetData() async {
    _getDetailFacility();
  }

  _getDetailFacility() async {
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "id": widget.idFacility,
    };
    await http.post('facility/get-detail-facility', body: body).then((res) {
      if (res["success"]) {
        setState(() {
          detailFacility = res["data"];
        });
        print("================DETAIL FACILITY $detailFacility");
      }

      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR detail-facility $err");

      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _launchUrl(String url) async {
    // if (!await launchUrl(Uri.parse(url))) {
    //   throw 'Could not launch $url';
    // }
    await launchUrl(Uri.parse(url));
    // await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(),
      body: LoadingFallback(
        isLoading: _isLoading,
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildModalDetail(),
          ],
        ),
      ),
    );
  }

  Widget _buildModalDetail() {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            // physics: ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildDetails(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detailFacility["name"] ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Text(
            detailFacility["address"] ?? "",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                textButton: "Check Availability",
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SchedulePickerPage(),
                    ),
                  );
                  // .then((value) => _callGetData());
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleContent(title: "Description"),
          SizedBox(
            height: 12,
          ),
          Text(
            detailFacility["description"] ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildTitleContent(title: "Photos"),
          SizedBox(
            height: 12,
          ),
          _buildPhotosHorizontal(),
          SizedBox(
            height: 20,
          ),
          _buildTitleContent(title: "Location"),
          SizedBox(
            height: 12,
          ),
          _buildLocationCard(),
          SizedBox(
            height: 20,
          ),
          _buildTitleContent(title: "Price"),
          SizedBox(
            height: 12,
          ),
          _buildPriceCard(),
          SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosHorizontal() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (detailFacility["image"] != null)
            for (var i = 0; i < detailFacility["image"].length; i++)
              Padding(
                padding: EdgeInsets.only(
                  right: 16,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        detailFacility["image"][i],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return InkWell(
      onTap: () {
        _launchUrl(detailFacility["urlMaps"]);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/maps_image.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            border: Border.all(width: 1, color: Colors.white),
          ),
          child: const Text(
            "Show Location",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        color: Colors.lightGreen[50],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Price",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "${detailFacility["price"]}/time",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          CustomButton(
            textButton: "Book Now",
            onClick: () {},
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitleContent({String title}) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            detailFacility["image"] != null
                ? detailFacility["image"][0]
                : "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          child: CustomArrowBack(
            onClick: () {
              Navigator.pop(context);
            },
          ),
        )
        // Container(
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: Colors.white,
        //   ),
        //   child: Icon(Icons.arrow_back_ios_new_rounded),
        // ),
        );
  }
}
