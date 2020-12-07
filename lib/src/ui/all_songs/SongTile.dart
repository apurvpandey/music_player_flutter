import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/common/MusicPlayerIcons.dart';
import 'package:tw_music_player/src/models/PlayerState.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';

// ignore: must_be_immutable
class SongTile extends StatelessWidget {
  final Results _song;
  String _artists;
  String _duration;
  String _album;

  SongTile({Key key, @required Results song})
      : _song = song,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    _parseArtists();
    _parseDuration();
    _parseAlbum();
    return StreamBuilder<MapEntry<PlayerState, Results>>(
        stream: globalBloc.musicPlayerBloc.playerState,
        builder: (BuildContext context,
            AsyncSnapshot<MapEntry<PlayerState, Results>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final PlayerState state = snapshot.data.key;
          final Results currentSong = snapshot.data.value;
          final bool isSelectedSong = _song == currentSong;
          return AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: isSelectedSong
                  ? LinearGradient(
                      colors: [
                        Constants.COLOR_BACKGROUND_NOW_PLAYING.withOpacity(0.9),
                        Constants.COLOR_WHITE,
                      ],
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Divider(
                    color: Constants.COLOR_TRANSPARENT,
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: AnimatedCrossFade(
                            duration: Duration(
                              milliseconds: 150,
                            ),
                            firstChild: PauseIcon(
                              color: Constants.COLOR_ICON_SONG_TILE,
                            ),
                            secondChild: PlayIcon(
                              color: Constants.COLOR_APP_TEXT,
                            ),
                            crossFadeState:
                                isSelectedSong && state == PlayerState.playing
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _song.trackName != null
                                      ? _song.trackName
                                      : '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Constants.COLOR_APP_TEXT,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Divider(
                                  height: 10,
                                  color: Constants.COLOR_TRANSPARENT,
                                ),
                                Text(
                                  _artists != null
                                      ? _artists.toUpperCase()
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Constants.COLOR_APP_TEXT,
                                    letterSpacing: 1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Divider(
                                  height: 5,
                                  color: Constants.COLOR_TRANSPARENT,
                                ),
                                Text(
                                  _album != null ? _album : ' ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Constants.COLOR_APP_TEXT,
                                    letterSpacing: 1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: Text(
                            _duration != null ? _duration : '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Constants.COLOR_APP_TEXT,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isSelectedSong
                      ? Row(
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                              ),
                            ),
                            Flexible(
                              flex: 14,
                              child: StreamBuilder<Duration>(
                                stream: globalBloc.musicPlayerBloc.position,
                                builder: (BuildContext context,
                                    AsyncSnapshot<Duration> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Slider(
                                      value: 0,
                                      onChanged: (double value) => null,
                                      activeColor: Constants.COLOR_TRANSPARENT,
                                      inactiveColor:
                                          Constants.COLOR_TRANSPARENT,
                                    );
                                  }
                                  final Duration currentDuration =
                                      snapshot.data;
                                  final int milliSeconds =
                                      currentDuration.inMilliseconds;
                                  final int songDurationInMilliseconds =
                                      currentSong.trackTimeMillis;
                                  return Slider(
                                    min: 0,
                                    max: songDurationInMilliseconds.toDouble(),
                                    value: songDurationInMilliseconds >
                                            milliSeconds
                                        ? milliSeconds.toDouble()
                                        : songDurationInMilliseconds.toDouble(),
                                    onChangeStart: (double value) => globalBloc
                                        .musicPlayerBloc
                                        .invertSeekingState(),
                                    onChanged: (double value) {
                                      final Duration duration = Duration(
                                        milliseconds: value.toInt(),
                                      );
                                      globalBloc.musicPlayerBloc
                                          .updatePosition(duration);
                                    },
                                    onChangeEnd: (double value) {
                                      globalBloc.musicPlayerBloc
                                          .invertSeekingState();
                                      globalBloc.musicPlayerBloc
                                          .audioSeek(value / 1000);
                                    },
                                    activeColor: Constants.COLOR_SEEKBAR_ACTIVE,
                                    inactiveColor:
                                        Constants.COLOR_SEEKBAR_INACTIVE,
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  void _parseDuration() {
    final trackTime = _song.trackTimeMillis;
    if (trackTime != null) {
      final double temp = trackTime / 1000;
      final int minutes = (temp / 60).floor();
      final int seconds = (((temp / 60) - minutes) * 60).round();
      if (seconds.toString().length != 1) {
        _duration = minutes.toString() + ":" + seconds.toString();
      } else {
        _duration = minutes.toString() + ":0" + seconds.toString();
      }
    }
  }

  void _parseArtists() {
    _artists = _song.artistName.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }

  void _parseAlbum() {
    _album = _song.collectionName;
  }
}
