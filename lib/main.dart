import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subspace/BlogList.dart';

import 'LikedBlogs.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LikedBlogsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: BlogList());
  }
}
