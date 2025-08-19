import 'package:flutter/material.dart';
import 'package:restapi_crud/core/di/service_locator.dart';
import 'package:restapi_crud/my_app.dart';

void main() {
  //initiate dependency injection
  setupLocator();
  runApp(const MyApp());
}
