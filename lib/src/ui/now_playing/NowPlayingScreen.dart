import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/common/MusicPlayerIcons.dart';
import 'package:tw_music_player/src/models/PlayerState.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';
import 'package:tw_music_player/src/ui/now_playing/AlbumArtContainer.dart';
import 'package:tw_music_player/src/ui/now_playing/EmptyAlbumArtContainer.dart';
import 'package:tw_music_player/src/ui/now_playing/MusicBoardControls.dart';
import 'package:tw_music_player/src/ui/now_playing/NowPlayingSlider.dart';

class NowPlayingScreen extends StatelessWidget {
  final PanelController _controller;

  NowPlayingScreen({@required PanelController controller})
      : _controller = controller;

  static const _PLACEHOLDER_TIME = '0:00';

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    final double radius = 25.0;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double albumArtSize = screenHeight / 2.1;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: albumArtSize + 150,
            child: Stack(
              children: <Widget>[
                StreamBuilder<MapEntry<PlayerState, Results>>(
                  stream: globalBloc.musicPlayerBloc.playerState,
                  builder: (BuildContext context,
                      AsyncSnapshot<MapEntry<PlayerState, Results>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.value.artworkUrl100 == null) {
                      return EmptyAlbumArtContainer(
                        radius: radius,
                        albumArtSize: albumArtSize,
                        iconSize: albumArtSize / 2,
                      );
                    }

                    final Results currentSong = snapshot.data.value;
                    return AlbumArtContainer(
                      radius: radius,
                      albumArtSize: albumArtSize,
                      currentSong: currentSong,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MusicBoardControls(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 22.0, top: 20.0, right: 22.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 12,
                  child: Container(
                    child: StreamBuilder<MapEntry<PlayerState, Results>>(
                      stream: globalBloc.musicPlayerBloc.playerState,
                      builder: (BuildContext context,
                          AsyncSnapshot<MapEntry<PlayerState, Results>>
                              snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        if (snapshot.data.key == PlayerState.stopped) {
                          return Container();
                        }
                        final Results currentSong = snapshot.data.value;

                        final String artists = currentSong.artistName
                            .split(";")
                            .reduce((String a, String b) {
                          return a + " & " + b;
                        });
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              currentSong.collectionName.toUpperCase() +
                                  " • " +
                                  artists.toUpperCase(),
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
                              color: Colors.transparent,
                            ),
                            Text(
                              currentSong.trackName,
                              style: TextStyle(
                                fontSize: 30,
                                color: Constants.COLOR_APP_TEXT,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => _controller.close(),
                    child: HideIcon(
                      color: Constants.COLOR_ICON_SONG_TILE,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: screenHeight / 22,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder<MapEntry<PlayerState, Results>>(
                        stream: globalBloc.musicPlayerBloc.playerState,
                        builder: (BuildContext context,
                            AsyncSnapshot<MapEntry<PlayerState, Results>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              _PLACEHOLDER_TIME,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Constants.COLOR_APP_TEXT,
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          final Results currentSong = snapshot.data.value;
                          final PlayerState state = snapshot.data.key;
                          if (state == PlayerState.stopped) {
                            return Text(
                              _PLACEHOLDER_TIME,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Constants.COLOR_APP_TEXT,
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          return Text(
                            _getDuration(currentSong),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Constants.COLOR_APP_TEXT,
                              letterSpacing: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                  ),
                ),
                NowPlayingSlider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDuration(Results song) {
    final double temp = song.trackTimeMillis / 1000;
    final int minutes = (temp / 60).floor();
    final int seconds = (((temp / 60) - minutes) * 60).round();
    if (seconds.toString().length != 1) {
      return minutes.toString() + ":" + seconds.toString();
    } else {
      return minutes.toString() + ":0" + seconds.toString();
    }
  }
}
