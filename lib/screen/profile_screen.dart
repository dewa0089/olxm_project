import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olxm_project/screen/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final DateTime dateOfBirth;

  const ProfileScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
    required this.dateOfBirth,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dateController;
  late final TextEditingController _passwordController;
  String _selectedTheme = 'Light';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
    _dateController = TextEditingController(
        text: "${widget.dateOfBirth.toLocal()}".split(' ')[0]);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_dateController.text.isNotEmpty) {
      initialDate = DateTime.tryParse(_dateController.text) ?? DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                decoration: const InputDecoration(labelText: 'Old Password'),
                obscureText: true,
              ),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String oldPassword = oldPasswordController.text;
                String newPassword = newPasswordController.text;

                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  // Re-authenticate user with their old password
                  AuthCredential credential = EmailAuthProvider.credential(
                      email: user!.email!, password: oldPassword);
                  await user.reauthenticateWithCredential(credential);
                  // Change password
                  await user.updatePassword(newPassword);
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (error) {
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update password: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                    'https://tse1.mm.bing.net/th?id=OIP.F4hNpdgapQWM6TbvukUp9QHaE8&pid=Api&P=0&h=180l'),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 35.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 35.0),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35.0),
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              items: ['Light', 'Dark'].map((String theme) {
                return DropdownMenuItem<String>(
                  value: theme,
                  child: Text(theme), // Corrected here
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTheme = newValue!;
                  // Change the theme of the app here if needed
                });
              },
              decoration: const InputDecoration(
                labelText: 'Theme',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 35.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _changePassword(context);
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(200, 40), // Atur ukuran minimum sesuai kebutuhan Anda
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut().then(
                  (value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
