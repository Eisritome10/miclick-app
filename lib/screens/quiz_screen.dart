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
  final String? imagePlaceholder;
  final List<QuizOption> options;

  QuizScene({
    required this.time,
    required this.title,
    required this.description,
    this.imagePlaceholder,
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
      // 1. DESPERTAR [cite: 42-54]
      QuizScene(
        time: "8:03 a. m. - En la cama",
        title: "1. DESPERTAR - El mensaje del tío",
        description:
            "🚨 URGENTE: Se cortará el agua potable en toda la ciudad por tres días desde mañana. Difunde esta información.\n\n"
            "Tu celular no para de vibrar con este reenvío de WhatsApp. ¿Qué haces?",
        options: [
          QuizOption(text: "Reenviar a otros grupos para que todos se enteren.", e: 3), // [cite: 54]
          QuizOption(text: "Buscar en internet antes de reenviarlo.", v: 3), // [cite: 54]
          QuizOption(text: "Preguntarle al tío de dónde sacó esa información.", v: 2, c: 1), // [cite: 54]
          QuizOption(text: "Ignorar el mensaje y no hacer nada.", v: 1), // [cite: 54]
        ],
      ),

      // 2. DESAYUNO [cite: 55-57]
      QuizScene(
        time: "8:30 a. m. - En la cocina",
        title: "2. DESAYUNO - Conversación con mamá",
        description:
            "Mamá te dice: 'Buenos días. ¿Viste lo que envió tu tío sobre el agua?'\n"
            "¿Cómo le respondes a tu mamá?",
        options: [
          QuizOption(text: "Sí, ya se lo reenvié a todos mis amigos.", e: 2), // [cite: 57]
          QuizOption(text: "No investigué mucho, pero lo haré luego.", v: 2), // [cite: 57]
          QuizOption(text: "Mi tío exagera, no le hagas caso.", v: 1), // [cite: 57]
          QuizOption(text: "Le diré que verifique antes de enviar eso a otros.", v: 2, c: 2), // [cite: 57]
        ],
      ),

      // 3. REDES SOCIALES Y ALGORITMOS [cite: 61-64]
      QuizScene(
        time: "11:00 a. m. - En tu habitación",
        title: "3. REDES SOCIALES - Anuncio de audífonos",
        description:
            "Estuviste buscando audífonos para comprar en dos meses. Entras a tus redes sociales y de la nada te aparece una oferta 'imperdible' de audífonos de alta gama.\n\n"
            "¿Qué piensas o haces?",
        options: [
          QuizOption(text: "¡Aprovecharé esta oferta, lo compraré de una vez!", e: 2), // [cite: 64]
          QuizOption(text: "Seguro el algoritmo sabe perfectamente lo que necesito.", v: 1, e: 1, a: 1), // [cite: 64]
          QuizOption(text: "Quizá me aparecen porque estuve buscando audífonos previamente.", v: 1, a: 2, c: 1), // [cite: 64]
          QuizOption(text: "Voy a buscar qué precios y reseñas les salen a mis amigos.", v: 2, a: 2, c: 1), // [cite: 64]
        ],
      ),

      // 4. DEEPFAKE Y IA [cite: 69-76]
      QuizScene(
        time: "4:30 p. m. - Salida al cine",
        title: "4. CINE - La imagen editada con IA",
        description:
            "Tu amigo te muestra su celular riéndose: 'Oye, mira lo que hice con IA. Puse el rostro de Sara en la escena incómoda de la película'.\n"
            "Y agrega: 'Lo mandaré al grupo de WhatsApp, es un meme muy gracioso'.\n\n"
            "¿Cómo reaccionas?",
        options: [
          QuizOption(text: "¡Ja, ja! Envíalo al grupo.", e: 2), // [cite: 76]
          QuizOption(text: "No lo compartas, eso le puede incomodar bastante a Sara.", a: 2, c: 3), // [cite: 76]
          QuizOption(text: "Borra la imagen ahora mismo, no está bien hacer eso.", a: 2, c: 3), // [cite: 76]
          QuizOption(text: "No decir nada, pero tampoco compartirlo.", a: 1, c: 1), // [cite: 76]
        ],
      ),

      // 5. ESTAFAS Y PUBLICIDAD [cite: 78-82]
      QuizScene(
        time: "7:15 p. m. - De regreso en casa",
        title: "5. VIAJE FAMILIAR - Promoción dudosa",
        description:
            "Papá te dice: 'Queremos comprar los pasajes de bus/avión para el viaje familiar en esta página de Facebook que promete 50% de descuento. ¿Qué opinas?'\n"
            "Ves un anuncio con errores ortográficos y precios sospechosamente bajos.",
        options: [
          QuizOption(text: "Está bien, si está en redes seguro es confiable.", v: 0), // [cite: 82]
          QuizOption(text: "Busquemos reseñas y comentarios de otros usuarios antes de decidir.", v: 3), // [cite: 82]
          QuizOption(text: "Voy a revisar si la empresa tiene sitio web oficial registrado.", v: 3, a: 1), // [cite: 82]
          QuizOption(text: "Comparemos precios directamente con agencias reconocidas.", v: 2, c: 1), // [cite: 82]
        ],
      ),

      // 6. COMUNICADO OFICIAL Y SISMO [cite: 87-94]
      QuizScene(
        time: "11:45 p. m. - Antes de dormir",
        title: "6. NOCHE - La alerta de sismo",
        description:
            "Ocurre un temblor breve pero intenso. Revisas tu celular y ves un supuesto 'COMUNICADO OFICIAL':\n"
            "🚨 'Se espera una réplica de gran magnitud en los próximos minutos. Evacuar inmediatamente.'\n\n"
            "¿Qué hacen tú y tu familia?",
        options: [
          QuizOption(text: "Salir corriendo a la calle inmediatamente.", e: 3), // [cite: 94]
          QuizOption(text: "Verificar en la cuenta oficial del instituto sismológico.", v: 3), // [cite: 94]
          QuizOption(text: "Avisar a la familia con calma y verificar la fuente juntos.", v: 2, e: 1, c: 2), // [cite: 94]
          QuizOption(text: "Ignorarlo y volverse a dormir.", v: 0), // [cite: 94]
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

  // Algoritmo Oficial de Evaluación MIL 
  void _finishQuiz() {
    String profile = "Reactivo/a"; // Por defecto [cite: 117]

    // 1. Amplificador: C <= 4 Y E >= 9 [cite: 103]
    if (_scoreC <= 4 && _scoreE >= 9) {
      profile = "Amplificador/a";
    }
    // 2. Ingenuo Digital: A <= 1 [cite: 106]
    else if (_scoreA <= 1) {
      profile = "Ingenuo/a Digital";
    }
    // 3. Reactivo: E >= 9 Y V <= 7 [cite: 109]
    else if (_scoreE >= 9 && _scoreV <= 7) {
      profile = "Reactivo/a";
    }
    // 4. Confirmador: V >= 11 Y A <= 1 [cite: 111]
    else if (_scoreV >= 11 && _scoreA <= 1) {
      profile = "Confirmador/a";
    }
    // 5. Empático Crítico: V >= 11 Y C >= 7 Y E <= 6 [cite: 113]
    else if (_scoreV >= 11 && _scoreC >= 7 && _scoreE <= 6) {
      profile = "Empático/a Crítico/a";
    }
    // 6. Investigador: V >= 11 [cite: 115]
    else if (_scoreV >= 11) {
      profile = "Investigador/a";
    }

    // Guardar en Supabase en tiempo real
    SupabaseService.saveQuizResult(
      scoreV: _scoreV,
      scoreE: _scoreE,
      scoreA: _scoreA,
      scoreC: _scoreC,
      finalProfile: profile,
    );

    // Navegar a la pantalla de resultados
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

// Pantalla de Resultados y Diagnóstico MIL [cite: 118-160]
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
          'desc': 'En la mayoría de los momentos elegiste buscar la fuente, comparar información o confirmar antes de actuar. Este patrón de respuestas se asocia con el hábito de verificar antes de compartir.',
          'recs': [
            'Comparte cómo verificaste a tu familia y amigos. Es una forma sencilla de transmitir el hábito a otras personas.',
            'Tener ya identificadas 2 o 3 cuentas de verificadores confiables en redes sociales o sitios web oficiales ahorra tiempo.'
          ]
        };
      case 'Empático/a Crítico/a': // [cite: 140-146]
        return {
          'icon': '💬',
          'desc': 'Verificaste antes de actuar y, además, tomaste en cuenta el impacto en otras personas (como al proteger a tu amiga frente a la imagen manipulada con IA).',
          'recs': [
            'Comunicar una corrección sin confrontar, explicando el porqué, suele ser más efectivo.',
            'En situaciones donde el daño potencial es alto, actuar con rapidez importa tanto como actuar con calma.'
          ]
        };
      case 'Confirmador/a': // [cite: 133-139]
        return {
          'icon': '🪞',
          'desc': 'Elegiste confirmar información antes de actuar, pero principalmente dentro de fuentes o personas cercanas (como la familia), sin buscar activamente otros ángulos.',
          'recs': [
            'Buscar de vez en cuando una fuente que piensa distinto ayuda a ver el panorama completo.',
            'Pregúntate si tu segunda fuente es realmente independiente o repite lo mismo.'
          ]
        };
      case 'Ingenuo/a Digital': // [cite: 147-153]
        return {
          'icon': '🤖',
          'desc': 'Frente a contenido manipulado con IA o un comunicado falso, elegiste opciones que no cuestionaron su veracidad antes de actuar.',
          'recs': [
            'Conoce señales básicas de contenido manipulado (bordes raros, luces, voces irreales).',
            'Frente a un "comunicado oficial", busca si la institución lo confirma en su propio sitio web.'
          ]
        };
      case 'Amplificador/a': // [cite: 154-160]
        return {
          'icon': '🎭',
          'desc': 'En varios momentos elegiste compartir o reenviar contenido sin verificarlo ni considerar el impacto que podía tener.',
          'recs': [
            'Antes de compartir algo impulsivo, pregúntate: ¿qué tan seguro estoy de que esto es cierto?',
            'Decir que no a compartir contenido que afecta a otra persona evita un daño difícil de deshacer.'
          ]
        };
      default: // Reactivo/a [cite: 126-132]
        return {
          'icon': '📢',
          'desc': 'Elegiste compartir o reaccionar antes de buscar más información ante emociones fuertes.',
          'recs': [
            'Haz una pausa breve (cuenta hasta 10) antes de compartir algo que genere una emoción fuerte.',
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
                  style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
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
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 18)),
                          Expanded(child: Text(rec, style: const TextStyle(color: Colors.white70, fontSize: 14))),
                        ],
                      ),
                    )),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8)),
                    child: const Text('Volver al Menú Principal', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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