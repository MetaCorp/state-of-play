import 'package:flutter/foundation.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class MainProvider with ChangeNotifier {
  sop.User user;
  dynamic account;
  bool redirect = false;

  void updateUser(sop.User newUser) {
    user = newUser;
    notifyListeners();
  }

  void updateAccount(dynamic newAccount) {
    account = newAccount;
    notifyListeners();
  }

  void updateRedirect(bool newRedirect) {
    redirect = newRedirect;
    notifyListeners();
  }
}