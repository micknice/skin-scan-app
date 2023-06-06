import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_scan_app/enums/menu_action.dart';
import 'package:skin_scan_app/services/auth/bloc/auth_bloc.dart';
import 'package:skin_scan_app/services/auth/bloc/auth_event.dart';
import 'package:skin_scan_app/utils/dialogs/logout_dialog.dart';
import 'package:skin_scan_app/views/home/carousel_new.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Skin Scan'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    if (context.mounted) {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: ManuallyControlledSlider(),
    );
  }
}
