import 'package:localstorage/localstorage.dart';
import 'common.model.dart';

class Utility {
  static LocalStorage storage = LocalStorage('localstorage_app');

  static setLocalStorageItem(String itemName, dynamic itemValue) {
    storage.setItem(itemName, itemValue);
  }

  static getLocalStorageItem(String itemName) {
    return storage.getItem(itemName);
  }

  static const String baseUrl = 'http://192.168.0.205:8080/';
  //static const String baseUrl = 'http://192.168.124.123:8080/';

  static Map<String, HttpRequest> urlParams = {
    "login": HttpRequest(
      endpoint: "users/login",
      method: HttpMethod.POST,
      headers: {"Content-Type": "application/json"},
    ),
    "getDocuments": HttpRequest(
      endpoint: "document/readById",
      method: HttpMethod.POST,
      headers: {"Content-Type": "application/json"},
    ),
  };
}
