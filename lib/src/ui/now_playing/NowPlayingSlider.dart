import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tw_music_player/src/blocs/GlobalBloc.dart';
import 'package:tw_music_player/src/common/Constants.dart';
import 'package:tw_music_player/src/models/PlayerState.dart';

class NowPlayingSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder<MapEntry<Duration, MapEntry<PlayerState, Song>>>(
      stream: Observable.combineLatest2(globalBloc.musicPlayerBloc.position,
          globalBloc.musicPlayerBloc.playerState, (a, b) => MapEntry(a, b)),
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<Duration, MapEntry<PlayerState, Song>>>
              snapshot) {
        if (!snapshot.hasData) {
          return Slider(
            value: 0,
            onChanged: (double value) => null,
            activeColor: Constants.COLOR_SEEKBAR_ACTIVE,
            inactiveColor: Constants.COLOR_SEEKBAR_INACTIVE,
          );
        }
        if (snapshot.data.value.key == PlayerState.stopped) {
          return Slider(
            value: 0,
            onChanged: (double value) => null,
            activeColor: Constants.COLOR_SEEKBAR_ACTIVE,
            inactiveColor: Constants.COLOR_SEEKBAR_INACTIVE,
          );
        }
        final Duration currentDuration = snapshot.data.key;
        final Song currentSong = snapshot.data.value.value;
        final int milliseconds = currentDuration.inMilliseconds;
        final int songDurationInMilliseconds = currentSong.duration;
        return Slider(
          min: 0,
          max: songDurationInMilliseconds.toDouble(),
          value: songDurationInMilliseconds > milliseconds
              ? milliseconds.toDouble()
              : songDurationInMilliseconds.toDouble(),
          onChangeStart: (double value) =>
              globalBloc.musicPlayerBloc.invertSeekingState(),
          onChanged: (double value) {
            final Duration duration = Duration(
              milliseconds: value.toInt(),
            );
            globalBloc.musicPlayerBloc.updatePosition(duration);
          },
          onChangeEnd: (double value) {
            globalBloc.musicPlayerBloc.invertSeekingState();
            globalBloc.musicPlayerBloc.audioSeek(value / 1000);
          },
          activeColor: Constants.COLOR_SEEKBAR_ACTIVE,
          inactiveColor: Constants.COLOR_SEEKBAR_INACTIVE,
        );
      },
    );
  }
}
