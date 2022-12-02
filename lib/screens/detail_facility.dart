import 'dart:ffi';

import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/screens/schedule_picker.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildModalDetail(),
        ],
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
          const Text(
            "Swimming Pool",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Text(
            "Evenciio Apartment, Depok",
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
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam maximus sollicitudin dui eget commodo. Praesent vel placerat lorem. Integer lacinia in massa porta sodales. Maecenas maximus mauris id turpis posuere, a posuere ipsum varius. Etiam id lacinia felis. Duis ut tristique quam. Maecenas consequat felis ut ullamcorper mollis. Fusce vulputate convallis erat, in fringilla purus blandit vel. \n\nNunc id finibus nunc. Nulla auctor et diam at congue. Quisque varius pellentesque risus quis hendrerit. Maecenas neque odio, hendrerit in enim sed, elementum ullamcorper dui. Ut aliquam elementum ornare. Fusce posuere nec enim a vehicula.",
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildTitleContent(title: "Photos"),
          const SizedBox(
            height: 12,
          ),
          _buildPhotosHorizontal(),
          const SizedBox(
            height: 20,
          ),
          _buildTitleContent(title: "Location"),
          const SizedBox(
            height: 12,
          ),
          _buildLocationCard(),
          const SizedBox(
            height: 20,
          ),
          _buildTitleContent(title: "Price"),
          const SizedBox(
            height: 12,
          ),
          _buildPriceCard(),
          const SizedBox(
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
          for (var i = 0; i < 5; i++)
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
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
    return Container(
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
                "Total Cost",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Rp. 250.000/ hour",
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
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
