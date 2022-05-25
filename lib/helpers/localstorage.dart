import 'package:shared_preferences/shared_preferences.dart';

Future<int> setLastAccount(int id) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setInt("last_account", id);
  return id;
}

Future<int?> getLastAccount() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  int? m = localStorage.getInt("last_account");
  return m;
}
