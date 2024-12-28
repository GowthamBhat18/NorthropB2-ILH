import 'package:shared_preferences/shared_preferences.dart';

int? retrivedUserId;

String apiUrl(String endpoint) {
  //final String ipAddress = '192.168.210.196';
  //final String ipAddress = '192.168.36.199';
  final String ipAddress = '192.168.124.123';
  final String port = '3000';

  return 'http://$ipAddress:$port/$endpoint';
}

final String getBalanceUrl = apiUrl('ethereum/getBalance');
final String getNameUrl = apiUrl('user/read');
final String postTransactionUrl = apiUrl('transaction/make');
//final String putBalance2Url = apiUrl('balance/update/2');
final String postCheckLoginUrl = apiUrl('user/login');
final String postCreateUserUrl = apiUrl('user/create');
final String postCreateCardUrl = apiUrl('card/create');
final String postCreateBalanceUrl = apiUrl('balance/create');
final String postCreateNfcDeviceUrl = apiUrl('NFCDevice/create');
final String postCreateBankAccountUrl = apiUrl('bankAccount/create');
