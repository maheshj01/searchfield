import 'package:flutter/material.dart';

extension FurdleTitle on String {
  Widget toTitle({double boxSize = 25}) {
    return Material(
      color: Colors.transparent,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (int i = 0; i < length; i++)
          Container(
              height: boxSize,
              width: boxSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ) +
                  EdgeInsets.only(bottom: i.isOdd ? 8 : 0),
              child: Text(
                this[i].toUpperCase(),
                style: const TextStyle(
                    height: 1.1,
                    letterSpacing: 2,
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              decoration: this[i] == ' '
                  ? null
                  : BoxDecoration(boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 8,
                          color: Colors.black,
                          offset: Offset(0, 1)),
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(2, -1)),
                    ], color: Colors.blueAccent))
      ]),
    );
  }
}
