import 'dart:async';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tw_music_player/src/models/Album.dart';
import 'package:tw_music_player/src/models/Playback.dart';
import 'package:tw_music_player/src/models/PlayerState.dart';
import 'package:tw_music_player/src/models/ServiceResponse.dart';
import 'package:tw_music_player/src/service/AppleMusicStore.dart';

class MusicPlayerBloc {
  BehaviorSubject<List<Results>> _songs;
  BehaviorSubject<List<Album>> _albums;
  BehaviorSubject<MapEntry<PlayerState, Results>> _playerState;
  BehaviorSubject<MapEntry<List<Results>, List<Results>>> _playList;
  BehaviorSubject<Duration> _position;
  BehaviorSubject<List<Playback>> _playBack;
  BehaviorSubject<bool> _isAudioSeeking;
  MusicFinder _audioPlayer;
  Results _defaultSong;

  BehaviorSubject<List<Results>> get songs => _songs;

  BehaviorSubject<MapEntry<PlayerState, Results>> get playerState =>
      _playerState;

  BehaviorSubject<Duration> get position => _position;

  BehaviorSubject<List<Playback>> get playBack => _playBack;

  MusicPlayerBloc() {
    _initDefaultSong();
    _initStreams();
    _initAudioPlayer();
  }

  Future<void> fetchSongs(String query) async {
    AppleMusicStore store = new AppleMusicStore();
    await store.fetchResultsByQuery(query).then(
      (data) {
        _songs.add(data);
      },
    );
  }

  void playMusic(Results song) {
    _audioPlayer.play(song.previewUrl);
    _updatePlayerState(PlayerState.playing, song);
  }

  void pauseMusic(Results song) {
    _audioPlayer.pause();
    _updatePlayerState(PlayerState.paused, song);
  }

  void _stopMusic() {
    _audioPlayer.stop();
  }

  void _updatePlayerState(PlayerState state, Results song) {
    _playerState.add(MapEntry(state, song));
  }

  void updatePosition(Duration duration) {
    _position.add(duration);
  }

  void performTapAction(PlayerState state, Results currentSong,
      bool isSelectedSong, int index, List<Results> songs) {
    _updatePlaylist(songs);
    switch (state) {
      case PlayerState.playing:
        if (isSelectedSong) {
          pauseMusic(currentSong);
        } else {
          _stopMusic();
          playMusic(
            songs[index],
          );
        }
        break;
      case PlayerState.paused:
        if (isSelectedSong) {
          playMusic(songs[index]);
        } else {
          _stopMusic();
          playMusic(
            songs[index],
          );
        }
        break;
      case PlayerState.stopped:
        playMusic(songs[index]);
        break;
      default:
        break;
    }
  }

  void _updatePlaylist(List<Results> normalPlaylist) {
    List<Results> shufflePlaylist = []..addAll(normalPlaylist);
    shufflePlaylist.shuffle();
    _playList.add(MapEntry(normalPlaylist, shufflePlaylist));
  }

  void playNextSong() {
    if (_playerState.value.key == PlayerState.stopped) {
      return;
    }
    final Results currentSong = _playerState.value.value;
    final bool isShuffle = _playBack.value.contains(Playback.shuffle);
    final List<Results> playlist =
        isShuffle ? _playList.value.value : _playList.value.key;
    int index = playlist.indexOf(currentSong);
    if (index == playlist.length - 1) {
      index = 0;
    } else {
      index++;
    }
    _stopMusic();
    playMusic(playlist[index]);
  }

  void playPreviousSong() {
    if (_playerState.value.key == PlayerState.stopped) {
      return;
    }
    final Results currentSong = _playerState.value.value;
    final bool isShuffle = _playBack.value.contains(Playback.shuffle);
    final List<Results> playlist =
        isShuffle ? _playList.value.value : _playList.value.key;
    int index = playlist.indexOf(currentSong);
    if (index == 0) {
      index = playlist.length - 1;
    } else {
      index--;
    }
    _stopMusic();
    playMusic(playlist[index]);
  }

  void _playSameSong() {
    final Results currentSong = _playerState.value.value;
    _stopMusic();
    playMusic(currentSong);
  }

  void _onSongComplete() {
    final List<Playback> playback = _playBack.value;
    if (playback.contains(Playback.repeatSong)) {
      _playSameSong();
      return;
    }
    playNextSong();
  }

  void audioSeek(double seconds) {
    _audioPlayer.seek(seconds);
  }

  void invertSeekingState() {
    final value = _isAudioSeeking.value;
    _isAudioSeeking.add(!value);
  }

  void _initDefaultSong() {
    _defaultSong = new Results();
  }

  void _initStreams() {
    _isAudioSeeking = BehaviorSubject<bool>.seeded(false);
    _songs = BehaviorSubject<List<Results>>();
    _position = BehaviorSubject<Duration>();
    _playList = BehaviorSubject<MapEntry<List<Results>, List<Results>>>();
    _playBack = BehaviorSubject<List<Playback>>.seeded([]);
    _playerState = BehaviorSubject<MapEntry<PlayerState, Results>>.seeded(
      MapEntry(
        PlayerState.stopped,
        _defaultSong,
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = MusicFinder();
    _audioPlayer.setPositionHandler(
      (Duration duration) {
        final bool isAudioSeeking = _isAudioSeeking.value;
        if (!isAudioSeeking) {
          updatePosition(duration);
        }
      },
    );
    _audioPlayer.setCompletionHandler(
      () {
        _onSongComplete();
      },
    );
  }

  void dispose() {
    _stopMusic();
    _isAudioSeeking.close();
    _songs.close();
    _albums.close();
    _playerState.close();
    _playList.close();
    _position.close();
    _playBack.close();
  }
}
