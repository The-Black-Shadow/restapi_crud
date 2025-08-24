import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi_crud/bloc_observer.dart';
import 'package:restapi_crud/core/di/service_locator.dart';
import 'package:restapi_crud/my_app.dart';

void main() {
  //bloc observer
  Bloc.observer = MyBlocObserver();
  //initiate dependency injection
  setupLocator();
  runApp(const MyApp());
}
