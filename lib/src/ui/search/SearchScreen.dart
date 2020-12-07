import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/BlankScreen.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/models/PlayerState.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';
import 'package:tw_music_player/src/ui/all_songs/SongTile.dart';
import 'package:tw_music_player/src/ui/search/SearchScreenBloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  static const _HINT_SEARCH = 'Search for Artist';
  static const _MESSAGE_NO_RESULT = 'No results found';

  TextEditingController _textEditingController;
  SearchScreenBloc _searchScreenBloc;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _searchScreenBloc = SearchScreenBloc();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
            icon: Icon(
              Icons.arrow_back,
              color: Constants.COLOR_APP_TEXT,
              size: 35,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: StreamBuilder<List<Results>>(
            stream: globalBloc.musicPlayerBloc.songs,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return TextField(
                controller: _textEditingController,
                cursorColor: Constants.COLOR_APP_TEXT,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
                  hintText: _HINT_SEARCH,
                  hintStyle: TextStyle(
                    color: Constants.COLOR_APP_TEXT,
                    fontSize: 16.0,
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.COLOR_BLACK.withOpacity(0.7),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.COLOR_BLACK.withOpacity(0.7),
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Constants.COLOR_APP_TEXT,
                  fontSize: 16.0,
                ),
                autofocus: true,
                onSubmitted: (String value) {
                  print(value);
                  _searchScreenBloc.fetchSongs(value);
                },
              );
            },
          ),
        ),
        body: StreamBuilder<List<Results>>(
          stream: _searchScreenBloc.filteredSongs,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<Results> listOfFilteredSongs = snapshot.data;

            if (listOfFilteredSongs.length == 0) {
              return BlankScreen(
                text: _MESSAGE_NO_RESULT,
              );
            }

            return ListView.builder(
              key: UniqueKey(),
              padding: const EdgeInsets.only(bottom: 30.0),
              physics: BouncingScrollPhysics(),
              itemCount: listOfFilteredSongs.length,
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
                    final bool isSelectedSong =
                        currentSong == listOfFilteredSongs[index];
                    return GestureDetector(
                      onTap: () {
                        globalBloc.musicPlayerBloc.performTapAction(
                            state,
                            currentSong,
                            isSelectedSong,
                            index,
                            listOfFilteredSongs);
                      },
                      child: SongTile(
                        song: listOfFilteredSongs[index],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
