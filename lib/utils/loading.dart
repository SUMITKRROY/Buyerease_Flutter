import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: theme.shadowColor.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0.7))
        ]),
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: [
            Image.asset('assets/images/logo1.png',
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.2),
            Text(
              'Loading...',
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 18
              ),
            )
          ],
        ));
  }
}
