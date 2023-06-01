import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{
  static const String isSubscribedForNotificationKey="isSubscribedForNotificationKey";
  static const String isShortRestKey="ShortRestKey";
  late SharedPreferences _sharedPreferences;
  bool isInitialized=false;

  static final LocalStorage _instance=LocalStorage._();
  LocalStorage._();
  factory LocalStorage()=>_instance;

  Future<void> init([bool fromTerminatedState=false])async{
    if(isInitialized)return;
    _sharedPreferences=await SharedPreferences.getInstance();
    if(fromTerminatedState){
      await _sharedPreferences.reload();
    }
    isInitialized=true;
  }

  Future<void> subscribeNotificationToggle(bool value) async{
    await _sharedPreferences.setBool(isSubscribedForNotificationKey, value);
  }

  bool get isSubscribedForNotification=>_sharedPreferences.getBool(isSubscribedForNotificationKey)??false;

  bool get isShortRest{
    return _sharedPreferences.getBool(isShortRestKey)??true;
  }

  Future<void> toggleShortRest() async{
    await _sharedPreferences.setBool(isShortRestKey,!isShortRest);
  }
  Future<void> resetShortRest() async{
    await _sharedPreferences.setBool(isShortRestKey,true);
  }

}