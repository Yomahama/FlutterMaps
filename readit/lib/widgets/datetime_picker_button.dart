import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';

typedef StringCallBack = Function(String date);

class DatetimePickerButton extends StatefulWidget {
  final StringCallBack onDateChanged;

  const DatetimePickerButton({this.onDateChanged});

  @override
  _DatetimePickerButtonState createState() => _DatetimePickerButtonState();
}

class _DatetimePickerButtonState extends State<DatetimePickerButton> {
  String _date = DateTime.now().toIso8601String().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        DatePicker.showDatePicker(context,
            theme: const DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true,
            minTime: DateTime(2020, 1, 1),
            maxTime: DateTime.now(), onConfirm: (date) {
          setState(() {
            _date = date.toIso8601String().substring(0, 10);
          });
          widget.onDateChanged(_date);
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      color: HexColor('#EFF1EB'),
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.date_range,
                      size: 18.0,
                      color: Colors.grey,
                    ),
                    Text("  $_date", style: style),
                  ],
                )
              ],
            ),
            Text(
              "  Change",
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  final style =
      const TextStyle(color: Colors.grey, fontFamily: 'Roboto', fontSize: 15);
}
