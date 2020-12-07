import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tw_music_player/src/models/ServiceResponse.dart';

class AppleMusicStore {
  AppleMusicStore();

  static const _BASE_URL = 'https://itunes.apple.com';
  static const _SEARCH_URL = "$_BASE_URL/search";
  static const _JSON_EXCEPTION = 'Failed to fetch data';
  static const _KEY_RESULTS = 'results';

  Future<dynamic> fetchJSON(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(_JSON_EXCEPTION);
    }
  }

  Future<dynamic> fetchResultsByQuery(String query) async {
    var completer = new Completer();

    final url = "$_SEARCH_URL?types=artists&term=$query";

    final json = await fetchJSON(url);
    final List<Results> songs = [];

    final songJSON = json[_KEY_RESULTS];
    if (songJSON != null) {
      songs.addAll((songJSON as List).map((a) => Results.fromJson(a)));
    }

    completer.complete(songs);
    return completer.future;
  }
}
