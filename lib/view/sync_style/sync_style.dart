import 'package:buyerease/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class SyncStyle extends StatefulWidget {
  const SyncStyle({super.key});

  @override
  State<SyncStyle> createState() => _SyncStyleState();
}

class _SyncStyleState extends State<SyncStyle> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(name: 'Buyerease\'s')),
      body: Center(child: const Text('Data Not Found')),
    );
  }
}
