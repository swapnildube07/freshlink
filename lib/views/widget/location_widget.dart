import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Row(
        children: [
          Image.asset(
            "assets/icons/store.png",
            width: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Image.asset(
            "assets/icons/picking.png",
            width: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(child: SizedBox(
            width: 300,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor:  Colors.white,
                  filled: true,
                  hintText: 'Current Location',
                  labelText: 'Current Location',
                  border:  InputBorder.none,
                  isDense: true,
                ),
              ))),

        ],
      ),
    );
  }
}
