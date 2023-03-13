import 'package:chat_online_frontend/view/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _txtController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[600],
      body: const Placeholder(),
    );
  }

  void navToChat({required String token, required String username}) async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences.getInstance().then((sharedPf) {
        sharedPf.setString("token", token);
        sharedPf.setString("username", username);
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ChatView(),
        ),
      );
    }
  }

}
