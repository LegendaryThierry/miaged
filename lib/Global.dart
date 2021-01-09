import 'User.dart';

class Global {
  static final Global _singleton = Global._internal();
  static User user;

  factory Global() {
    return _singleton;
  }

  Global._internal();
}