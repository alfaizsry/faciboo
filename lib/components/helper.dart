import 'package:intl/intl.dart';

class Helper {
  String priceParser(dynamic initial) {
    String result = NumberFormat().format(initial).toString().replaceAll(',', '.');
    return 'Rp. $result';
  }

  String dateTimeToString(DateTime initial) {
    String formatted = DateFormat('d MMMM yyyy').format(initial);
    return formatted;
  }

  String dateParser(int date) {
    if (date < 10) {
      return '0$date';
    } else {
      return '$date';
    }
  }

  List dateAndTimeListParser(List data) {
    List parsingResult = [];
    for (var item in data) {
      String tempDate = dateParser(item['date']);
      parsingResult.add({
        'date': '${item['year']}-${item['month']}-$tempDate',
        'available_hour': item['availableHour']
      });
    }
    return parsingResult;
  }

  List<DateTime> dateListParser(List data) {
    List<DateTime> parsingResult = [];
    for (var item in data) {
      parsingResult.add(DateTime.parse(item['date']));
    }
    return parsingResult;
  }
}