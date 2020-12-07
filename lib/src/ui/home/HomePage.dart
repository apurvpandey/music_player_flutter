import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/ui/all_songs/AllSongsScreen.dart';
import 'package:tw_music_player/src/ui/home/MediaPlayerPanel.dart';
import 'package:tw_music_player/src/ui/now_playing/NowPlayingScreen.dart';
import 'package:tw_music_player/src/ui/search/SearchScreen.dart';

class Homepage extends StatefulWidget {
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  PanelController panelController;

  static const _TITLE_TW_MUSIC = 'TW Music';
  static const _TITLE_SONGS_FOR_YOU = 'Songs for You';
  static const _MESSAGE_CLOSE_APP = 'Do you want to close the app?';
  static const _LABEL_YES = 'Yes';
  static const _LABEL_NO = 'No';

  @override
  void initState() {
    panelController = PanelController();
    super.initState();
  }

  @override
  void dispose() {
    panelController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 25.0;
    return WillPopScope(
      onWillPop: () {
        if (!panelController.isPanelClosed()) {
          panelController.close();
        } else {
          _showExitDialog();
        }
        return Future<bool>.value(false);
      },
      child: Scaffold(
        body: SlidingUpPanel(
          panel: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            child: NowPlayingScreen(controller: panelController),
          ),
          controller: panelController,
          minHeight: 115,
          maxHeight: MediaQuery.of(context).size.height,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
          collapsed: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.0,
                  0.7,
                ],
                colors: [
                  Constants.COLOR_BLACK,
                  Constants.COLOR_BACKGROUND_NOW_PLAYING,
                ],
              ),
            ),
            child: MediaPlayerPanel(controller: panelController),
          ),
          body: DefaultTabController(
            length: 1,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  _TITLE_TW_MUSIC,
                  style: TextStyle(
                    color: Constants.COLOR_APP_TEXT,
                    fontSize: 24,
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: Constants.COLOR_APP_TEXT,
                  labelColor: Constants.COLOR_TEXT_BLANK_SCREEN,
                  unselectedLabelColor:
                      Constants.COLOR_BACKGROUND_NOW_PLAYING.withOpacity(0.6),
                  tabs: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _TITLE_SONGS_FOR_YOU,
                        style: TextStyle(
                          color: Constants.COLOR_APP_TEXT,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 10.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.search,
                        color: Constants.COLOR_APP_TEXT,
                        size: 35,
                      ),
                    ),
                  )
                ],
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              ),
              body: TabBarView(
                key: UniqueKey(),
                physics: BouncingScrollPhysics(),
                children: <Widget>[AllSongsScreen()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _TITLE_TW_MUSIC,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Text(
            _MESSAGE_CLOSE_APP,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Constants.COLOR_TEXT_DIALOG,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(_LABEL_NO),
            ),
            FlatButton(
              textColor: Constants.COLOR_TEXT_DIALOG,
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                globalBloc.dispose();
              },
              child: Text(_LABEL_YES),
            ),
          ],
        );
      },
    );
  }
}
