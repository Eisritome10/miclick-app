import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/supabase_service.dart';

class QuizOption {
  final String text;
  final int v; // Verificación
  final int e; // Impulso Emocional
  final int a; // Conciencia Algorítmica/IA
  final int c; // Creación Responsable

  QuizOption({
    required this.text,
    this.v = 0,
    this.e = 0,
    this.a = 0,
    this.c = 0,
  });
}

// Paso narrativo dentro de una escena general
class SceneStep {
  final String time;
  final String title;
  final String description;
  final String imagePath;
  final String? characterDialog; // Diálogo de personaje
  final List<QuizOption>? options; // Solo si requiere decisión

  SceneStep({
    required this.time,
    required this.title,
    required this.description,
    required this.imagePath,
    this.characterDialog,
    this.options,
  });
}

class QuizScreen extends StatefulWidget {
  final String userName;
  const QuizScreen({super.key, required this.userName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentStepIndex = 0;

  // Acumuladores de los 4 Ejes MIL
  int _scoreV = 0;
  int _scoreE = 0;
  int _scoreA = 0;
  int _scoreC = 0;

  List<SceneStep> _getSteps() {
    return [
      // ==========================================
      // ESCENA GENERAL 1: EL DESPERTAR Y EL MENSAJE
      // ==========================================
      SceneStep(
        time: "8:00 a. m.",
        title: "1. DESPERTAR - Abriendo los ojos",
        imagePath: "assets/images/escena1_ojos_cerrados.jpeg",
        description: "Abres los ojos lentamente. La luz del sol entra por tu ventana y sientes la vibración constante de tu celular en la mesa de noche.",
      ),
      SceneStep(
        time: "8:01 a. m.",
        title: "1. DESPERTAR - Habitación",
        imagePath: "assets/images/escena1_despierto.jpeg",
        description: "Te levantas de la cama frotándote los ojos. El celular no deja de sonar. Piensas: 'Qué raro... ¿quién estará enviando tantos mensajes a esta hora?'",
      ),
      SceneStep(
        time: "8:03 a. m.",
        title: "1. DESPERTAR - Mensaje del Tío",
        imagePath: "assets/images/escena1_mensaje_tio.jpeg",
        description: "Tomas tu celular y ves una captura enviada por tu tío a toda la familia alertando sobre un supuesto corte de agua potable.",
        options: [
          QuizOption(text: "Reenviar la imagen a otros grupos de inmediato para que todos estén precavidos.", e: 3),
          QuizOption(text: "Buscar en internet si las autoridades confirmaron el corte de agua antes de enviar nada.", v: 3),
          QuizOption(text: "Escribirle a mi tío por privado para preguntarle de dónde sacó esa imagen.", v: 2, c: 1),
          QuizOption(text: "Ignorar la notificación y dejar el celular a un lado.", v: 1),
        ],
      ),

      // ==========================================
      // ESCENA GENERAL 2: DESAYUNO Y DIÁLOGOS
      // ==========================================
      SceneStep(
        time: "8:20 a. m.",
        title: "2. DESAYUNO - La Cocina",
        imagePath: "assets/images/escena2_cocina.jpeg",
        description: "Te diriges a la cocina a preparar el desayuno y te encuentras con tu mamá.",
      ),
      SceneStep(
        time: "8:22 a. m.",
        title: "2. DESAYUNO - Conversación con Mamá",
        imagePath: "assets/images/escena2_mama_hablando.jpeg",
        description: "Tu mamá te mira preocupada esperando tu respuesta.",
        characterDialog: "Mamá: 'Buenos días, ${widget.userName}. ¿Viste la alerta urgente que envió tu tío sobre el agua?'",
        options: [
          QuizOption(text: "Sí mamá, ya se lo reenvié a todos mis contactos por si acaso.", e: 2),
          QuizOption(text: "No investigué mucho aún, pero lo revisaré en un momento.", v: 2),
          QuizOption(text: "Mi tío siempre se cree todo lo que ve en WhatsApp, no le hagas caso.", v: 1),
          QuizOption(text: "Le sugiero que verifique en fuentes oficiales antes de enviárselo a sus amigas.", v: 2, c: 2),
        ],
      ),

      // ==========================================
      // ESCENA GENERAL 3: REDES SOCIALES, AUDÍFONOS Y CINE
      // ==========================================
      SceneStep(
        time: "11:00 a. m.",
        title: "3. REDES SOCIALES - Oferta en tu Feed",
        imagePath: "assets/images/escena3_oferta_audifonos.jpeg",
        description: "Estás ahorrando para unos audífonos. Luego de buscar reseñas hace unos días, abres tus redes sociales y ves una oferta destacada.",
      ),
      SceneStep(
        time: "11:05 a. m.",
        title: "3. REDES SOCIALES - Comparando Reseñas",
        imagePath: "assets/images/escena3_resenas_audifonos.jpeg",
        description: "Deslizas la pantalla y te aparecen dos publicaciones distintas con opiniones sobre diferentes marcas de audífonos.",
        options: [
          QuizOption(text: "¡Aprovecharé esta oferta y los compraré de una vez!", e: 2),
          QuizOption(text: "Siento que el algoritmo sabe exactamente lo que necesito comprar.", v: 1, e: 1, a: 1),
          QuizOption(text: "Imagino que me aparecen porque estuve buscando audífonos previamente.", v: 1, a: 2, c: 1),
          QuizOption(text: "Voy a comparar qué precios y reseñas les aparecen a mis amigos.", v: 2, a: 2, c: 1),
        ],
      ),
      SceneStep(
        time: "11:15 a. m.",
        title: "3. REDES SOCIALES - Recordatorio de Salida",
        imagePath: "assets/images/escena3_oferta_cine.jpeg",
        description: "Sigues deslizando la red social y te cruzas con un anuncio de promoción 3x2 en cine. Te recuerdas que hoy quedaste en ir al cine con tus amigos.",
      ),

      // ==========================================
      // ESCENA GENERAL 4: EL CINE Y EL DEEPFAKE
      // ==========================================
      SceneStep(
        time: "4:30 p. m.",
        title: "4. CINE - Salida con amigos",
        imagePath: "assets/images/escena4_cine.jpeg",
        description: "Llegas al cine y te encuentras con tu grupo. Mientras Sara va al baño un momento, tu amigo te llama riéndose con el celular en la mano.",
      ),
      SceneStep(
        time: "4:35 p. m.",
        title: "4. CINE - La imagen editada con IA",
        imagePath: "assets/images/escena4_deepfake.jpeg",
        description: "Tu amigo te muestra una foto donde usó Inteligencia Artificial para alterar el rostro de Sara en una escena comprometedora de la película.",
        characterDialog: "Amigo: 'Oye, ${widget.userName}, ¡mira lo que hice con IA! La mandaré al grupo de WhatsApp, es un meme muy gracioso.'",
        options: [
          QuizOption(text: "¡Ja, ja! Envíalo al grupo de una vez para reírnos todos.", e: 2),
          QuizOption(text: "Le pido que no lo comparta, eso le va a incomodar bastante a Sara.", a: 2, c: 3),
          QuizOption(text: "Le digo que borre la imagen ahora mismo, no está bien usar su rostro así.", a: 2, c: 3),
          QuizOption(text: "Decido no decir nada, pero tampoco me reiré ni lo compartiré.", a: 1, c: 1),
        ],
      ),

      // ==========================================
      // ESCENA GENERAL 5: REGRESO A CASA Y VIAJE
      // ==========================================
      SceneStep(
        time: "7:30 p. m.",
        title: "5. REGRESO A CASA - La propuesta de Papá",
        imagePath: "assets/images/escena5_papa.jpeg",
        description: "Regresas a casa de noche. Tu papá te recibe entusiasmado frente a su laptop.",
      ),
      SceneStep(
        time: "7:35 p. m.",
        title: "5. REGRESO A CASA - Pasajes sospechosos",
        imagePath: "assets/images/escena5_oferta_viaje.jpeg",
        description: "Te muestra una publicación de Facebook con pasajes de bus al 50% de descuento. Notas fallas ortográficas en la imagen.",
        characterDialog: "Papá: 'Hola ${widget.userName}, mira esta oferta para el viaje familiar. ¿Compro los pasajes aquí de una vez?'",
        options: [
          QuizOption(text: "Me parece bien papá, si está en redes sociales seguro es una agencia real.", v: 0),
          QuizOption(text: "Le sugiero buscar opiniones y reclamos de otros usuarios antes de pagar.", v: 3),
          QuizOption(text: "Voy a revisar si la empresa tiene un sitio web oficial o RUC registrado.", v: 3, a: 1),
          QuizOption(text: "Comparemos los precios directamente en las agencias de transporte conocidas.", v: 2, c: 1),
        ],
      ),

      // ==========================================
      // ESCENA GENERAL 6: NOCHE Y COMUNICADO DE SISMO
      // ==========================================
      SceneStep(
        time: "11:45 p. m.",
        title: "6. NOCHE - El temblor",
        imagePath: "assets/images/escena6_temblor.jpeg",
        description: "Estás a punto de dormir cuando sientes que la cama tiembla fuertemente durante varios segundos.",
      ),
      SceneStep(
        time: "11:46 p. m.",
        title: "6. NOCHE - El susto",
        imagePath: "assets/images/escena6_temblor2.jpeg",
        description: "El temblor disminuye poco a poco. Tu celular sigue vibrando con notificaciones de mensajes y redes sociales.",
      ),
      SceneStep(
        time: "11:50 p. m.",
        title: "6. NOCHE - Falsa Alerta de Réplica",
        imagePath: "assets/images/escena6_alerta_sismo.jpeg",
        description: "Tomas tu teléfono por susto y ves una imagen circulando en redes con el logo de un organismo estatal sobre una réplica inminente.",
        options: [
          QuizOption(text: "Salgo corriendo a la calle inmediatamente sin dudarlo.", e: 3),
          QuizOption(text: "Verifico en la cuenta oficial verificada del instituto sismológico.", v: 3),
          QuizOption(text: "Aviso a mi familia con calma para revisar si el comunicado es oficial.", v: 2, e: 1, c: 2),
          QuizOption(text: "Lo ignoro por completo y trato de volver a dormir.", v: 0),
        ],
      ),
      SceneStep(
        time: "12:00 a. m.",
        title: "FIN DEL DÍA - A descansar",
        imagePath: "assets/images/escena6_temblor3.jpeg",
        description: "Pasaron muchas cosas y estás cansado. Decides apagar el celular y descansar para el día siguiente.",
      ),
    ];
  }

  void _nextStep() {
    setState(() {
      final steps = _getSteps();
      if (_currentStepIndex < steps.length - 1) {
        _currentStepIndex++;
      } else {
        _finishQuiz();
      }
    });
  }

  void _onOptionSelected(QuizOption option) {
    setState(() {
      _scoreV += option.v;
      _scoreE += option.e;
      _scoreA += option.a;
      _scoreC += option.c;

      final steps = _getSteps();
      if (_currentStepIndex < steps.length - 1) {
        _currentStepIndex++;
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    String profile = "Reactivo/a";

    if (_scoreC <= 4 && _scoreE >= 9) {
      profile = "Amplificador/a";
    } else if (_scoreA <= 1) {
      profile = "Ingenuo/a Digital";
    } else if (_scoreE >= 9 && _scoreV <= 7) {
      profile = "Reactivo/a";
    } else if (_scoreV >= 11 && _scoreA <= 1) {
      profile = "Confirmador/a";
    } else if (_scoreV >= 11 && _scoreC >= 7 && _scoreE <= 6) {
      profile = "Empático/a Crítico/a";
    } else if (_scoreV >= 11) {
      profile = "Investigador/a";
    }

    // Guardado en Supabase en tiempo real
    SupabaseService.saveQuizResult(
      scoreV: _scoreV,
      scoreE: _scoreE,
      scoreA: _scoreA,
      scoreC: _scoreC,
      finalProfile: profile,
    );

    // Navegación a la Pantalla de Análisis (Carga de 3 segundos con video)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyzingScreen(
          profile: profile,
          scoreV: _scoreV,
          scoreE: _scoreE,
          scoreA: _scoreA,
          scoreC: _scoreC,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();
    final currentStep = steps[_currentStepIndex];
    final bool hasOptions = currentStep.options != null && currentStep.options!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Paso ${_currentStepIndex + 1} de ${steps.length}'),
        backgroundColor: const Color(0xFF1E293B),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentStepIndex + 1) / steps.length,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 650),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Color(0xFF38BDF8), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      currentStep.time,
                      style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  currentStep.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // ILUSTRACIÓN DE LA ESCENA (Andrea)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    currentStep.imagePath,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        color: const Color(0xFF0F172A),
                        child: const Center(
                          child: Icon(Icons.image, color: Color(0xFF38BDF8), size: 40),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // DESCRIPCIÓN NARRATIVA
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    currentStep.description,
                    style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
                  ),
                ),

                // DIÁLOGO DEL PERSONAJE (SI EXISTE)
                if (currentStep.characterDialog != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF818CF8).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF818CF8)),
                    ),
                    child: Text(
                      currentStep.characterDialog!,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF818CF8), fontWeight: FontWeight.bold, height: 1.4),
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // SI EL PASO TIENE OPCIONES DE DECISIÓN
                if (hasOptions) ...[
                  const Text(
                    '¿Qué decisión vas a tomar?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ...currentStep.options!.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _onOptionSelected(option),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            side: const BorderSide(color: Color(0xFF38BDF8)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(
                            option.text,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ] 
                // SI ES UN PASO INTERMEDIO (SÓLO BOTÓN CONTINUAR)
                else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _nextStep,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Continuar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
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

// ==============================================================================
// PANTALLA INTERMEDIA DE CARGA / ANÁLISIS DE RESULTADOS (3 Segundos + Video)
// ==============================================================================
class AnalyzingScreen extends StatefulWidget {
  final String profile;
  final int scoreV;
  final int scoreE;
  final int scoreA;
  final int scoreC;

  const AnalyzingScreen({
    super.key,
    required this.profile,
    required this.scoreV,
    required this.scoreE,
    required this.scoreA,
    required this.scoreC,
  });

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  late VideoPlayerController _videoController;
  String _loadingText = "Analizando decisiones...";

  @override
  void initState() {
    super.initState();

    // Carga de video en bucle
    _videoController = VideoPlayerController.asset('assets/videos/menu2.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });

    // Cambiar texto a mitad de tiempo
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _loadingText = "Calculando el perfil de hoy...";
        });
      }
    });

    // Temporizador de 3 segundos antes de mostrar el resultado
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              profile: widget.profile,
              scoreV: widget.scoreV,
              scoreE: widget.scoreE,
              scoreA: widget.scoreA,
              scoreC: widget.scoreC,
            ),
          ),
        );
      }
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
          // 1. VIDEO DE FONDO EN BUCLE
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

          // 2. OVERLAY OSCURO
          Container(
            color: Colors.black.withOpacity(0.70),
          ),

          // 3. MENSAJE Y SPINNER DE SUSPENSO
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF38BDF8)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3338BDF8),
                      blurRadius: 25,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      _loadingText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Evaluando tus reacciones ante desinformación, IA y redes sociales...',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================================================================
// PANTALLA DE RESULTADOS Y RECOMENDACIONES MIL
// ==============================================================================
class ResultScreen extends StatelessWidget {
  final String profile;
  final int scoreV;
  final int scoreE;
  final int scoreA;
  final int scoreC;

  const ResultScreen({
    super.key,
    required this.profile,
    required this.scoreV,
    required this.scoreE,
    required this.scoreA,
    required this.scoreC,
  });

  Map<String, dynamic> _getProfileDetails() {
    switch (profile) {
      case 'Investigador/a':
        return {
          'icon': '🔎',
          'desc': 'Conseguiste este perfil por las decisiones que tomaste: en la mayoría de los momentos elegiste buscar la fuente, comparar información o confirmar antes de actuar con el rumor del agua, la agencia de viajes y el comunicado del sismo.',
          'recs': [
            'Comparte cómo verificaste a tu familia y amigos. Es una forma sencilla de transmitir el hábito a otras personas.',
            'Tener ya identificadas 2 o 3 cuentas de verificadores confiables en redes sociales o sitios web oficiales te ahorrará tiempo la próxima vez.'
          ]
        };
      case 'Empático/a Crítico/a':
        return {
          'icon': '💬',
          'desc': 'Verificaste antes de actuar y, además, tomaste en cuenta el impacto en otras personas — como al proteger a tu amiga frente a la imagen manipulada con IA, o al manejar con calma el rumor del tío.',
          'recs': [
            'Comunicar una corrección sin confrontar, explicando el porqué, suele ser más efectivo para que el mensaje realmente se escuche.',
            'En situaciones donde el daño potencial es alto, actuar con rapidez importa tanto como actuar con calma.',
            'Este estilo de comunicación sirve de modelo para otras personas.'
          ]
        };
      case 'Confirmador/a':
        return {
          'icon': '🪞',
          'desc': 'En general elegiste confirmar información antes de actuar, pero principalmente dentro de fuentes o personas cercanas (como la familia), sin buscar activamente otros ángulos.',
          'recs': [
            'Buscar de vez en cuando una fuente que piensa distinto sobre un tema amplía lo que "verificar" significa.',
            'Al confirmar algo con una segunda fuente, pregúntate si esa fuente es realmente independiente o si repite lo mismo.',
            'Revisar cómo está configurado tu feed te permite ver si estás viendo una versión limitada de la información.'
          ]
        };
      case 'Ingenuo/a Digital':
        return {
          'icon': '🤖',
          'desc': 'Frente a contenido manipulado con inteligencia artificial —como la imagen de tu amiga— o un comunicado falso, elegiste opciones que no cuestionaron su veracidad antes de actuar.',
          'recs': [
            'Conocer señales básicas de contenido manipulado (inconsistencias en bordes, luces, voces o situaciones irrealmente perfectas) ayuda a frenar a tiempo.',
            'Antes de reaccionar a una imagen impactante, pregúntate quién podría beneficiarse de que se crea real.',
            'Frente a un "comunicado oficial", busca si la institución lo confirma en su propio canal.'
          ]
        };
      case 'Amplificador/a':
        return {
          'icon': '🎭',
          'desc': 'En varios momentos elegiste compartir o reenviar contenido —como el meme con la imagen manipulada o el rumor del agua— sin verificarlo ni considerar el impacto que podía tener.',
          'recs': [
            'Antes de compartir algo que genera una reacción fuerte, hazte una pregunta simple: ¿qué tan seguro estoy de que esto es cierto?',
            'Decir que no a compartir contenido que afecta a otra persona evita un daño difícil de deshacer.',
            'Puedes usar el mismo alcance que tienes para aclarar o desmentir información de vez en cuando.'
          ]
        };
      default:
        return {
          'icon': '📢',
          'desc': 'En varios momentos —el mensaje del tío, los posts virales, la alerta del sismo— elegiste compartir o reaccionar antes de buscar más información.',
          'recs': [
            'Hacer una pausa breve (contar hasta 10) antes de compartir algo que generó una reacción emocional fuerte te da tiempo a decidir.',
            'Identificar la emoción que un contenido te provoca (miedo, indignación, euforia) sirve como señal para frenar.',
            'Antes de reenviar algo urgente, pregúntate: si esto fuera falso, ¿a quién le haría daño que yo lo comparta?'
          ]
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = _getProfileDetails();
    final List<String> recs = details['recs'];

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(details['icon'], style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 12),
                const Text('Tu Perfil Digital es:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 6),
                Text(
                  profile,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                ),
                const SizedBox(height: 20),
                Text(
                  details['desc'],
                  style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white10),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('💡 Recomendaciones para ti:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 12),
                ...recs.map((rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 18)),
                          Expanded(child: Text(rec, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4))),
                        ],
                      ),
                    )),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Volver al Menú Principal', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}