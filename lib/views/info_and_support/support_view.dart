import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_scan_app/constants/external_links/support_links.dart';
import 'package:skin_scan_app/enums/menu_action.dart';
import 'package:skin_scan_app/constants/models.dart';
import 'package:skin_scan_app/services/auth/bloc/auth_bloc.dart';
import 'package:skin_scan_app/utils/dialogs/logout_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/auth/bloc/auth_event.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
          title: const Text('Support links'),
        ),
        body: ListView.builder(
          itemCount: skinCancerCharitiesWebsites.length,
          itemBuilder: (context, index) {
            final charity = Charity.fromMap(skinCancerCharitiesWebsites[index]);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () async {
                        final Uri url = Uri.parse(charity.link);
                        final urlLaunchable = await canLaunchUrl(url);
                        if (urlLaunchable) {
                          await launchUrl(url, mode: LaunchMode.inAppWebView);
                        } else {
                          print('URL cannot be launched');
                        }
                      },
                      title: Text(charity.name),
                      subtitle: Text(charity.tag),
                      leading: AspectRatio(
                        aspectRatio: 1.5,
                        child: Image.network(
                          charity.img,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
