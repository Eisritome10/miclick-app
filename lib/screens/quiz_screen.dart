import 'package:flutter/material.dart';
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

class QuizScene {
  final String time;
  final String title;
  final String description;
  final List<QuizOption> options;

  QuizScene({
    required this.time,
    required this.title,
    required this.description,
    required this.options,
  });
}

class QuizScreen extends StatefulWidget {
  final String userName;
  const QuizScreen({super.key, required this.userName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentSceneIndex = 0;

  // Puntajes acumulados en los 4 Ejes MIL
  int _scoreV = 0;
  int _scoreE = 0;
  int _scoreA = 0;
  int _scoreC = 0;

  List<QuizScene> _getScenes() {
    return [
      // 1. DESPERTAR - El mensaje del tío [cite: 42-54]
      QuizScene(
        time: "8:03 a. m.",
        title: "1. DESPERTAR - El mensaje del tío",
        description:
            "Son las 8:03 a. m. y tu celular no para de vibrar.\n"
            "${widget.userName} piensa: 'Qué raro, ¿quién estará enviando tantos mensajes?'\n\n"
            "Es un mensaje de tu TÍO:\n"
            "🚨 URGENTE: Se cortará el agua potable en toda la ciudad por tres días desde mañana. Difunde esta información.\n\n"
            "¿Cómo reaccionas?",
        options: [
          QuizOption(text: "Reenviar a otros grupos para que otros se enteren.", e: 3),
          QuizOption(text: "Buscar en internet antes de reenviarlo.", v: 3),
          QuizOption(text: "Preguntarle al tío de dónde sacó la información.", v: 2, c: 1),
          QuizOption(text: "Ignorar el mensaje.", v: 1),
        ],
      ),

      // 2. EN LA COCINA - Conversación con Mamá [cite: 55-57]
      QuizScene(
        time: "8:20 a. m.",
        title: "2. DESAYUNO - La conversación con Mamá",
        description:
            "Te diriges a la cocina.\n"
            "Mamá te dice: 'Buenos días, ${widget.userName}. ¿Viste lo que envió tu tío sobre el agua?'\n\n"
            "¿Qué le respondes a tu mamá?",
        options: [
          QuizOption(text: "Sí, ya se lo reenvié a todos.", e: 2),
          QuizOption(text: "No investigué mucho, pero lo haré luego.", v: 2),
          QuizOption(text: "Mi tío exagera, no le hagas caso.", v: 1),
          QuizOption(text: "Le diré que investigue antes de enviar eso a otros.", v: 2, c: 2),
        ],
      ),

      // 3. REDES SOCIALES - Oferta de Audífonos [cite: 60-64]
      QuizScene(
        time: "11:00 a. m.",
        title: "3. REDES SOCIALES - La oferta de audífonos",
        description:
            "Estás ahorrando para comprar unos audífonos nuevos. Viste dos videos de reseñas y entraste a una tienda en línea.\n"
            "Al abrir tus redes sociales, te aparece un post promocional de audífonos.\n\n"
            "¿Qué piensas o decides hacer?",
        options: [
          QuizOption(text: "¡Aprovecharé esta oferta, lo compraré de una vez!", e: 2),
          QuizOption(text: "Seguro el algoritmo sabe que los necesito.", v: 1, e: 1, a: 1),
          QuizOption(text: "Quizá me aparecen porque estuve buscando audífonos.", v: 1, a: 2, c: 1),
          QuizOption(text: "Voy a buscar qué precios y reseñas les salen a mis amigos.", v: 2, a: 2, c: 1),
        ],
      ),

      // 4. EL CINE Y EL DEEPFAKE - Imagen de Sara con IA [cite: 70-76]
      QuizScene(
        time: "4:30 p. m.",
        title: "4. CINE - La imagen editada con IA",
        description:
            "Estás en el cine con tus amigos. Tu amiga Sara va al baño un momento.\n"
            "Tu amigo se acerca y te muestra su celular: 'Oye, mira lo que hice. Es Sara con el actor de la película, la modifiqué con IA'.\n"
            "Su rostro está en una escena incómoda y tu amigo agrega: 'Lo mandaré al grupo, es un meme muy gracioso'.\n\n"
            "¿Qué haces?",
        options: [
          QuizOption(text: "¡Ja, ja! Envíalo al grupo.", e: 2),
          QuizOption(text: "No lo compartas, eso le puede incomodar.", a: 2, c: 3),
          QuizOption(text: "Borra la imagen ahora, no está bien.", a: 2, c: 3),
          QuizOption(text: "No decir nada, pero tampoco compartirlo.", a: 1, c: 1),
        ],
      ),

      // 5. REGRESO A CASA - Oferta de Pasajes [cite: 78-82]
      QuizScene(
        time: "7:30 p. m.",
        title: "5. REGRESO A CASA - Agencia de viajes",
        description:
            "Llegas a casa y tu Papá te recibe:\n"
            "'Hola ${widget.userName}. Pensamos comprar los pasajes de bus para el viaje con esta agencia en Facebook que tiene 50% de descuento. ¿Qué opinas?'\n\n"
            "¿Cuál es tu sugerencia?",
        options: [
          QuizOption(text: "Está bien, seguro es confiable.", v: 0),
          QuizOption(text: "Busquemos reseñas antes de decidir.", v: 3),
          QuizOption(text: "Voy a revisar si tiene página oficial.", v: 3, a: 1),
          QuizOption(text: "Comparemos precios con otra agencia conocida.", v: 2, c: 1),
        ],
      ),

      // 6. NOCHE - Alerta de Sismo [cite: 87-94]
      QuizScene(
        time: "11:50 p. m.",
        title: "6. NOCHE - Falsa alerta de réplica",
        description:
            "Ocurre un temblor breve e intenso. Al revisar tu celular ves un mensaje:\n"
            "🚨 COMUNICADO OFICIAL: Se espera una réplica de gran magnitud durante los próximos minutos. Se recomienda evacuar inmediatamente.\n\n"
            "¿Qué decisión tomas?",
        options: [
          QuizOption(text: "Salir corriendo a la calle.", e: 3),
          QuizOption(text: "Verificar en la cuenta oficial de sismos.", v: 3),
          QuizOption(text: "Avisar a la familia y verificar juntos.", v: 2, e: 1, c: 2),
          QuizOption(text: "Ignorarlo, ya pasó bastante hoy.", v: 0),
        ],
      ),
    ];
  }

  void _onOptionSelected(QuizOption option) {
    setState(() {
      _scoreV += option.v;
      _scoreE += option.e;
      _scoreA += option.a;
      _scoreC += option.c;

      final scenes = _getScenes();
      if (_currentSceneIndex < scenes.length - 1) {
        _currentSceneIndex++;
      } else {
        _finishQuiz();
      }
    });
  }

  // Algoritmo de Evaluación de Perfiles (Ponderación UNESCO) 
  void _finishQuiz() {
    String profile = "Reactivo/a"; // Fallback por defecto [cite: 117]

    // Rule 1: Amplificador (C <= 4 Y E >= 9) [cite: 103]
    if (_scoreC <= 4 && _scoreE >= 9) {
      profile = "Amplificador/a";
    }
    // Rule 2: Ingenuo Digital (A <= 1) [cite: 106]
    else if (_scoreA <= 1) {
      profile = "Ingenuo/a Digital";
    }
    // Rule 3: Reactivo (E >= 9 Y V <= 7) [cite: 109]
    else if (_scoreE >= 9 && _scoreV <= 7) {
      profile = "Reactivo/a";
    }
    // Rule 4: Confirmador (V >= 11 Y A <= 1) [cite: 111]
    else if (_scoreV >= 11 && _scoreA <= 1) {
      profile = "Confirmador/a";
    }
    // Rule 5: Empático Crítico (V >= 11 Y C >= 7 Y E <= 6) [cite: 113]
    else if (_scoreV >= 11 && _scoreC >= 7 && _scoreE <= 6) {
      profile = "Empático/a Crítico/a";
    }
    // Rule 6: Investigador (V >= 11) [cite: 115]
    else if (_scoreV >= 11) {
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

    // Navegación a Pantalla de Resultados
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
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
    final scenes = _getScenes();
    final currentScene = scenes[_currentSceneIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Escena ${_currentSceneIndex + 1} de ${scenes.length}'),
        backgroundColor: const Color(0xFF1E293B),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentSceneIndex + 1) / scenes.length,
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
                      currentScene.time,
                      style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  currentScene.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                    currentScene.description,
                    style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  '¿Qué decisión tomas?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ...currentScene.options.map((option) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Pantalla de Resultados y Recomendaciones MIL [cite: 118-160]
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
      case 'Investigador/a': // [cite: 118-124]
        return {
          'icon': '🔎',
          'desc': 'Conseguiste este perfil por las decisiones del juego: en la mayoría de los momentos elegiste buscar la fuente, comparar información o confirmar antes de actuar con el rumor del agua, la agencia de viaje y el comunicado del sismo.',
          'recs': [
            'Comparte cómo verificaste a tu familia y amigos. Es una forma sencilla de transmitir el hábito a otras personas.',
            'Tener ya identificadas 2 o 3 cuentas de verificadores confiables en redes sociales o sitios web oficiales ahorra tiempo la próxima vez que necesites confirmar algo rápido.'
          ]
        };
      case 'Empático/a Crítico/a': // [cite: 140-146]
        return {
          'icon': '💬',
          'desc': 'Verificaste antes de actuar y, además, tomaste en cuenta el impacto en otras personas — como al proteger a la amiga frente a la imagen manipulada con IA, o al manejar con calma el rumor del tío y la alerta del sismo.',
          'recs': [
            'Comunicar una corrección sin confrontar, explicando el porqué, suele ser más efectivo para que el mensaje realmente se escuche.',
            'En situaciones donde el daño potencial es alto, actuar con rapidez importa tanto como actuar con calma.',
            'Este estilo de comunicación puede servir de modelo para otras personas.'
          ]
        };
      case 'Confirmador/a': // [cite: 133-139]
        return {
          'icon': '🪞',
          'desc': 'En general elegiste confirmar información antes de actuar, pero principalmente dentro de fuentes o personas cercanas (como la familia), sin buscar activamente otros ángulos.',
          'recs': [
            'Buscar de vez en cuando una fuente que se sabe piensa distinto sobre un tema amplía lo que "verificar" significa.',
            'Al confirmar algo con una segunda fuente, pregúntate si esa fuente es realmente independiente o si repite lo mismo.',
            'Revisar cómo está configurado el feed te permite ver si estás viendo una versión limitada de la información.'
          ]
        };
      case 'Ingenuo/a Digital': // [cite: 147-153]
        return {
          'icon': '🤖',
          'desc': 'Frente a contenido manipulado con inteligencia artificial —como la imagen de la amiga— o un comunicado presentado como oficial, elegiste opciones que no cuestionaron su veracidad antes de actuar.',
          'recs': [
            'Conocer señales básicas de contenido manipulado (inconsistencias en bordes, luces, voces, o situaciones demasiado perfectas) ayuda a generar una pausa.',
            'Antes de reaccionar a una imagen o video impactante, pregúntate quién podría beneficiarse de que se crea real.',
            'Frente a un "comunicado oficial", busca si la institución lo confirma en su propio canal.'
          ]
        };
      case 'Amplificador/a': // [cite: 154-160]
        return {
          'icon': '🎭',
          'desc': 'En varios momentos elegiste compartir o reenviar contenido —como el meme con la imagen manipulada o el rumor del agua— sin verificarlo ni considerar el impacto que podía tener.',
          'recs': [
            'Antes de compartir algo que genera una reacción fuerte, una pregunta simple: ¿qué tan seguro estoy de que esto es cierto? puede cambiar la decisión.',
            'Decir que no a compartir contenido que afecta a otra persona evita un daño que después es difícil deshacer.',
            'Puedes usar el mismo alcance que tienes para aclarar o desmentir información de vez en cuando.'
          ]
        };
      default: // Reactivo/a [cite: 126-132]
        return {
          'icon': '📢',
          'desc': 'En varios momentos —el mensaje del tío, los posts virales, la alerta del sismo— elegiste compartir o reaccionar antes de buscar más información.',
          'recs': [
            'Una pausa breve (contar hasta 10, por ejemplo) antes de compartir algo que generó una reacción emocional fuerte da tiempo a decidir.',
            'Identificar la emoción que un contenido te provoca (miedo, indignación, euforia) sirve como señal para frenar.',
            'Antes de reenviar algo presentado como urgente, pregúntate: si esto fuera falso, ¿a quién le haría daño que yo lo comparta?'
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