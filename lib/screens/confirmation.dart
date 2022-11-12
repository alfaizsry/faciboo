import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:flutter/material.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  List _listTimePicker = [
    {
      'date': '2022-11-12',
      'time': '08.00 - 09.30',
      'schedule_id': 1,
    },
    {
      'date': '2022-11-12',
      'time': '11.00 - 12.30',
      'schedule_id': 2,
    },
    {
      'date': '2022-11-12',
      'time': '13.00 - 14.30',
      'schedule_id': 3,
    },
    {
      'date': '2022-11-12',
      'time': '15.00 - 16.30',
      'schedule_id': 4,
    },
    {
      'date': '2022-11-12',
      'time': '17.00 - 18.30',
      'schedule_id': 5,
    },
  ];
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: CustomArrowBack(
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Confirmation",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyDetailsConfirmation() {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.only(top: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: const Text(
              'Your Book',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '12 November 2022',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hours',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: width * 0.3,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _listTimePicker.length,
                      itemBuilder: (BuildContext context, int i) {
                        return SizedBox(
                          width: double.infinity,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4, top: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.green[600]),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                _listTimePicker[i]['time'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'x${_listTimePicker.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  'Rp. 250.000',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            width: width,
            height: 0.5,
            color: Colors.black,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  'Rp. 250.000',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _continueButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 32),
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () {
            //TODO
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.green[600],
              border: Border.all(color: Colors.green[600]),
            ),
            child: const Text('Continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildHeader(),
          _buildBodyDetailsConfirmation(),
          _continueButton()
        ],
      ),
    );
  }
}
