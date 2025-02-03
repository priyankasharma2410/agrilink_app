import 'package:flutter/material.dart';

class ConsumerProfile extends StatelessWidget {
  const ConsumerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumer Profile')),
      body: const Center(child: Text('Welcome, Consumer!')),
    );
  }
}
