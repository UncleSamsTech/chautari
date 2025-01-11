import 'package:flutter/material.dart';
import 'package:tuktak/services/auth_service.dart';

import '../../services/user_manager.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key, this.isProfileData = false});
  final bool isProfileData;

  final nameController = TextEditingController(text: UserManager().user!.name);
  final usernameController =
      TextEditingController(text: UserManager().user!.username);
  final bioController = TextEditingController(text: UserManager().user!.bio);
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isProfileData ? Text("Profile Data") : Text("Edit Profile"),
        actions: [
          TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final authService = AuthService();
                  await authService.updateUserProfile(
                      name: nameController.text, bio: bioController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("save")),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: UserManager().user!.avatar.isEmpty
                        ? Icon(Icons.person_2_outlined)
                        : Image.network(UserManager().user!.avatar),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Personal Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: nameController,
                onFieldSubmitted: (value) {},
                validator: (value) {
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: bioController,
                validator: (value) {
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Social Links",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12,
              ),
              TextButton(onPressed: () {}, child: Text("Add links"))
            ],
          ),
        ),
      ),
    );
  }
}
