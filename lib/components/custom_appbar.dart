import 'package:buyerease/main.dart';
import 'package:buyerease/utils/logout.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.name});

  final String name;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      title: name.isEmpty
          ? Text(
              'Welcome, ${sp!.getString('User')}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            )
          : Text(
              name,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: [
        IconButton(
          onPressed: () => logout(context),
          icon: Icon(

            Icons.logout,
            color: theme.colorScheme.onPrimary,
          ),
          tooltip: 'Logout',
        ),
      ],
    );
  }
}
