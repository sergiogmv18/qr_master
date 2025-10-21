import 'package:flutter/material.dart';

class BottonNavigationBarProvider  extends ChangeNotifier {
  int _currentIndexPage = 0; 

  int get currentIndexPage => _currentIndexPage;

  set currentIndexPage(int newIndexPage) {
    _currentIndexPage = newIndexPage;
    notifyListeners(); 
  }
}