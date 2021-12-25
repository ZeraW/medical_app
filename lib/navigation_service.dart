import 'package:flutter/material.dart';

class NavigationService{
  GlobalKey<NavigatorState> key;

  static NavigationService instance = NavigationService();

  NavigationService(){
    key = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _rn){
    return key.currentState.pushReplacementNamed(_rn);
  }
  Future<dynamic> navigateTo(String _rn){
    return key.currentState.pushNamed(_rn);
  }
  Future<dynamic> navigateToRoute(MaterialPageRoute _rn){
    return key.currentState.push(_rn);
  }

  goBack(){
    return key.currentState.pop();

  }
}