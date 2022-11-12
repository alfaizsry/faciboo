import 'package:faciboo/components/custom_calender/event.dart';
import 'package:faciboo/components/daypicker_custom.dart';
import 'package:faciboo/screens/confirmation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePickerPage extends StatefulWidget {
  const SchedulePickerPage({Key key, @required this.dataSubFacility, @required this.dataUser})
      : super(key: key);

  final dynamic dataSubFacility;
  final dynamic dataUser;
  @override
  State<SchedulePickerPage> createState() => _SchedulePickerPageState();
}

class _SchedulePickerPageState extends State<SchedulePickerPage> {
  bool isLoading = false;
  bool isLoadingDatePicker = true;
  List _listDatePicker = [];
  List _listDummyDatePicker = [
    {'date': '2022-11-02'},
    {'date': '2022-11-03'},
    {'date': '2022-11-04'},
    {'date': '2022-11-05'},
    {'date': '2022-11-06'},
    {'date': '2022-11-07'},
    {'date': '2022-11-08'},
    {'date': '2022-11-09'},
    {'date': '2022-11-11'},
    {'date': '2022-11-11'},
    {'date': '2022-11-12'},
  ];
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
  List _listSelectedScheduleId = [];
  DateTime selectedDate;
  String selectTimeMsg = 'Please select your desired date first!';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    for (var item in _listDummyDatePicker) {
      _listDatePicker.add(DateTime.parse(item['date']));
    }
    selectedDate = DateTime.parse(_listDummyDatePicker[0]['date']);
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.chevron_left_sharp, size: 36, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
          alignment: Alignment.topLeft,
          child: const Text(
            "Check Availability",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _datePicker() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final DateTime now = DateTime.now();
    DateFormat df = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(now);
    List<Event> events = [Event(DateTime.parse(formatted), "Pemilihan Pertama")];
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 1,
        child: DayPickerCustom(
          events: events,
          listEnableDate: _listDatePicker,
          initialSelect: selectedDate.toString(),
          onSelectDate: (DateTime selected) async {
            setState(() {
              selectedDate = selected;
              _listSelectedScheduleId = [];
              _listTimePicker = [];
              //TODO ubah jadi true pas dah ada API
              isLoading = false;
            });
          },
        ),
      ),
    );
  }

  Widget _timePicker() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    if (isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: height * 0.25,
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (_listTimePicker.isEmpty && !isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: height * 0.25,
        width: width * 0.55,
        child: Text(selectTimeMsg, textAlign: TextAlign.center),
        alignment: Alignment.center,
      );
    }

    if (_listTimePicker.isNotEmpty && !isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: height * 0.25,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Select Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  subtitle: GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: _listTimePicker.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 8, childAspectRatio: 4 / 1),
                      itemBuilder: (BuildContext context, int i) {
                        int idxOf =
                            _listSelectedScheduleId.indexOf(_listTimePicker[i]['schedule_id']);
                        bool isSelected = idxOf != -1;

                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _listSelectedScheduleId.removeAt(idxOf);
                                } else {
                                  if (_listSelectedScheduleId.length == _listTimePicker.length)
                                    return;
                                  _listSelectedScheduleId.add(_listTimePicker[i]['schedule_id']);
                                }
                              });
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.green[600] : Colors.white,
                                  border: Border.all(
                                      color: isSelected ? Colors.blueGrey[300] : Colors.black26),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(_listTimePicker[i]['time'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected == true ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            )
          ],
        ),
      );
    }

    return Container();
  }

  Widget _continueButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () {
            //TODO
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ConfirmationScreen()));
            // if (!isLoading && _listTimePicker.length > 0) bookAction();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: isLoading || _listTimePicker.isEmpty ? Colors.grey : Colors.green[600],
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
        children: [_buildHeader(), _datePicker(), _timePicker(), _continueButton()],
      ),
    );
  }
}
