import 'package:flutter/material.dart';
import 'package:tw_music_player/src/common/Constants.dart';

class EmptyAlbumArtContainer extends StatelessWidget {
  const EmptyAlbumArtContainer({
    Key key,
    @required double radius,
    @required double albumArtSize,
    @required double iconSize,
  })  : _radius = radius,
        _albumArtSize = albumArtSize,
        _iconSize = iconSize,
        super(key: key);

  final double _radius;
  final double _albumArtSize;
  final double _iconSize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _albumArtSize,
            color: Constants.COLOR_GREY,
            child: Center(
              child: Icon(
                Icons.music_note,
                size: _iconSize,
                color: Constants.COLOR_TEXT_BLANK_SCREEN,
              ),
            ),
          ),
          Opacity(
            opacity: 0.55,
            child: Container(
              width: double.infinity,
              height: _albumArtSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [
                    0.0,
                    0.85,
                  ],
                  colors: [
                    Constants.COLOR_TEXT_BLANK_SCREEN,
                    Constants.COLOR_APP_TEXT,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
