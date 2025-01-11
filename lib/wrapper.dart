import 'package:flutter/material.dart';
import 'package:tuktak/views/home.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Widget getInitialPage() {
    return Home();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getInitialPage());
  }
}
