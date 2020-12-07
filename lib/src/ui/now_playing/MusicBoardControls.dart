import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/models/PlayerState.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';

class MusicBoardControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Container(
      height: 100,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 245,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Constants.COLOR_WHITE,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Constants.COLOR_BLACK.withOpacity(0.15),
                    blurRadius: 20,
                    offset: Offset(2, 1.5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: GestureDetector(
                      onTap: () =>
                          globalBloc.musicPlayerBloc.playPreviousSong(),
                      child: Icon(
                        Icons.fast_rewind,
                        color: Constants.COLOR_ICON_SONG_TILE,
                        size: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () => globalBloc.musicPlayerBloc.playNextSong(),
                      child: Icon(
                        Icons.fast_forward,
                        color: Constants.COLOR_ICON_SONG_TILE,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<MapEntry<PlayerState, Results>>(
                stream: globalBloc.musicPlayerBloc.playerState,
                builder: (BuildContext context,
                    AsyncSnapshot<MapEntry<PlayerState, Results>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final PlayerState state = snapshot.data.key;
                  final Results currentSong = snapshot.data.value;
                  return GestureDetector(
                    onTap: () {
                      if (currentSong.trackViewUrl == null) {
                        return;
                      }
                      if (PlayerState.paused == state) {
                        globalBloc.musicPlayerBloc.playMusic(currentSong);
                      } else {
                        globalBloc.musicPlayerBloc.pauseMusic(currentSong);
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constants.COLOR_WHITE,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Constants.COLOR_BLACK.withOpacity(0.15),
                            blurRadius: 30,
                            offset: Offset(2, 1.5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedCrossFade(
                          duration: Duration(milliseconds: 200),
                          crossFadeState: state == PlayerState.playing
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Icon(
                            Icons.pause,
                            size: 50,
                            color: Constants.COLOR_ICON_SONG_TILE,
                          ),
                          secondChild: Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Constants.COLOR_ICON_SONG_TILE,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
