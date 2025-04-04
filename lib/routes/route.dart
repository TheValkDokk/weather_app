import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppRoutes {
  final List<GoRoute> routes = [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  ];
  late final GoRouter router;

  AppRoutes() {
    router = GoRouter(routes: routes);
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home')),
    );
  }
}
