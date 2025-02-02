import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase;

  AuthService(this.supabase);

  User? get currentUser => supabase.auth.currentUser;

  Stream<AuthState> get authStateChange => supabase.auth.onAuthStateChange;

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return response;
    } catch (error) {
      throw Exception('Erreur d\'inscription: $error');
    }
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      debugPrint('Erreur de connexion: $error');
      throw Exception('Erreur de connexion...');
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      debugPrint('Erreur de déconnexion: $error');
      throw Exception('Erreur de déconnexion...');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Erreur de réinitialisation du mot de passe: $error');
    }
  }
}
