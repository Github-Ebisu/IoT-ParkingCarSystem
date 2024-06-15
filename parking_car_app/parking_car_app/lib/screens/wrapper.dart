import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/user.dart';
import 'authentication/authenticate.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels?>(context);
    return (user == null) ? const Authenticate() : const Home();
  }
}
