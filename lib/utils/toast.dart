import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static toast(context, msg) {
    FlutterToast flutterToast = FlutterToast(context);
    flutterToast.showToast(
        child: Material(
            color: Colors.deepOrange,
            elevation: 4.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                msg,
                style: TextStyle(color: Colors.white),
              ),
            )),
        toastDuration: Duration(seconds: 3),
        gravity: ToastGravity.BOTTOM);
  }
}
