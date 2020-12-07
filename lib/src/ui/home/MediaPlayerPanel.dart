import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/common/MusicPlayerIcons.dart';
import 'package:tw_music_player/src/models/PlayerState.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';

class MediaPlayerPanel extends StatelessWidget {
  final PanelController _controller;

  MediaPlayerPanel({@required PanelController controller})
      : _controller = controller;

  static const _LABEL_NOW_PLAYING = 'Now Playing';

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      child: StreamBuilder<MapEntry<PlayerState, Results>>(
        stream: globalBloc.musicPlayerBloc.playerState,
        builder: (BuildContext context,
            AsyncSnapshot<MapEntry<PlayerState, Results>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final PlayerState state = snapshot.data.key;
          final Results currentSong = snapshot.data.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          if (currentSong.previewUrl == null) {
                            return;
                          }
                          if (PlayerState.paused == state) {
                            globalBloc.musicPlayerBloc.playMusic(currentSong);
                          } else {
                            globalBloc.musicPlayerBloc.pauseMusic(currentSong);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: state == PlayerState.playing
                              ? PauseIcon(
                                  color: Constants.COLOR_APP_TEXT,
                                )
                              : PlayIcon(
                                  color: Constants.COLOR_APP_TEXT,
                                ),
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
                                _LABEL_NOW_PLAYING,
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
                                color: Colors.transparent,
                              ),
                              Text(
                                "",
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
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => _controller.open(),
                          child: ShowIcon(
                            color: Constants.COLOR_APP_TEXT,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                      ),
                    ),
                    Flexible(
                      flex: 12,
                      child: StreamBuilder<Duration>(
                          stream: globalBloc.musicPlayerBloc.position,
                          builder: (BuildContext context,
                              AsyncSnapshot<Duration> snapshot) {
                            if (state == PlayerState.stopped ||
                                !snapshot.hasData) {
                              return Slider(
                                value: 0,
                                onChanged: (double value) => null,
                                activeColor: Colors.transparent,
                                inactiveColor: Colors.transparent,
                              );
                            }
                            final Duration currentDuration = snapshot.data;
                            final int milliseconds =
                                currentDuration.inMilliseconds;
                            final int songDurationInMilliseconds =
                                currentSong.trackTimeMillis;
                            return Slider(
                              min: 0,
                              max: songDurationInMilliseconds.toDouble(),
                              value: songDurationInMilliseconds > milliseconds
                                  ? milliseconds.toDouble()
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
                                globalBloc.musicPlayerBloc.invertSeekingState();
                                globalBloc.musicPlayerBloc
                                    .audioSeek(value / 1000);
                              },
                              activeColor: Constants.COLOR_APP_TEXT,
                              inactiveColor:
                                  Constants.COLOR_APP_TEXT.withOpacity(0.5),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
