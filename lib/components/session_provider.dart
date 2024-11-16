import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ayesha_project/models/session.dart';

class SessionProvider with ChangeNotifier {
  Session? _session;
  final String sessionId;

  SessionProvider(this.sessionId) {
    _fetchSession();
  }

  Session? get session => _session;

  void _fetchSession() {
    FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _session = Session.fromJson(snapshot.data() as Map<String, dynamic>);
        notifyListeners();
      }
    });
  }
}
