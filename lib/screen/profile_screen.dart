import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedThemed = 'Light';

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_dateController.text.isNotEmpty) {
      initialDate = DateTime.tryParse(_dateController.text) ?? DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          textAlign: TextAlign.center,
          'Your Profile',
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        'https://tse1.mm.bing.net/th?id=OIP.F4hNpdgapQWM6TbvukUp9QHaE8&pid=Api&P=0&h=180l'),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Name'),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.edit)),
                ),
                const SizedBox(height: 16),
                const Text('Email'),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.edit),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Password'),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.edit)),
                ),
                const SizedBox(height: 16),
                const Text('Date Of Birth'),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Theme'),
                DropdownButtonFormField<String>(
                  value: _selectedThemed,
                  items: ['Light', 'Dark'].map((String theme) {
                    return DropdownMenuItem<String>(
                      value: theme,
                      child: const Text('Light'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedThemed = newValue!;
                      // Change the theme of the app here if needed
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15)),
                        child: const Text('Logout')),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
