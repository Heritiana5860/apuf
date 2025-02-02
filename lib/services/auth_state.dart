import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRequired extends StatefulWidget {
  const AuthRequired({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  _AuthRequiredState createState() => _AuthRequiredState();
}

class _AuthRequiredState extends State<AuthRequired> {
  @override
  void initState() {
    super.initState();
    _redirectIfNotSignedIn();
  }

  Future<void> _redirectIfNotSignedIn() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
