import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management/screens/library_management.dart';
import 'package:library_management/screens/login.dart';
import 'package:library_management/utils/db_process.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

DbProcess dbProcess = DbProcess();

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await dbProcess.connect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF56BDDE)),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoSansTextTheme(),
      ),
      home: const LibraryManagement(),
      debugShowCheckedModeBanner: false,
    );
  }
}
