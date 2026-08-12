import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/supabase_service.dart';

class QuizOption {
  final String text;
  final int v;
  final int e;
  final int a;
  final int c;

  QuizOption({
    required this.text,
    this.v = 0,
    this.e = 0,
    this.a = 0,
    this.c = 0,
  });
}

class SceneStep {
  final String time;
  final String title;
  final String description;
  final String imagePath;
  final String? characterDialog;
  final List<QuizOption>? options;

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
  final String language;

  const QuizScreen({
    super.key,
    required this.userName,
    this.language = 'en',
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentStepIndex = 0;

  int _scoreV = 0;
  int _scoreE = 0;
  int _scoreA = 0;
  int _scoreC = 0;

  List<SceneStep> _getSteps() {
    final isEn = widget.language == 'en';
    final name = widget.userName;

    return [
      // ESCENA 1
      SceneStep(
        time: isEn ? "8:00 AM" : "8:00 a. m.",
        title: isEn ? "1. WAKING UP - Opening your eyes" : "1. DESPERTAR - Abriendo los ojos",
        imagePath: "assets/images/escena1_ojos_cerrados.jpeg",
        description: isEn
            ? "You slowly open your eyes. Sunlight enters through your window and you feel your phone constantly vibrating on the nightstand."
            : "Abres los ojos lentamente. La luz del sol entra por tu ventana y sientes la vibración constante de tu celular en la mesa de noche.",
      ),
      SceneStep(
        time: isEn ? "8:01 AM" : "8:01 a. m.",
        title: isEn ? "1. WAKING UP - Bedroom" : "1. DESPERTAR - Habitación",
        imagePath: "assets/images/escena1_despierto.jpeg",
        description: isEn
            ? "You get out of bed rubbing your eyes. The phone keeps ringing. You think: 'Strange... who is sending so many messages at this hour?'"
            : "Te levantas de la cama frotándote los ojos. El celular no deja de sonar. Piensas: 'Qué raro... ¿quién estará enviando tantos mensajes a esta hora?'",
      ),
      SceneStep(
        time: isEn ? "8:03 AM" : "8:03 a. m.",
        title: isEn ? "1. WAKING UP - Message from Uncle" : "1. DESPERTAR - Mensaje del Tío",
        imagePath: "assets/images/escena1_mensaje_tio.jpeg",
        description: isEn
            ? "You pick up your phone and see a screenshot sent by your uncle to the whole family warning about a alleged drinking water outage."
            : "Tomas tu celular y ves una captura enviada por tu tío a toda la familia alertando sobre un supuesto corte de agua potable.",
        options: [
          QuizOption(
            text: isEn
                ? "Forward the image to other groups immediately so everyone is warned."
                : "Reenviar la imagen a otros grupos de inmediato para que todos estén precavidos.",
            e: 3,
          ),
          QuizOption(
            text: isEn
                ? "Search online if authorities confirmed the water outage before sending anything."
                : "Buscar en internet si las autoridades confirmaron el corte de agua antes de enviar nada.",
            v: 3,
            a: 1,
            c: 1,
          ),
          QuizOption(
            text: isEn
                ? "Text my uncle privately to ask where he got that screenshot."
                : "Escribirle a mi tío por privado para preguntarle de dónde sacó esa imagen.",
            v: 2,
            c: 2,
          ),
          QuizOption(
            text: isEn
                ? "Ignore the notification and put the phone aside."
                : "Ignorar la notificación y dejar el celular a un lado.",
            v: 1,
          ),
        ],
      ),

      // ESCENA 2
      SceneStep(
        time: isEn ? "8:20 AM" : "8:20 a. m.",
        title: isEn ? "2. BREAKFAST - The Kitchen" : "2. DESAYUNO - La Cocina",
        imagePath: "assets/images/escena2_cocina.jpeg",
        description: isEn
            ? "You head to the kitchen to make breakfast and run into your mom."
            : "Te diriges a la cocina a preparar el desayuno y te encuentras con tu mamá.",
      ),
      SceneStep(
        time: isEn ? "8:22 AM" : "8:22 a. m.",
        title: isEn ? "2. BREAKFAST - Conversation with Mom" : "2. DESAYUNO - Conversación con Mamá",
        imagePath: "assets/images/escena2_mama_hablando.jpeg",
        characterDialog: isEn
            ? 'Mom: "Good morning, $name. Did you see the urgent alert your uncle sent about the water?"'
            : 'Mamá: "Buenos días, $name. ¿Viste la alerta urgente que envió tu tío sobre el agua?"',
        description: isEn
            ? "Your mom looks at you worriedly, waiting for your answer."
            : "Tu mamá te mira preocupada esperando tu respuesta.",
        options: [
          QuizOption(
            text: isEn
                ? "Yes mom, I already forwarded it to all my contacts just in case."
                : "Sí mamá, ya se lo reenvié a todos mis contactos por si acaso.",
            e: 3,
          ),
          QuizOption(
            text: isEn
                ? "I haven't investigated much yet, but I'll check in a moment."
                : "No investigué mucho aún, pero lo revisaré en un momento.",
            v: 2,
            e: 1,
          ),
          QuizOption(
            text: isEn
                ? "My uncle always believes everything he sees, don't pay attention to him."
                : "Mi tío siempre se cree todo lo que ve, no le hagas caso.",
            v: 1,
            e: 1,
          ),
          QuizOption(
            text: isEn
                ? "I suggest checking official sources before sending it to her friends."
                : "Le sugiero que verifique en fuentes oficiales antes de enviárselo a sus amigas.",
            v: 3,
            c: 3,
            a: 1,
          ),
        ],
      ),
      SceneStep(
        time: isEn ? "8:30 AM" : "8:30 a. m.",
        title: isEn ? "2. BREAKFAST - The Kitchen" : "2. DESAYUNO - La Cocina",
        imagePath: "assets/images/escena2_cocina2.jpeg",
        description: isEn
            ? "You talk with your mom and she thanks you for your advice."
            : "Dialogas con tu mamá y ella te agradece por tu recomendación.",
        characterDialog: isEn
            ? 'Mom: "Thanks for your advice, $name. Now I\'ll finish my tasks since we are planning a trip with dad. You\'re going to the movies with friends today, right? Enjoy!"'
            : 'Mamá: "Gracias por tu consejo, $name. Ahora iré a terminar con mis pendientes, ya que estamos planeando un viaje con papá. Hoy saldrás al cine con tus amigos, ¿verdad? ¡Que disfrutes!"',
      ),

      // ESCENA 3
      SceneStep(
        time: isEn ? "11:00 AM" : "11:00 a. m.",
        title: isEn ? "3. SOCIAL MEDIA - Ad in your Feed" : "3. REDES SOCIALES - Oferta en tu Feed",
        imagePath: "assets/images/escena3_oferta_audifonos.jpeg",
        description: isEn
            ? "You are saving up to buy headphones. After searching for reviews a few days ago, you open social media and see a featured deal."
            : "Estás ahorrando para comprar unos audífonos. Luego de buscar reseñas hace unos días, abres tus redes sociales y ves una oferta destacada.",
      ),
      SceneStep(
        time: isEn ? "11:05 AM" : "11:05 a. m.",
        title: isEn ? "3. SOCIAL MEDIA - Comparing Reviews" : "3. REDES SOCIALES - Comparando Reseñas",
        imagePath: "assets/images/escena3_resenas_audifonos.jpeg",
        description: isEn
            ? "You scroll and see two different posts with opinions on different headphone brands."
            : "Deslizas la pantalla y te aparecen dos publicaciones distintas con opiniones sobre diferentes marcas de audífonos.",
        options: [
          QuizOption(
            text: isEn
                ? "I'll take advantage of this deal and buy them right away!"
                : "¡Aprovecharé esta oferta y los compraré de una vez!",
            e: 3,
          ),
          QuizOption(
            text: isEn
                ? "I feel like the algorithm knows exactly what I need to buy."
                : "Siento que el algoritmo sabe exactamente lo que necesito comprar.",
            v: 1,
            e: 2,
            a: 1,
          ),
          QuizOption(
            text: isEn
                ? "I guess they appear because I was searching for headphones earlier."
                : "Imagino que me aparecen porque estuve buscando audífonos previamente.",
            v: 2,
            a: 3,
            c: 1,
          ),
          QuizOption(
            text: isEn
                ? "I'll compare what prices and reviews my friends get."
                : "Voy a comparar qué precios y reseñas les aparecen a mis amigos.",
            v: 3,
            a: 2,
            c: 2,
          ),
        ],
      ),
      SceneStep(
        time: isEn ? "11:15 AM" : "11:15 a. m.",
        title: isEn ? "3. SOCIAL MEDIA - Outing Reminder" : "3. REDES SOCIALES - Recordatorio de Salida",
        imagePath: "assets/images/escena3_oferta_cine.jpeg",
        description: isEn
            ? "You keep scrolling and come across a 3x2 cinema ticket promo. You remember you agreed to go to the movies with friends today."
            : "Sigues deslizando la red social y te cruzas con un anuncio de promoción 3x2 en el cine. Recuerdas que hoy quedaste en ir al cine con tus amigos.",
      ),

      // ESCENA 4
      SceneStep(
        time: isEn ? "4:30 PM" : "4:30 p. m.",
        title: isEn ? "4. CINEMA - Outing with friends" : "4. CINE - Salida con amigos",
        imagePath: "assets/images/escena4_cine.jpeg",
        description: isEn
            ? "You arrive at the cinema and meet your group. While Sara goes to the restroom, your friend calls you laughing with his phone in hand."
            : "Llegas al cine y te encuentras con tu grupo. Mientras Sara va al baño un momento, tu amigo te llama riéndose con el celular en la mano.",
      ),
      SceneStep(
        time: isEn ? "4:35 PM" : "4:35 p. m.",
        title: isEn ? "4. CINEMA - AI Edit Image" : "4. CINE - La imagen editada con IA",
        imagePath: "assets/images/escena4_deepfake.jpeg",
        description: isEn
            ? "Your friend shows you a photo where he used Artificial Intelligence to alter Sara's face into a movie scene."
            : "Tu amigo te muestra una foto donde usó Inteligencia Artificial para alterar el rostro de Sara en una escena comprometedora de la película.",
        characterDialog: isEn
            ? 'Friend: "Hey, $name, look what I did with AI! I\'ll send it to the group chat, it\'s a hilarious meme."'
            : 'Amigo: "Oye, $name, ¡mira lo que hice con IA! La mandaré al chat grupal, es un meme muy gracioso."',
        options: [
          QuizOption(
            text: isEn
                ? "Ha ha! Send it to the group right away so we all laugh."
                : "¡Ja, ja! Envíalo al grupo de una vez para reírnos todos.",
            e: 3,
          ),
          QuizOption(
            text: isEn
                ? "Don't do it, that will make Sara really uncomfortable."
                : "No lo hagas, eso le va a incomodar bastante a Sara.",
            a: 2,
            c: 3,
          ),
          QuizOption(
            text: isEn
                ? "Delete that image, it's not right to use her face like that."
                : "Borra esa imagen, no está bien usar su rostro así.",
            a: 3,
            c: 3,
            v: 1,
          ),
          QuizOption(
            text: isEn
                ? "I'll completely ignore that image as if I never saw it."
                : "Ignoraré esa imagen por completo como si nunca lo hubiera visto.",
            a: 1,
            c: 1,
          ),
        ],
      ),

      // ESCENA 5
      SceneStep(
        time: isEn ? "7:30 PM" : "7:30 p. m.",
        title: isEn ? "5. RETURNING HOME - Dad's Proposal" : "5. REGRESO A CASA - La propuesta de Papá",
        imagePath: "assets/images/escena5_papa.jpeg",
        description: isEn
            ? "You return home at night. Your dad welcomes you somewhat concerned."
            : "Regresas a casa de noche. Tu papá te recibe algo preocupado.",
      ),
      SceneStep(
        time: isEn ? "7:35 PM" : "7:35 p. m.",
        title: isEn ? "5. RETURNING HOME - Suspicious Tickets" : "5. REGRESO A CASA - Pasajes sospechosos",
        imagePath: "assets/images/escena5_oferta_viaje.jpeg",
        description: isEn
            ? "He shows you a post he found on social media with bus tickets at a 30% discount. You notice spelling mistakes in the image."
            : "Te muestra una publicación que encontró en las redes sociales con pasajes de bus al 30% de descuento. Notas fallas ortográficas en la imagen.",
        characterDialog: isEn
            ? 'Dad: "Hi $name, look at this deal for the family trip. Should I buy the tickets here right now?"'
            : 'Papá: "Hola $name, mira esta oferta para el viaje familiar. ¿Compro los pasajes aquí de una vez?"',
        options: [
          QuizOption(
            text: isEn
                ? "Sounds good dad, if it's on social media it's probably a real agency."
                : "Me parece bien papá, si está en redes sociales seguro es una agencia real.",
            e: 2,
          ),
          QuizOption(
            text: isEn
                ? "We should check reviews and complaints from other users before paying."
                : "Hay que buscar opiniones y reclamos de otros usuarios en las redes antes de pagar.",
            v: 3,
            a: 1,
            c: 1,
          ),
          QuizOption(
            text: isEn
                ? "I'll check if the company has an official website or registered business ID."
                : "Voy a revisar si la empresa tiene un sitio web oficial o RUC registrado.",
            v: 3,
            a: 3,
            c: 1,
          ),
          QuizOption(
            text: isEn
                ? "Let's compare prices directly with well-known transport agencies."
                : "Comparemos los precios directamente en las agencias de transporte conocidas.",
            v: 2,
            c: 2,
            a: 1,
          ),
        ],
      ),

      // ESCENA 6
      SceneStep(
        time: isEn ? "11:45 PM" : "11:45 p. m.",
        title: isEn ? "6. NIGHT - The Earthquake" : "6. NOCHE - El temblor",
        imagePath: "assets/images/escena6_temblor.jpeg",
        description: isEn
            ? "You are about to sleep when you feel the bed shake strongly for several seconds."
            : "Estás a punto de dormir cuando sientes que la cama tiembla fuertemente durante varios segundos.",
      ),
      SceneStep(
        time: isEn ? "11:46 PM" : "11:46 p. m.",
        title: isEn ? "6. NIGHT - The Aftershock Scare" : "6. NOCHE - El susto",
        imagePath: "assets/images/escena6_temblor2.jpeg",
        description: isEn
            ? "The shaking gradually slows down. Your phone keeps vibrating with notification messages."
            : "El temblor disminuye poco a poco. Tu celular sigue vibrando con notificaciones de mensajes y redes sociales.",
      ),
      SceneStep(
        time: isEn ? "11:50 PM" : "11:50 p. m.",
        title: isEn ? "6. NIGHT - Fake Aftershock Alert" : "6. NOCHE - Falsa Alerta de Réplica",
        imagePath: "assets/images/escena6_alerta_sismo.jpeg",
        description: isEn
            ? "You pick up your phone out of fear and see an image circulating with a state agency logo about an imminent aftershock."
            : "Tomas tu teléfono por susto y ves una imagen circulando en redes con el logo de un organismo estatal sobre una réplica inminente.",
        options: [
          QuizOption(
            text: isEn
                ? "I run out into the street immediately without hesitation."
                : "Salgo corriendo a la calle inmediatamente sin dudarlo.",
            e: 3,
          ),
          QuizOption(
            text: isEn
                ? "I check the verified official account of the seismological institute."
                : "Verifico en la cuenta oficial verificada del instituto sismológico.",
            v: 3,
            a: 1,
            c: 1,
          ),
          QuizOption(
            text: isEn
                ? "I calmly alert my family to check if the announcement is official."
                : "Aviso a mi familia con calma para revisar si el comunicado es oficial.",
            v: 2,
            c: 3,
            e: 1,
            a: 1,
          ),
          QuizOption(
            text: isEn
                ? "I completely ignore it and try to go back to sleep."
                : "Lo ignoro por completo y trato de volver a dormir.",
          ),
        ],
      ),
      SceneStep(
        time: isEn ? "12:00 AM" : "12:00 a. m.",
        title: isEn ? "END OF THE DAY - Time to Rest" : "FIN DEL DÍA - A descansar",
        imagePath: "assets/images/escena6_temblor3.jpeg",
        description: isEn
            ? "A lot happened and you're tired. You decide to turn off your phone and rest for the next day."
            : "Pasaron muchas cosas y estás cansado. Decides apagar el celular y descansar para el día siguiente.",
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

    if (_scoreC <= 4 && _scoreE >= 12) {
      profile = "Amplificador/a";
    } else if (_scoreA <= 2) {
      profile = "Ingenuo/a Digital";
    } else if (_scoreE >= 12 && _scoreV <= 9) {
      profile = "Reactivo/a";
    } else if (_scoreV >= 12 && _scoreA <= 2) {
      profile = "Confirmador/a";
    } else if (_scoreV >= 12 && _scoreC >= 10 && _scoreE <= 8) {
      profile = "Empático/a Crítico/a";
    } else if (_scoreV >= 12) {
      profile = "Investigador/a";
    }

    SupabaseService.saveQuizResult(
      scoreV: _scoreV,
      scoreE: _scoreE,
      scoreA: _scoreA,
      scoreC: _scoreC,
      finalProfile: profile,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyzingScreen(
          profile: profile,
          scoreV: _scoreV,
          scoreE: _scoreE,
          scoreA: _scoreA,
          scoreC: _scoreC,
          language: widget.language,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();
    final currentStep = steps[_currentStepIndex];
    final bool hasOptions = currentStep.options != null && currentStep.options!.isNotEmpty;
    final isEn = widget.language == 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEn
              ? 'Step ${_currentStepIndex + 1} of ${steps.length}'
              : 'Paso ${_currentStepIndex + 1} de ${steps.length}',
        ),
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
                if (hasOptions) ...[
                  Text(
                    isEn ? 'What decision will you make?' : '¿Qué decisión vas a tomar?',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _nextStep,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        isEn ? 'Continue' : 'Continuar',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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

// PANTALLA INTERMEDIA DE CARGA / ANÁLISIS DE RESULTADOS
class AnalyzingScreen extends StatefulWidget {
  final String profile;
  final int scoreV;
  final int scoreE;
  final int scoreA;
  final int scoreC;
  final String language;

  const AnalyzingScreen({
    super.key,
    required this.profile,
    required this.scoreV,
    required this.scoreE,
    required this.scoreA,
    required this.scoreC,
    this.language = 'en',
  });

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  late VideoPlayerController _videoController;
  late String _loadingText;

  @override
  void initState() {
    super.initState();
    final isEn = widget.language == 'en';
    _loadingText = isEn ? "Analyzing decisions..." : "Analizando decisiones...";

    _videoController = VideoPlayerController.asset('assets/videos/menu_bg.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _loadingText = isEn ? "Calculating today's profile..." : "Calculando el perfil de hoy...";
        });
      }
    });

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
              language: widget.language,
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
    final isEn = widget.language == 'en';

    return Scaffold(
      body: Stack(
        children: [
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

          Container(color: Colors.black.withOpacity(0.70)),

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
                    Text(
                      isEn
                          ? 'Evaluating your reactions to misinformation, AI, and social media...'
                          : 'Evaluando tus reacciones ante desinformación, IA y redes sociales...',
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
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

// PANTALLA DE RESULTADOS
class ResultScreen extends StatelessWidget {
  final String profile;
  final int scoreV;
  final int scoreE;
  final int scoreA;
  final int scoreC;
  final String language;

  const ResultScreen({
    super.key,
    required this.profile,
    required this.scoreV,
    required this.scoreE,
    required this.scoreA,
    required this.scoreC,
    this.language = 'en',
  });

  Map<String, dynamic> _getProfileDetails() {
    final isEn = language == 'en';

    switch (profile) {
      case 'Investigador/a':
        return {
          'icon': '🔎',
          'title': isEn ? 'The Researcher' : 'Investigador/a',
          'desc': isEn
              ? 'You achieved this profile due to your choices: in most situations, you chose to check sources, compare information, or confirm before acting.'
              : 'Conseguiste este perfil por las decisiones que tomaste: en la mayoría de los momentos elegiste buscar la fuente, comparar información o confirmar antes de actuar.',
          'recs': isEn
              ? [
                  'Share how you verified information with friends and family.',
                  'Identify 2 or 3 trusted fact-checking channels on social media or official websites.'
                ]
              : [
                  'Comparte cómo verificaste a tu familia y amigos. Es una forma sencilla de transmitir el hábito.',
                  'Tener identificadas 2 o 3 cuentas de verificadores confiables ahorra tiempo.'
                ]
        };
      case 'Empático/a Crítico/a':
        return {
          'icon': '💬',
          'title': isEn ? 'The Critical Empath' : 'Empático/a Crítico/a',
          'desc': isEn
              ? 'You verified information before acting and also considered the impact on others, protecting privacy and encouraging respectful communication.'
              : 'Verificaste antes de actuar y, además, tomaste en cuenta el impacto en otras personas, protegiendo la privacidad y promoviendo el respeto.',
          'recs': isEn
              ? [
                  'Communicating corrections without confrontation is more effective.',
                  'In high-risk potential damage situations, acting quickly matters as much as staying calm.',
                  'Your communication style can serve as a role model for others.'
                ]
              : [
                  'Comunicar una corrección sin confrontar suele ser más efectivo.',
                  'En situaciones de alto riesgo, actuar con rapidez importa tanto como actuar con calma.',
                  'Este estilo de comunicación sirve de modelo para otras personas.'
                ]
        };
      case 'Confirmador/a':
        return {
          'icon': '🪞',
          'title': isEn ? 'The Confirmator' : 'Confirmador/a',
          'desc': isEn
              ? 'You generally chose to confirm information before acting, but mainly within close sources or family circles without checking broader angles.'
              : 'En general elegiste confirmar información antes de actuar, pero principalmente dentro de fuentes o personas cercanas, sin buscar otros ángulos.',
          'recs': isEn
              ? [
                  'Checking sources with different perspectives broadens what "verification" means.',
                  'Ask yourself if a second source is truly independent or just repeating the same text.',
                  'Review your social feed configuration to avoid filter bubbles.'
                ]
              : [
                  'Buscar fuentes que piensan distinto amplía lo que "verificar" significa.',
                  'Pregúntate si esa segunda fuente es realmente independiente.',
                  'Revisa cómo está configurado tu feed para evitar cámaras de eco.'
                ]
        };
      case 'Ingenuo/a Digital':
        return {
          'icon': '🤖',
          'title': isEn ? 'The Digital Naïve' : 'Ingenuo/a Digital',
          'desc': isEn
              ? 'Faced with AI-manipulated content or unverified emergency posts, you selected options that did not question their authenticity before acting.'
              : 'Frente a contenido manipulado con IA o comunicados falsos, elegiste opciones que no cuestionaron su veracidad antes de actuar.',
          'recs': isEn
              ? [
                  'Learn basic signs of manipulated content (inconsistencies in borders, lights, voices).',
                  'Before reacting to an impactful image or video, ask who benefits if people believe it.',
                  'Check if institutions confirm official posts on their own channels.'
                ]
              : [
                  'Conocer señales básicas de contenido manipulado ayuda a frenar a tiempo.',
                  'Pregúntate quién podría beneficiarse de que creas que algo es real.',
                  'Busca si la institución confirma el comunicado en su canal oficial.'
                ]
        };
      case 'Amplificador/a':
        return {
          'icon': '🎭',
          'title': isEn ? 'The Amplifier' : 'Amplificador/a',
          'desc': isEn
              ? 'In several moments you chose to share or forward content without verifying or considering the negative impact it could cause.'
              : 'En varios momentos elegiste compartir o reenviar contenido sin verificarlo ni considerar el impacto negativo que podía tener.',
          'recs': isEn
              ? [
                  'Before sharing something that triggers strong emotions, ask: How sure am I that this is true?',
                  'Refusing to share content that affects someone avoids harm that is hard to undo.',
                  'Use your reach to clarify or debunk misinformation from time to time.'
                ]
              : [
                  'Antes de compartir algo emocionante, pregúntate: ¿Qué tan seguro estoy de que esto es cierto?',
                  'Evita compartir contenido que afecta a otra persona para prevenir daños.',
                  'Puedes usar tu alcance para aclarar o desmentir información de vez en cuando.'
                ]
        };
      default:
        return {
          'icon': '📢',
          'title': isEn ? 'The Reactive' : 'Reactivo/a',
          'desc': isEn
              ? 'In several moments you chose to share or react before seeking more context or fact-checking.'
              : 'En varios momentos elegiste compartir o reaccionar antes de buscar más información.',
          'recs': isEn
              ? [
                  'Take a short pause before sharing content that generates a strong emotional reaction.',
                  'Identify the emotion a post triggers in you (fear, anger, excitement) as a signal to slow down.',
                  'Ask yourself: If this were false, who would be harmed if I share it?'
                ]
              : [
                  'Haz una pausa breve antes de compartir algo que causó una reacción emocional fuerte.',
                  'Identifica la emoción que el contenido te provoca como señal para frenar.',
                  'Pregúntate: si esto fuera falso, ¿a quién le haría daño que yo lo comparta?'
                ]
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = _getProfileDetails();
    final List<String> recs = details['recs'];
    final isEn = language == 'en';

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
                Text(
                  isEn ? 'Your Digital Profile is:' : 'Tu Perfil Digital es:',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  details['title'],
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isEn ? '💡 Recommendations for you:' : '💡 Recomendaciones para ti:',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
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
                    child: Text(
                      isEn ? 'Back to Main Menu' : 'Volver al Menú Principal',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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