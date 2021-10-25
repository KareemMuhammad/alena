import 'dart:io';

import 'package:alena/main.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

const String _BOOLEAN_VALUE = "allow_update";

class RemoteConfigService {
  final RemoteConfig _remoteConfig;
  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  final defaults = <String, dynamic>{
    _BOOLEAN_VALUE: false,
  };

  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: RemoteConfig.instance,
      );
    }
    return _instance;
  }

  bool get getBoolValue => _remoteConfig.getBool(_BOOLEAN_VALUE);

  Future initialize() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on PlatformException  catch (e) {
      print("Remote Config fetch throttled: $e");
    } catch (e) {
      print("Unable to fetch remote config. Default value will be used");
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();
    print("boolean::: $getBoolValue");
  }

  bool checkUpdates() {
    final requiredBuildNumber = _remoteConfig.getInt(Platform.isAndroid
        ? 'requiredBuildNumberAndroid'
        : 'requiredBuildNumberIOS');

    final currentBuildNumber = int.parse(packageInfo.buildNumber);
    print("build no $currentBuildNumber");

    return currentBuildNumber < requiredBuildNumber;
  }

}