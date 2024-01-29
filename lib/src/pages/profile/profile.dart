import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebook/src/settings/settings_controller.dart';
import 'package:ebook/src/api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.settingsController}) : super(key: key);
  final SettingsController settingsController;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch user data when the widget is initialized
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getname = localStorage.getString('name');
    if (getname != null) {
      name = getname.replaceAll('"', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadUserData();
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '${name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ProfileInfo(),
                  Spacer(), // Spacer untuk memberikan ruang tambahan
                  Logout(settingsController: widget.settingsController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Reading List", 30),
    ProfileInfoItem("Followers", 120),
    // ProfileInfoItem("Following", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatefulWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  _TopPortionState createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  late ImagePicker _imagePicker;
  XFile? _pickedFile; // Remove 'late'
  String _imagePath = "assets/images/flutter_logo.png"; // Default image path

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _initializeImagePath();
  }

  Future<void> _initializeImagePath() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getimgUrl = localStorage.getString('imgUrl');
    if (getimgUrl != null) {
      if (getimgUrl != 'null') {
        setState(() {
          _imagePath = getimgUrl.replaceAll('"', '');
        });
      } else {
        setState(() {
          _imagePath = "assets/images/profile.png";
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        await Api.changeProfileUser(imgUrl: pickedFile.path);

        setState(() {
          _pickedFile = pickedFile;
          _imagePath = _pickedFile!.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF6741FF), Color(0xFF6741FF)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: _pickImage,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: _pickedFile != null
                        ? ClipOval(
                            child: Image.file(
                              File(_pickedFile!.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: _imagePath.contains('asset')
                                ? Image.asset(
                                    _imagePath,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_imagePath),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Logout extends StatelessWidget {
  Logout({Key? key, required this.settingsController}) : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Api.logoutUser(
          context: context,
          settingsController: settingsController,
        );
      },
      child: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(400, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        primary: Color(0xFF6741FF),
      ),
    );
  }
}
