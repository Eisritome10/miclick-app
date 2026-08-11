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

  // 2. Registro e Inicio por Correo (Sin verificación requerida)
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

  // 3. INGRESO RÁPIDO COMO INVITADO (Autenticación Anónima)
  static Future<AuthResponse> signInAsGuest(String guestName) async {
    final name = guestName.trim().isEmpty ? 'Invitado/a' : guestName.trim();
    return await client.auth.signInAnonymously(
      data: {'full_name': name},
    );
  }

  // 4. Guardar resultados del Quiz en Supabase
  static Future<void> saveQuizResult({
    required int scoreV,
    required int scoreE,
    required int scoreA,
    required int scoreC,
    required String finalProfile,
    int? completionTimeSeconds,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

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

  // 6. Obtener Perfil de Usuario con fallback seguro
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) return response;

      // Si el perfil aún se está creando en la base de datos, retornamos datos temporales
      final metadata = user.userMetadata ?? {};
      return {
        'id': user.id,
        'full_name': metadata['full_name'] ?? metadata['name'] ?? 'Explorador/a',
        'role': 'player',
      };
    } catch (e) {
      debugPrint('Error obteniendo perfil: $e');
      return {
        'id': user.id,
        'full_name': 'Explorador/a',
        'role': 'player',
      };
    }
  }
}