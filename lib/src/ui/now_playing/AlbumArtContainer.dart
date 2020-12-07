import 'package:flutter/material.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';

class AlbumArtContainer extends StatelessWidget {
  const AlbumArtContainer({
    Key key,
    @required double radius,
    @required double albumArtSize,
    @required Results currentSong,
  })  : _radius = radius,
        _albumArtSize = albumArtSize,
        _currentSong = currentSong,
        super(key: key);

  final double _radius;
  final double _albumArtSize;
  final Results _currentSong;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _albumArtSize,
            child: Image.network(
              _currentSong.artworkUrl100,
              fit: BoxFit.fill,
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
