import 'package:flutter/foundation.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayProvider with ChangeNotifier {
  sop.StateOfPlay value = new sop.StateOfPlay(
    property: new sop.Property()
  );

  void update() {
    print('NewStateOfPlayProvider update: ' + value.property.reference);
    notifyListeners();
  }
}