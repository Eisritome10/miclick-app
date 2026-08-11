import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'services/supabase_service.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/quiz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yncojnimqcgyxwfdkfoo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InluY29qbmltcWNneXh3ZmRrZm9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYzNzIyMDUsImV4cCI6MjEwMTk0ODIwNX0.9FZ0eEp2CrFf51nW0XP3CS3nce3o-0tsphrj3G9LTn4',
  );

  runApp(const MiClickApp());
}

class MiClickApp extends StatelessWidget {
  const MiClickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiClick',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF38BDF8),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF818CF8),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: SupabaseService.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = SupabaseService.client.auth.currentSession;

        if (session == null) {
          return const LoginScreen();
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: SupabaseService.getUserProfile(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final profile = profileSnapshot.data ?? {'full_name': 'Explorador/a', 'role': 'player'};
            final role = profile['role'] ?? 'player';

            if (role == 'admin') {
              return const AdminDashboardScreen();
            } else {
              return HomeScreen(
                userName: profile['full_name'] ?? 'Explorador/a',
                avatarUrl: profile['avatar_url'],
              );
            }
          },
        );
      },
    );
  }
}

// Pantalla de Autenticación Unificada (Google, Correo e Invitado)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _guestNameController = TextEditingController();

  bool _isLoading = false;
  bool _isSignUp = false;
  bool _isGuestMode = false;

  // Traducir los mensajes de error de Supabase
  String _getAuthErrorMessage(AuthException error) {
    final message = error.message.toLowerCase();
    if (message.contains('invalid login credentials') || message.contains('invalid_credentials')) {
      return 'Correo o contraseña incorrectos. Revisa tus datos.';
    } else if (message.contains('user already registered') || message.contains('email_exists')) {
      return 'Este correo ya está registrado. Intenta iniciar sesión.';
    } else if (message.contains('password should be at least')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    } else if (message.contains('unable to validate email address') || message.contains('invalid_email')) {
      return 'Por favor ingresa un correo electrónico válido.';
    }
    return 'Error de autenticación: ${error.message}';
  }

  Future<void> _submitEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa los campos de correo y contraseña.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        await SupabaseService.signUpWithEmail(
          email,
          password,
          _nameController.text.trim().isEmpty ? 'Explorador/a' : _nameController.text.trim(),
        );
      } else {
        await SupabaseService.signInWithEmail(email, password);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getAuthErrorMessage(e)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ocurrió un error inesperado: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitGuest() async {
    setState(() => _isLoading = true);
    try {
      await SupabaseService.signInAsGuest(_guestNameController.text.trim());
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getAuthErrorMessage(e)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al ingresar como invitado: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'MiClick',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Descubre tu perfil digital de comunicación',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // MODO INVITADO
                if (_isGuestMode) ...[
                  TextField(
                    controller: _guestNameController,
                    decoration: const InputDecoration(
                      labelText: '¿Cómo te gustaría que te llamemos?',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline, color: Color(0xFF38BDF8)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitGuest,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8)),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('Entrar Directo como Invitado 🚀', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() => _isGuestMode = false),
                    child: const Text('Volver a opciones de cuenta'),
                  ),
                ] 
                // MODO REGISTRO / LOGIN CON CUENTA
                else ...[
                  if (_isSignUp) ...[
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitEmailAuth,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8)),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(_isSignUp ? 'Registrarse e Ingresar' : 'Iniciar Sesión', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => SupabaseService.signInWithGoogle(),
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: const Text('Continuar con Google'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('o', style: TextStyle(color: Colors.white38)),
                      ),
                      Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _isGuestMode = true),
                      icon: const Icon(Icons.bolt, color: Colors.amber),
                      label: const Text('Ingreso Rápido (Invitado)'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        foregroundColor: Colors.amber,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(_isSignUp ? '¿Ya tienes cuenta? Inicia sesión' : '¿No tienes cuenta? Regístrate gratis'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Pantalla Principal del Jugador
class HomeScreen extends StatefulWidget {
  final String userName;
  final String? avatarUrl;

  const HomeScreen({
    super.key,
    required this.userName,
    this.avatarUrl,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/menu_bg.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. VIDEO EN BUCLE DE FONDO
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          else
            Container(color: const Color(0xFF0F172A)),

          // 2. CAPA OSCURA SEMITRANSPARENTE
          Container(
            color: Colors.black.withOpacity(0.55),
          ),

          // 3. CONTENIDO DEL MENÚ PRINCIPAL
          SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text('MiClick - Menú Principal'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async => await SupabaseService.client.auth.signOut(),
                  ),
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 550),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // AVATAR DEL USUARIO (Foto de Google o icono por defecto)
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: const Color(0xFF38BDF8),
                          backgroundImage: widget.avatarUrl != null ? NetworkImage(widget.avatarUrl!) : null,
                          child: widget.avatarUrl == null
                              ? const Icon(Icons.person, size: 48, color: Colors.black)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '¡Bienvenido/a, ${widget.userName}! 👋',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Hoy serás el protagonista de la historia. Vive tus decisiones digitales cotidianas frente al celular.\n\n'
                          'Cada decisión ante mensajes, redes sociales e Inteligencia Artificial calculará tu perfil de Alfabetización Mediática e Informacional (MIL).',
                          style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizScreen(userName: widget.userName),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow, size: 28),
                            label: const Text('Comenzar Mi Historia', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38BDF8),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}