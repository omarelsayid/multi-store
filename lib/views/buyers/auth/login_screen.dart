import 'package:flutter/material.dart';
import 'package:multi_store/controllers/auth_conroller.dart';
import 'package:multi_store/utils/show_snak_bar.dart';
import 'package:multi_store/vendors/views/screens/main_vendor_screen.dart';
import 'package:multi_store/views/buyers/auth/register_screen.dart';
import 'package:multi_store/views/buyers/main_screen.dart';

class BuyersLoginScreen extends StatefulWidget {
  @override
  State<BuyersLoginScreen> createState() => _BuyersLoginScreenState();
}

class _BuyersLoginScreenState extends State<BuyersLoginScreen> {
  late String email;

  late String password;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final AuthController _authController = AuthController();
  bool _isLoading = false;
  _loginUsers() async {
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);
    } else {
      setState(() {
        _isLoading = true;
      });
      return showSnakBar(context, 'Please feilds must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              'Login custome\'s Account',
              style: TextStyle(fontSize: 20),
            )),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please email filed must not be empty ';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    const InputDecoration(labelText: 'Enter Email Aadress'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please password filed must not be empty ';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  password = value;
                },
                decoration: const InputDecoration(labelText: 'Enter Password'),
              ),
            ),
            InkWell(
              onTap: () async{
               await _loginUsers();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const MainScreen();
                }));
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.yellow.shade900,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('don\'t Have An Account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return buyersRegisterScreen();
                        },
                      ));
                    },
                    child: const Text('Rigester'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
