import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//PROVIDE STATE MANAGEMENT WITH BITRATE
class BitrateProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _bitrate;

  String? get bitrate => _bitrate;

  BitrateProvider() {
    loadBitrate();
  }

  Future<void> loadBitrate() async {
    _bitrate = await _storage.read(key: 'bitrate');
    notifyListeners();
  }

  Future<void> setBitrate(String bitrate) async {
    await _storage.write(key: 'bitrate', value: bitrate);
    _bitrate = bitrate;
    notifyListeners();
  }
}