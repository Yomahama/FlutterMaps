import 'package:flutter/material.dart';
import 'package:tracking_health/decorations/text_field.dart';
import 'package:tracking_health/model/user.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  User user;

  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _surnameKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _surnameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGreeting(),
        const SizedBox(height: 50),
        _buildNameTextField(),
        const SizedBox(height: 15),
        _buildSurnameTextField(),
        const SizedBox(height: 15),
        _buildButton()
      ],
    );
  }

  Widget _buildGreeting() {
    return RichText(
        text: const TextSpan(children: [
      TextSpan(text: 'No more headaches \n with'),
      TextSpan(
          text: 'Dept Simplifier',
          style: TextStyle(fontWeight: FontWeight.bold))
    ]));
  }

  Widget _buildNameTextField() {
    return Form(
      key: _nameKey,
      child: TextFormField(
        controller: _nameController,
        textInputAction: TextInputAction.next,
        decoration: customInputDecoration.copyWith(hintText: 'First name'),
      ),
    );
  }

  Widget _buildSurnameTextField() {
    return Form(
      key: _surnameKey,
      child: TextFormField(
        controller: _surnameController,
        textInputAction: TextInputAction.done,
        decoration: customInputDecoration.copyWith(hintText: 'Last name'),
      ),
    );
  }

  Widget _buildButton() {
    return TextButton(
      onPressed: () => _buttonPressed(),
      child: Text('Sign in'),
    );
  }

  void _buttonPressed() {
    user = User(null, _nameController.text, _surnameController.text);

    //TODO add to database
  }
}
