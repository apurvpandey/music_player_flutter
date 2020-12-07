import 'package:rxdart/rxdart.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';
import 'package:tw_music_player/src/service/AppleMusicStore.dart';

class SearchScreenBloc {
  BehaviorSubject<List<Results>> _filteredSongs;

  BehaviorSubject<List<Results>> get filteredSongs => _filteredSongs;

  SearchScreenBloc() {
    _filteredSongs = BehaviorSubject<List<Results>>.seeded([]);
  }

  Future<void> fetchSongs(String query) async {
    AppleMusicStore store = new AppleMusicStore();
    await store.fetchResultsByQuery(query).then(
      (data) {
        _filteredSongs.add(data);
      },
    );
  }

  void dispose() {
    _filteredSongs.close();
  }
}
