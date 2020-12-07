import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/BlankScreen.dart';
import 'package:tw_music_player/src/models/PlayerState.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';
import 'package:tw_music_player/src/ui/all_songs/SongTile.dart';

class AllSongsScreen extends StatelessWidget {
  AllSongsScreen({
    Key key,
  }) : super(key: key);

  static const _MESSAGE_NO_RESULT = 'No results found';
  static const _KEY_ALL_SONGS = 'All Songs';

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      body: StreamBuilder<List<Results>>(
        stream: globalBloc.musicPlayerBloc.songs,
        builder: (BuildContext context, AsyncSnapshot<List<Results>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Results> listOfSongs = snapshot.data;
          if (listOfSongs.length == 0) {
            return BlankScreen(
              text: _MESSAGE_NO_RESULT,
            );
          }
          return ListView.builder(
            key: PageStorageKey<String>(_KEY_ALL_SONGS),
            padding: const EdgeInsets.only(bottom: 150.0),
            physics: BouncingScrollPhysics(),
            itemCount: listOfSongs.length,
            itemExtent: 136,
            itemBuilder: (BuildContext context, int index) {
              return StreamBuilder<MapEntry<PlayerState, Results>>(
                stream: globalBloc.musicPlayerBloc.playerState,
                builder: (BuildContext context,
                    AsyncSnapshot<MapEntry<PlayerState, Results>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  final PlayerState state = snapshot.data.key;
                  final Results currentSong = snapshot.data.value;
                  final bool isSelectedSong = currentSong == listOfSongs[index];

                  return GestureDetector(
                    onTap: () {
                      globalBloc.musicPlayerBloc.performTapAction(state,
                          currentSong, isSelectedSong, index, listOfSongs);
                    },
                    child: SongTile(
                      song: listOfSongs[index],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
