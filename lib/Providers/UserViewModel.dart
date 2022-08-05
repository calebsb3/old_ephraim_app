import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  User? currentUser;

  void updateCurrentUser(User? user) {
    currentUser = user;

    notifyListeners();
  }
}
