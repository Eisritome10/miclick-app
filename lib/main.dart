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
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InluY29qbmltcWNneXh3ZmRrZm9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYzNzIyMDUsImV4cCI6MjEwMTk0ODIwNX0.9FZ0eEp2CrFf51nW0XP3CS3nce3o-0tsphrj3G9LTn4',
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

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Idioma global seleccionado ('en' por defecto para prioridad internacional UNESCO)
  String _selectedLanguage = 'en';

  void _onLanguageChanged(String lang) {
    setState(() {
      _selectedLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: SupabaseService.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = SupabaseService.client.auth.currentSession;

        if (session == null) {
          return LoginScreen(
            currentLanguage: _selectedLanguage,
            onLanguageChanged: _onLanguageChanged,
          );
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: SupabaseService.getUserProfile(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final profile = profileSnapshot.data ??
                {'full_name': 'Explorador/a', 'role': 'player'};
            final role = profile['role'] ?? 'player';

            if (role == 'admin') {
              return const AdminDashboardScreen();
            } else {
              return HomeScreen(
                userName: profile['full_name'] ?? 'Explorador/a',
                avatarUrl: profile['avatar_url'],
                initialLanguage: _selectedLanguage,
              );
            }
          },
        );
      },
    );
  }
}

// Pantalla de Autenticación con Selector de Idioma Pre-Login
class LoginScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const LoginScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

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

  late String _lang;

  @override
  void initState() {
    super.initState();
    _lang = widget.currentLanguage;
  }

  // Diccionario inline para el Login
  String _t(String key) {
    final isEn = _lang == 'en';
    switch (key) {
      case 'subtitle':
        return isEn
            ? 'Discover your MIL communication profile'
            : 'Descubre tu perfil digital de comunicación';
      case 'guest_prompt':
        return isEn
            ? 'How would you like us to call you?'
            : '¿Cómo te gustaría que te llamemos?';
      case 'enter_guest':
        return isEn ? 'Enter Direct as Guest 🚀' : 'Entrar Directo como Invitado 🚀';
      case 'back_options':
        return isEn ? 'Back to account options' : 'Volver a opciones de cuenta';
      case 'full_name':
        return isEn ? 'Full Name' : 'Nombre Completo';
      case 'email':
        return isEn ? 'Email Address' : 'Correo Electrónico';
      case 'password':
        return isEn ? 'Password' : 'Contraseña';
      case 'sign_in':
        return isEn ? 'Sign In' : 'Iniciar Sesión';
      case 'sign_up':
        return isEn ? 'Register & Enter' : 'Registrarse e Ingresar';
      case 'continue_google':
        return isEn ? 'Continue with Google' : 'Continuar con Google';
      case 'quick_guest':
        return isEn ? 'Quick Entry (Guest)' : 'Ingreso Rápido (Invitado)';
      case 'has_account':
        return isEn
            ? 'Already have an account? Sign in'
            : '¿Ya tienes cuenta? Inicia sesión';
      case 'no_account':
        return isEn
            ? 'Don\'t have an account? Register for free'
            : '¿No tienes cuenta? Regístrate gratis';
      case 'empty_fields':
        return isEn
            ? 'Please fill in email and password.'
            : 'Por favor completa los campos de correo y contraseña.';
      default:
        return '';
    }
  }

  String _getAuthErrorMessage(AuthException error) {
    final isEn = _lang == 'en';
    final message = error.message.toLowerCase();
    if (message.contains('invalid login credentials') ||
        message.contains('invalid_credentials')) {
      return isEn
          ? 'Incorrect email or password. Please check your data.'
          : 'Correo o contraseña incorrectos. Revisa tus datos.';
    } else if (message.contains('user already registered') ||
        message.contains('email_exists')) {
      return isEn
          ? 'This email is already registered. Try signing in.'
          : 'Este correo ya está registrado. Intenta iniciar sesión.';
    } else if (message.contains('password should be at least')) {
      return isEn
          ? 'Password must be at least 6 characters long.'
          : 'La contraseña debe tener al menos 6 caracteres.';
    }
    return isEn
        ? 'Authentication error: ${error.message}'
        : 'Error de autenticación: ${error.message}';
  }

  Future<void> _submitEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t('empty_fields'))),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        await SupabaseService.signUpWithEmail(
          email,
          password,
          _nameController.text.trim().isEmpty
              ? (_lang == 'en' ? 'Explorer' : 'Explorador/a')
              : _nameController.text.trim(),
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
            content: Text('Error: ${e.toString()}'),
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
            content: Text('Error: ${e.toString()}'),
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
                // SELECTOR DE IDIOMA EN LA PARTE SUPERIOR DEL LOGIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.language, color: Color(0xFF38BDF8), size: 18),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _lang = _lang == 'en' ? 'es' : 'en';
                        });
                        widget.onLanguageChanged(_lang);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF38BDF8)),
                        ),
                        child: Text(
                          _lang == 'en' ? '🇬🇧 English' : '🇵🇪 Español',
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // LOGO Y TÍTULO
                Image.asset(
                  'assets/images/logo.png',
                  height: 64,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.mouse,
                    size: 54,
                    color: Color(0xFF38BDF8),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'MiClick',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38BDF8)),
                ),
                const SizedBox(height: 6),
                Text(
                  _t('subtitle'),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // MODO INVITADO
                if (_isGuestMode) ...[
                  TextField(
                    controller: _guestNameController,
                    decoration: InputDecoration(
                      labelText: _t('guest_prompt'),
                      border: const OutlineInputBorder(),
                      prefixIcon:
                          const Icon(Icons.person_outline, color: Color(0xFF38BDF8)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitGuest,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8)),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              _t('enter_guest'),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() => _isGuestMode = false),
                    child: Text(_t('back_options')),
                  ),
                ]
                // MODO REGISTRO / LOGIN CON CUENTA
                else ...[
                  if (_isSignUp) ...[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: _t('full_name'),
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: _t('email'),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: _t('password'),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitEmailAuth,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8)),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              _isSignUp ? _t('sign_up') : _t('sign_in'),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => SupabaseService.signInWithGoogle(),
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: Text(_t('continue_google')),
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48)),
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
                      label: Text(_t('quick_guest')),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        foregroundColor: Colors.amber,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(_isSignUp ? _t('has_account') : _t('no_account')),
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

// Pantalla Principal del Jugador (con Selector Sincronizado)
class HomeScreen extends StatefulWidget {
  final String userName;
  final String? avatarUrl;
  final String initialLanguage;

  const HomeScreen({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.initialLanguage = 'en',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _videoController;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;

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
    final isEnglish = _selectedLanguage == 'en';

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
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 28,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.mouse, color: Color(0xFF38BDF8)),
                    ),
                    const SizedBox(width: 10),
                    const Text('MiClick'),
                  ],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    tooltip: isEnglish ? 'Logout' : 'Cerrar Sesión',
                    icon: const Icon(Icons.logout),
                    onPressed: () async =>
                        await SupabaseService.client.auth.signOut(),
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
                        // AVATAR DEL USUARIO
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: const Color(0xFF38BDF8),
                          backgroundImage: widget.avatarUrl != null
                              ? NetworkImage(widget.avatarUrl!)
                              : null,
                          child: widget.avatarUrl == null
                              ? const Icon(Icons.person,
                                  size: 48, color: Colors.black)
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // MENSAJE DE BIENVENIDA
                        Text(
                          isEnglish
                              ? 'Welcome, ${widget.userName}! 👋'
                              : '¡Bienvenido/a, ${widget.userName}! 👋',
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF38BDF8)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),

                        Text(
                          isEnglish
                              ? 'Today you are the protagonist of the story. Experience your daily digital choices on your phone.\n\n'
                                  'Every decision regarding messages, social media, and Artificial Intelligence will compute your Media and Information Literacy (MIL) profile.'
                              : 'Hoy serás el protagonista de la historia. Vive tus decisiones digitales cotidianas frente al celular.\n\n'
                                  'Cada decisión ante mensajes, redes sociales e Inteligencia Artificial calculará tu perfil de Alfabetización Mediática e Informacional (MIL).',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white70, height: 1.4),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // SELECTOR DE IDIOMA DENTRO DEL MENÚ
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.language,
                                  color: Color(0xFF38BDF8), size: 20),
                              const SizedBox(width: 10),
                              ChoiceChip(
                                label: const Text('English 🇬🇧'),
                                selected: _selectedLanguage == 'en',
                                selectedColor: const Color(0xFF38BDF8),
                                labelStyle: TextStyle(
                                  color: _selectedLanguage == 'en'
                                      ? Colors.black
                                      : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedLanguage = 'en');
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text('Español 🇵🇪'),
                                selected: _selectedLanguage == 'es',
                                selectedColor: const Color(0xFF38BDF8),
                                labelStyle: TextStyle(
                                  color: _selectedLanguage == 'es'
                                      ? Colors.black
                                      : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedLanguage = 'es');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // BOTÓN PARA INICIAR LA HISTORIA
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                    userName: widget.userName,
                                    language: _selectedLanguage,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow, size: 28),
                            label: Text(
                              isEnglish
                                  ? 'Start My Story'
                                  : 'Comenzar Mi Historia',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38BDF8),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
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