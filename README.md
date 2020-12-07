# tw_music_player

Music Player 

This is a simple music player app developed in Flutter.
It use the iTunes affiliate API and lets you search by artist and displays the search results on the screen. By default, all the songs fetched from the iTunes affiliate API 
are displayed on the screen. User can refine the list by using search functionality.

Below details are displayed for a song on Playlist screen : 
- Title
- Artist 
- Album 
- Duration

This project is based upon MVP (Model-View-Presenter) Architecture pattern.
Provider & BLOC design pattern is used for development of this project.

As requested, only Android mobile device is supported. Supported device - 
Google Pixel 3 XL emulator

Features covered in this application are as under:

- Integration with iTunes affiliate API
- Retrieve all songs
- Play
- Pause
- Next
- Previous
- When we tap a song, a media player shows up at the bottom of the screen and starts to play the preview for that song. 
- This media player can be maximized and minimised.
- Search 
- Smooth UI
- The media player shows only when a song is selected and stays on the screen from that point onwards and is reused for any subsequent song played.
- The media player shows details of the current song being played.
- When a song is being played, an indicator (SeekBar) for the same is displayed in the list.
- Current song continues to play even when a new search is performed. Select any song from search result list to play a particular song.

Requirements to build the app - 
If you are on latest flutter version, you might consider downgrading to Flutter version-  v1.7.8+hotfix.4, for the application to work. This application supports 
Flutter version: 1.7.8+hotfix.4 because of the dependency on the library - "Flute-Music-Player" which is dependent on the Flutter version - v1.7.8+hotfix.4. This library is used to 
display media player on the screen.
(In order to support latest Flutter SDK version, Alternative for flute_music_player dependency is required and no suitable alternative was available during development of the project)
Android Studio version - 4.1.1 & Gradle version - 4.10.2 was used for the development of the project. Hence, please use mentioned versions respectively, 
if you face any issues while compiling the project.

Libraries used - 
- https://github.com/iampawan/Flute-Music-Player
- https://github.com/Baseflow/flutter-permission-handler

Initially the plan was to implement the functionality of playing media files from local  storage. Hence, the application asks for storage permissions. However, due  to time constraints, 
that functionality is still a "Work In Progress".

Incomplete functionality - 
- Fully functional SeekBar
- Handle media player on Search screen
- Handle default message on Search screen
- Playing media files from local storage

How to use and run the code shared?
Step 1. Simply do - git clone bundle_name.bundle repo
Step 2. cd repo
Step 3. flutter run