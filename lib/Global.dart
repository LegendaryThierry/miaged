import 'User.dart';

//Classe pour les variables globales
class Global {
  static final Global _singleton = Global._internal();
  static User user;

  factory Global() {
    return _singleton;
  }

  Global._internal();
}