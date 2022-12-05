import 'package:faciboo/components/http_service.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomAlert {
  CustomAlert({this.context});
  final BuildContext context;

  HttpService http = HttpService();

  Future alertDialog({
    @required String text = "",
  }) {
    return Alert(
      style: AlertStyle(
        isCloseButton: false,
      ),
      context: context,
      type: AlertType.warning,
      title: "Warning!",
      content: Column(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.green,
        ),
      ],
    ).show();
  }

  Future alertConfirmation({
    @required String titleAlert = "",
    @required String textAlert = "",
    @required String textFirstButton,
    @required String textSecondButton,
    @required Function onTapFirstButton,
    @required Function onTapSecondButton,
  }) {
    return Alert(
      style: AlertStyle(
        isCloseButton: false,
      ),
      context: context,
      // type: AlertType.,
      title: titleAlert,
      content: Column(
        children: [
          Text(
            textAlert,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            textFirstButton,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onTapFirstButton,
          color: Colors.green,
        ),
        DialogButton(
          child: Text(
            textSecondButton,
            style: TextStyle(color: Colors.red),
          ),
          onPressed: onTapSecondButton,
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.red),
        ),
      ],
    ).show();
  }
}
