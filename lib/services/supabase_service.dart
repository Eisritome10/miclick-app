import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // 1. Obtener el usuario actual
  static User? get currentUser => client.auth.currentUser;

  // 2. Iniciar sesión con Google (Soporta Web y Android APK)
  static Future<bool> signInWithGoogle() async {
    try {
      return await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'https://tu-app-miclick.vercel.app', // Tu URL de producción
      );
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return false;
    }
  }

  // 3. Registrar o Iniciar Sesión con Correo / Contraseña
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

  // 4. Guardar los resultados del Quiz al finalizar la historia
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

  // 5. Método para el Dashboard Admin: Escuchar en TIEMPO REAL los registros de los quizzes
  static Stream<List<Map<String, dynamic>>> getRealtimeQuizSessions() {
    return client
        .from('quiz_sessions')
        .stream(primaryKey: ['id'])
        .order('completed_at', ascending: false);
  }

  // 6. Obtener el perfil y rol del usuario logueado
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return response;
  }
}