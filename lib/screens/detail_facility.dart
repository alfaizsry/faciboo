import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:flutter/material.dart';

class DetailFacility extends StatefulWidget {
  const DetailFacility({Key key}) : super(key: key);

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
    return SingleChildScrollView(
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.2,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: ListView(
              children: [
                _buildHeader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Swimming Pool",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.2,
      decoration: BoxDecoration(
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
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.all(8),
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
