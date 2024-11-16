import 'package:ayesha_project/components/download_manager.dart';
import 'package:ayesha_project/models/hive/note_model.dart';
import 'package:ayesha_project/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDA_OCF0OP921ZPEBVgQSB2paFi7B1goB4',
          appId: '1:219965210307:android:6cef50f18881e75742ac76',
          messagingSenderId: '219965210307',
          projectId: 'rethinkretool'));

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');

  await Supabase.initialize(
    url: 'https://ettzthjknktuhqljugvj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0dHp0aGprbmt0dWhxbGp1Z3ZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEyNjI5MTMsImV4cCI6MjA0NjgzODkxM30.4aS9EVaySd3j1IDuYlx0v-C_MML1x5lTI-TW9R6qzvw',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DownloadManager()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rethink & Retool',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: const LoginScreen(),
    );
  }
}
