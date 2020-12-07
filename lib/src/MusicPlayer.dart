import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/ui/home/HomePage.dart';

/// Music Player Application

class MusicPlayer extends StatelessWidget {
  final GlobalBloc _globalBloc = GlobalBloc();

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>(
      builder: (BuildContext context) {
        _globalBloc.permissionsBloc.storagePermissionStatus$.listen(
          (data) {
            if (data == PermissionStatus.granted) {
              _globalBloc.musicPlayerBloc.fetchSongs('*').then(
                    (_) {},
                  );
            }
          },
        );
        return _globalBloc;
      },
      dispose: (BuildContext context, GlobalBloc value) => value.dispose(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Constants.COLOR_BLACK,
          sliderTheme: SliderThemeData(
            trackHeight: 1,
          ),
        ),
        home: SafeArea(
          child: StreamBuilder<PermissionStatus>(
            stream: _globalBloc.permissionsBloc.storagePermissionStatus$,
            builder: (BuildContext context,
                AsyncSnapshot<PermissionStatus> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Constants.COLOR_BLACK,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final PermissionStatus status = snapshot.data;
              if (status == PermissionStatus.denied) {
                _globalBloc.permissionsBloc.requestStoragePermission();
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Constants.COLOR_BLACK,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Homepage();
              }
            },
          ),
        ),
      ),
    );
  }
}
