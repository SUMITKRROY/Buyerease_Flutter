import 'package:flutter/material.dart';

class SampleCollected extends StatefulWidget {
  const SampleCollected({super.key});

  @override
  State<SampleCollected> createState() => _SampleCollectedState();
}

class _SampleCollectedState extends State<SampleCollected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('SampleCollected')),
    );
  }
}
