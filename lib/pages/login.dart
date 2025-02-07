import 'package:app/components/button.dart';
import 'package:app/components/field.dart';
import 'package:app/components/text.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthService _authService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(Supabase.instance.client);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (error) {
      if (mounted) {
        debugPrint(error.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidget(
              label: "Compte invalide!",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.03;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Icon(
                          Icons.lock,
                          size: screenWidth * 0.2,
                          color: Color(0xFF52575D),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Titre
                        FittedBox(
                          child: TextWidget(
                            label: "Connexion",
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Champ Email
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding * 0.3,
                          ),
                          child: FieldWidget(
                            controller: _emailController,
                            icon: Icons.email,
                            labelText: "Email",
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre email';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Veuillez entrer un email valide';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Champ Mot de passe
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding * 0.3,
                          ),
                          child: FieldWidget(
                            controller: _passwordController,
                            icon: Icons.lock,
                            labelText: "Mot de passe",
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre mot de passe';
                              }
                              if (value.length < 6) {
                                return 'Le mot de passe doit contenir au moins 6 caractères';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Bouton de connexion
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ButtonWidget(
                                screenWidth: screenWidth,
                                label: "Se connecter",
                                formKey: _formKey,
                                onTap: _isLoading ? null : _signIn,
                              ),

                        SizedBox(height: screenHeight * 0.02),

                        // Lien mot de passe oublié
                        TextButton(
                          onPressed: () {
                            // Ajoutez ici la logique pour réinitialiser le mot de passe
                          },
                          child: Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.04,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
