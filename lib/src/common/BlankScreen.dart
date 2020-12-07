import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tw_music_player/src/common/Constants.dart';

class BlankScreen extends StatelessWidget {
  final String _text;

  BlankScreen({@required String text}) : _text = text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Divider(
            height: 18,
            color: Constants.COLOR_TRANSPARENT,
          ),
          Text(
            _text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Constants.COLOR_TEXT_BLANK_SCREEN,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
