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
  // Método optimizado para transmitir los quizzes en tiempo real al Admin
  static Stream<List<Map<String, dynamic>>> getRealtimeQuizSessions() {
    return client
        .from('quiz_sessions')
        .stream(primaryKey: ['id'])
        .order('completed_at', ascending: false)
        .asyncMap((sessions) async {
          if (sessions.isEmpty) return [];

          // Obtener IDs de usuarios únicos
          final userIds = sessions
              .map((s) => s['user_id'] as String?)
              .where((id) => id != null)
              .cast<String>()
              .toSet()
              .toList();

          if (userIds.isEmpty) return sessions;

          try {
            // Consultar perfiles asociados para mostrar nombres de los evaluados
            final profilesResponse = await client
                .from('profiles')
                .select('id, full_name, role')
                .filter('id', 'in', userIds);

            final profilesMap = {for (var p in profilesResponse) p['id']: p};

            return sessions.map((session) {
              final profile = profilesMap[session['user_id']];
              return {
                ...session,
                'profiles': profile,
              };
            }).toList();
          } catch (e) {
            debugPrint('Aviso leyendo perfiles en Realtime: $e');
            return sessions;
          }
        });
  }

  // 6. Obtener Perfil con extracción ultra segura de metadatos
  // Obtener Perfil con detección directa de correo Semilla Admin
  static Future<Map<String, dynamic>> getUserProfile() async {
    final user = currentUser;
    if (user == null) {
      return {'full_name': 'Explorador/a', 'avatar_url': null, 'role': 'player'};
    }

    // 1. VERIFICACIÓN DIRECTA DE CORREO ADMIN (Semilla)
    if (user.email == 'admin@miclick.com') {
      return {
        'id': user.id,
        'full_name': 'Administrador Principal',
        'avatar_url': user.userMetadata?['avatar_url'],
        'role': 'admin',
      };
    }

    // 2. Consulta a la tabla public.profiles en Supabase
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

    // 3. Fallback para Jugadores / Invitados
    final meta = user.userMetadata ?? {};
    return {
      'id': user.id,
      'full_name': meta['full_name'] ?? meta['name'] ?? (user.isAnonymous ? 'Invitado/a' : 'Explorador/a'),
      'avatar_url': meta['avatar_url'] ?? meta['picture'],
      'role': 'player',
    };
  }

  // Borrar un registro de quiz por su ID (Solo Admin)
  static Future<void> deleteQuizSession(String sessionId) async {
    await client
        .from('quiz_sessions')
        .delete()
        .eq('id', sessionId);
  }
}