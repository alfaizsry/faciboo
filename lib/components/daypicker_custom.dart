import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:faciboo/components/custom_calender/event.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class DayPickerCustom extends StatefulWidget {
  const DayPickerCustom(
      {Key key, this.events, this.onSelectDate, this.initialSelect, this.listEnableDate})
      : super(key: key);

  final List<Event> events;
  final Function onSelectDate;
  final String initialSelect;
  final List listEnableDate;
  @override
  State<DayPickerCustom> createState() => _DayPickerCustomState();
}

class _DayPickerCustomState extends State<DayPickerCustom> {
  DateTime _selectedDate;

  Color selectedDateStyleColor = Colors.white;
  Color selectedSingleDateDecorationColor = Colors.green[600];

  bool _decideWhichDayToEnable(DateTime day) {
    dynamic idxOf = widget.listEnableDate.indexOf(day);
    if (idxOf != -1) {
      return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    initDate();
  }

  void initDate() {
    if (widget.initialSelect != null) {
      setState(() {
        _selectedDate = DateTime.parse(widget.initialSelect);
      });
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   selectedDateStyleColor = Theme.of(context).colorScheme.onSecondary;
  //   selectedSingleDateDecorationColor = Theme.of(context).colorScheme.secondary;
  // }

  void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });

    widget.onSelectDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    DateTime _firstDate = widget.listEnableDate[0];
    DateTime _lastDate =
        widget.listEnableDate[widget.listEnableDate.length - 1].add(const Duration(days: 1));
    // add selected colors to default settings
    dp.DatePickerRangeStyles styles = dp.DatePickerRangeStyles(
      currentDateStyle: TextStyle(color: Colors.green[600]),
      selectedDateStyle:
          Theme.of(context).textTheme.bodyText1?.copyWith(color: selectedDateStyleColor),
      selectedSingleDateDecoration:
          BoxDecoration(color: selectedSingleDateDecorationColor, shape: BoxShape.circle),
      dayHeaderStyle: DayHeaderStyle(textStyle: TextStyle(color: Colors.grey[600], fontSize: 12)),
      // dayHeaderTitleBuilder: _dayHeaderTitleBuilder,
    );

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: dp.DayPicker.single(
              selectedDate: _selectedDate,
              onChanged: _onSelectedDateChanged,
              firstDate: _firstDate,
              lastDate: _lastDate,
              selectableDayPredicate: _decideWhichDayToEnable,
              datePickerStyles: styles,
            ),
          ),
        ],
      ),
    );
  }
}
