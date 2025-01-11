import 'package:flutter/material.dart';
import 'package:tuktak/services/auth_service.dart';
import 'package:tuktak/views/notification/notification.dart';
import 'package:tuktak/views/setting/change_password.dart';
import 'package:tuktak/views/setting/edit_profile.dart';
import 'package:tuktak/wrapper.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Account"),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    isProfileData: true,
                                  )));
                        },
                        title: Text("Profile Data"),
                        leading: Icon(Icons.person),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NotificationPage()));
                        },
                        title: Text("Notification"),
                        leading: Icon(Icons.notifications_outlined),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangePassword()));
                        },
                        title: Text("Change Password"),
                        leading: Icon(Icons.key_off_outlined),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Preferences"),
                      ListTile(
                        title: Text("Dark mode"),
                        leading: Icon(Icons.dark_mode_outlined),
                        trailing: Switch.adaptive(
                            value: false, onChanged: (value) {}),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Help"),
                      ListTile(
                        title: Text("Support and feedback"),
                        leading: Icon(Icons.support_agent_outlined),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                      ListTile(
                        title: Text("Rate us"),
                        leading: Icon(Icons.star_outline_outlined),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login"),
                      ListTile(
                        onTap: () async {
                          await AuthService().logout();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()),
                              (route) => false);
                        },
                        title: Text("Log out"),
                        leading: Icon(Icons.logout_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
