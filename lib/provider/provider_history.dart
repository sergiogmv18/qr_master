import 'package:flutter/material.dart';

class ProviderHistory extends ChangeNotifier {
  int indexToTab = 0;

  updateIndextToTab(int indexSeleted){
    indexToTab = indexSeleted;
    notifyListeners();
  }

}