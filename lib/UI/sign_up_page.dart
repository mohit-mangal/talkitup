import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:talkitup/Models/user_details.dart';
import 'package:talkitup/Providers/user_provider.dart';
import 'package:talkitup/Services/firestore_services.dart';
import 'package:talkitup/UI/bg_gradient.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _usernameController = TextEditingController();

  final _taglineController = TextEditingController();

  final _bioController = TextEditingController();

  MemoryImage? image;

  void _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        image = MemoryImage(await picked.readAsBytes());
      }
    } catch (e) {}
    setState(() {});
  }

  void _saveUser() async {
    if (_formKey.currentState?.validate() != true) return;

    final _userProvider = Provider.of<UserProvider>(context, listen: false);

    final newUser = UserDetails((b) => b
      ..id = _userProvider.id
      ..name = _nameController.text
      ..username = _usernameController.text
      ..email = _userProvider.email
      ..tagline = _taglineController.text
      ..bio = _bioController.text);

    final res = await FirestoreServices.saveUser(newUser, image);
    if (res) {
      _userProvider.loadUser();
    } else {
      Fluttertoast.showToast(msg: 'Error in sign up');
    }
  }

  @override
  Widget build(BuildContext context) {
    const labelTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: BgGradient(
        bgColor: Colors.black54,
        foregroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 60),
                InkWell(
                  onTap: _pickImage,
                  child: image == null
                      ? CircleAvatar(
                          radius: MediaQuery.of(context).size.height * 0.1,
                          backgroundColor: Colors.white54,
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt_sharp,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.height * 0.1,
                              backgroundImage: image,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: labelTextStyle,
                  ),
                  style: labelTextStyle,
                  validator: (val) {
                    if (val?.isNotEmpty != true)
                      return "Please fill this field";
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: labelTextStyle,
                  ),
                  style: labelTextStyle,
                  validator: (val) {
                    val ??= '';
                    if (val.length < 3) return "Atleast 3 characters";
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _taglineController,
                  style: labelTextStyle,
                  decoration: const InputDecoration(
                    labelText: 'Punch line about you (optional)',
                    labelStyle: labelTextStyle,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bioController,
                  style: labelTextStyle,
                  decoration: const InputDecoration(
                    labelText: 'Bio (Optional)',
                    labelStyle: labelTextStyle,
                  ),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                Card(
                    color: Colors.redAccent.shade400,
                    shadowColor: Colors.white,
                    child: InkWell(
                      onTap: () => _saveUser(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: const Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
