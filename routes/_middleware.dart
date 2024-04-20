import 'dart:convert';

import 'package:firebase_dart/core.dart';
import 'package:firebase_dart/implementation/pure_dart.dart';
import 'package:firebase_dart/storage.dart';
import 'package:firedart/firedart.dart';

import 'package:dart_frog/dart_frog.dart';

import '../lib/config.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return (context) async {
    if (Firestore.initialized == false) {
      Firestore.initialize("cladbee-6554e");
      FirebaseDart.setup();
      await Firebase.initializeApp(options: FirebaseOptions.fromMap(config));
    }

    //  if (!FirebaseAuth.initialized) {
    //   FirebaseAuth.initialize(
    //       'AIzaSyDcHpc-LRPCX_M9_kLoCtls0ExhByUe7TE', VolatileStore());
    //           await FirebaseAuth.instance
    //     .signInAnonymously();
    // }

    // if(FirebaseAuth.instance.isSignedIn==false && FirebaseAuth.initialized) {
    // await FirebaseAuth.instance
    //     .signInAnonymously();

    // }

    final response = await handler(context);

    return response;
  };
}
