import 'package:audio_service/audio_service.dart';

import '../media_manager.dart';
import 'audio_handler.dart';
import 'playlist_repository.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PlaylistRepository>(() => DemoPlaylist());
  getIt.registerSingleton<MyAudioHandler>(MyAudioHandler());

  // page state
  getIt.registerLazySingleton<MediaManager>(() => MediaManager());
}
