import 'package:tw_music_player/src/blocs/MusicPlayerBloc.dart';
import 'package:tw_music_player/src/blocs/PermissionsBloc.dart';

class GlobalBloc {
  PermissionsBloc _permissionsBloc;
  MusicPlayerBloc _musicPlayerBloc;

  MusicPlayerBloc get musicPlayerBloc => _musicPlayerBloc;

  PermissionsBloc get permissionsBloc => _permissionsBloc;

  GlobalBloc() {
    _musicPlayerBloc = MusicPlayerBloc();
    _permissionsBloc = PermissionsBloc();
  }

  void dispose() {
    _musicPlayerBloc.dispose();
    _permissionsBloc.dispose();
  }
}
