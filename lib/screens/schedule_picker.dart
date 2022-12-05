import 'package:faciboo/components/custom_calender/event.dart';
import 'package:faciboo/components/daypicker_custom.dart';
import 'package:faciboo/components/helper.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/screens/confirmation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePickerPage extends StatefulWidget {
  const SchedulePickerPage(this.dataFacility, {Key key}) : super(key: key);

  final dynamic dataFacility;
  @override
  State<SchedulePickerPage> createState() => _SchedulePickerPageState();
}

class _SchedulePickerPageState extends State<SchedulePickerPage> {
  HttpService http = HttpService();

  bool isLoading = false;
  bool isLoadingDatePicker = true;

  List listDatePicker = [];
  List<DateTime> listDate = [];
  List listTimePicker = [];
  List<String> listSelectedHour = [];

  DateTime selectedDate;
  String selectTimeMsg = 'Please select your desired date first!';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  void onSelectDatePicker(DateTime selected) {
    int idxOf = listDate.indexOf(selected);
    setState(() {
      selectedDate = selected;
      listSelectedHour.clear();
      listTimePicker = listDatePicker[idxOf]['available_hour'];
      isLoading = false;
    });
  }

  void onSelectTimePicker(bool isSelected, int idxOf, String hourAdded) {
    setState(() {
      if (isSelected) {
        listSelectedHour.removeAt(idxOf);
      } else {
        if (listSelectedHour.length == listTimePicker.length) return;
        listSelectedHour.add(hourAdded);
      }
    });
  }

  void onTapContinue() {
    Map data = {
      'id': widget.dataFacility["_id"],
      'date_time': selectedDate,
      'year': selectedDate.year,
      'month': selectedDate.month,
      'date': selectedDate.day,
      'hour': listSelectedHour,
      'base_price': widget.dataFacility['price']
    };

    if (!isLoading && listSelectedHour.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmationScreen(data)));
    }
  }

  void getCallData() {
    setState(() {
      isLoading = true;
    });
    Map body = {"id": widget.dataFacility["_id"]};
    print("BODY REQUEST AVAILABLE DATE ====> $body");
    http.post('facility/get-available-date', body: body).then((res) async {
      if (res['success']) {
        setState(() {
          listDatePicker = Helper().dateAndTimeListParser(res['data']);
          listDate = Helper().dateListParser(listDatePicker);
          selectedDate = listDate[0];
          isLoading = false;
          listTimePicker = listDatePicker[0]['available_hour'];
        });
      }
    }).catchError((onError) {
      print(onError);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCallData();
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
    final DateTime now = DateTime.now();
    final String formatted = formatter.format(now);
    List<Event> events = [Event(DateTime.parse(formatted), "Pemilihan Pertama")];
    if (listDate.isNotEmpty && !isLoading) {
      return Container(
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AspectRatio(
          aspectRatio: 1,
          child: DayPickerCustom(
            events: events,
            listEnableDate: listDate,
            initialSelect: selectedDate.toString(),
            onSelectDate: (DateTime selected) async {
              onSelectDatePicker(selected);
            },
          ),
        ),
      );
    }
    return Container();
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

    if (listTimePicker.isEmpty && !isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: height * 0.25,
        width: width * 0.55,
        child: Text(selectTimeMsg, textAlign: TextAlign.center),
        alignment: Alignment.center,
      );
    }

    if (listTimePicker.isNotEmpty && !isLoading) {
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
                      itemCount: listTimePicker.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 8, childAspectRatio: 4 / 1),
                      itemBuilder: (BuildContext context, int i) {
                        int idxOf = listSelectedHour.indexOf(listTimePicker[i]);
                        bool isSelected = idxOf != -1;

                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: InkWell(
                            onTap: () {
                              onSelectTimePicker(isSelected, idxOf, listTimePicker[i]);
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
                                  child: Text(listTimePicker[i],
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
            onTapContinue();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: isLoading || listTimePicker.isEmpty ? Colors.grey : Colors.green[600],
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
