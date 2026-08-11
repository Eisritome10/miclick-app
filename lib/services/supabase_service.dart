import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  static User? get currentUser => client.auth.currentUser;

  // 1. Iniciar sesión con Google
  static Future<bool> signInWithGoogle() async {
    try {
      return await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb
            ? 'https://miclickapp.netlify.app'
            : 'io.supabase.miclick://login-callback',
      );
    } catch (e) {
      debugPrint('Error al iniciar sesión con Google: $e');
      return false;
    }
  }

  // 2. Registro e Inicio por Correo
  static Future<AuthResponse> signUpWithEmail(String email, String password, String name) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
  }

  static Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // 3. Ingreso Rápido como Invitado (Anónimo)
  static Future<AuthResponse> signInAsGuest(String guestName) async {
    final name = guestName.trim().isEmpty ? 'Invitado/a' : guestName.trim();
    return await client.auth.signInAnonymously(
      data: {'full_name': name},
    );
  }

  // 4. Guardar resultados del Quiz
  static Future<void> saveQuizResult({
    required int scoreV,
    required int scoreE,
    required int scoreA,
    required int scoreC,
    required String finalProfile,
    int? completionTimeSeconds,
  }) async {
    final user = currentUser;
    if (user == null) return;

    await client.from('quiz_sessions').insert({
      'user_id': user.id,
      'score_v': scoreV,
      'score_e': scoreE,
      'score_a': scoreA,
      'score_c': scoreC,
      'final_profile': finalProfile,
      'completion_time_seconds': completionTimeSeconds ?? 0,
    });
  }

  // 5. Escuchador en Tiempo Real para el Dashboard Admin
  static Stream<List<Map<String, dynamic>>> getRealtimeQuizSessions() {
    return client
        .from('quiz_sessions')
        .stream(primaryKey: ['id'])
        .order('completed_at', ascending: false);
  }

  // 6. Obtener Perfil y Foto con Manejo Robusto de Errores
  static Future<Map<String, dynamic>> getUserProfile() async {
    final user = currentUser;
    if (user == null) {
      return {'full_name': 'Explorador/a', 'avatar_url': null, 'role': 'player'};
    }

    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return {
          'id': user.id,
          'full_name': response['full_name'] ?? user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? 'Explorador/a',
          'avatar_url': response['avatar_url'] ?? user.userMetadata?['avatar_url'] ?? user.userMetadata?['picture'],
          'role': response['role'] ?? 'player',
        };
      }
    } catch (e) {
      debugPrint('Aviso obteniendo tabla profiles: $e');
    }

    // Fallback directo desde Auth Metadata
    final meta = user.userMetadata ?? {};
    return {
      'id': user.id,
      'full_name': meta['full_name'] ?? meta['name'] ?? (user.isAnonymous ? 'Invitado/a' : 'Explorador/a'),
      'avatar_url': meta['avatar_url'] ?? meta['picture'],
      'role': 'player',
    };
  }
}