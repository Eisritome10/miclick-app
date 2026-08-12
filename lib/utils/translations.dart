class AppTranslations {
  static Map<String, Map<String, String>> getTextMap(String userName) {
    return {
      'es': {
        // Menú Principal
        'welcome': '¡Bienvenido/a, $userName! 👋',
        'intro': 'Hoy serás el protagonista de la historia. Vive tus decisiones digitales cotidianas frente al celular.\n\nCada decisión ante mensajes, redes sociales e Inteligencia Artificial calculará tu perfil de Alfabetización Mediática e Informacional (MIL).',
        'start_story': 'Comenzar Mi Historia',
        'lang_label': 'Idioma / Language',
        
        // Botones Generales
        'continue': 'Continuar',
        'decision_question': '¿Qué decisión vas a tomar?',
        'analyzing': 'Analizando decisiones...',
        'calculating': 'Calculando el perfil de hoy...',
        'evaluating_sub': 'Evaluando tus reacciones ante desinformación, IA y redes sociales...',
        'result_title': 'Tu Perfil Digital es:',
        'recommendations': '💡 Recomendaciones para ti:',
        'back_menu': 'Volver al Menú Principal',

        // Escena 1
        's1_step1_time': '8:00 a. m.',
        's1_step1_title': '1. DESPERTAR - Abriendo los ojos',
        's1_step1_desc': 'Abres los ojos lentamente. La luz del sol entra por tu ventana y sientes la vibración constante de tu celular en la mesa de noche.',
        
        's1_step2_time': '8:01 a. m.',
        's1_step2_title': '1. DESPERTAR - Habitación',
        's1_step2_desc': 'Te levantas de la cama frotándote los ojos. El celular no deja de sonar. Piensas: "Qué raro... ¿quién estará enviando tantos mensajes a esta hora?"',

        's1_step3_time': '8:03 a. m.',
        's1_step3_title': '1. DESPERTAR - Mensaje del Tío',
        's1_step3_desc': 'Tomas tu celular y ves una captura enviada por tu tío a toda la familia alertando sobre un supuesto corte de agua potable.',
        's1_opt1': 'Reenviar la imagen a otros grupos de inmediato para que todos estén precavidos.',
        's1_opt2': 'Buscar en internet si las autoridades confirmaron el corte de agua antes de enviar nada.',
        's1_opt3': 'Escribirle a mi tío por privado para preguntarle de dónde sacó esa imagen.',
        's1_opt4': 'Ignorar la notificación y dejar el celular a un lado.',

        // Escena 2
        's2_step1_time': '8:20 a. m.',
        's2_step1_title': '2. DESAYUNO - La Cocina',
        's2_step1_desc': 'Te diriges a la cocina a preparar el desayuno y te encuentras con tu mamá.',

        's2_step2_time': '8:22 a. m.',
        's2_step2_title': '2. DESAYUNO - Conversación con Mamá',
        's2_step2_desc': 'Tu mamá te mira preocupada esperando tu respuesta.',
        's2_dialog': 'Mamá: "Buenos días, $userName. ¿Viste la alerta urgente que envió tu tío sobre el agua?"',
        's2_opt1': 'Sí mamá, ya se lo reenvié a todos mis contactos por si acaso.',
        's2_opt2': 'No investigué mucho aún, pero lo revisaré en un momento.',
        's2_opt3': 'Mi tío siempre se cree todo lo que ve, no le hagas caso.',
        's2_opt4': 'Le sugiero que verifique en fuentes oficiales antes de enviárselo a sus amigas.',

        's2_step3_time': '8:30 a. m.',
        's2_step3_title': '2. DESAYUNO - La Cocina',
        's2_step3_desc': 'Dialogas con tu mamá y ella te agradece por tu recomendación.',
        's2_dialog3': 'Mamá: "Gracias por tu consejo, $userName. Ahora iré a terminar con mis pendientes, ya que estamos planeando un viaje con papá. Hoy saldrás al cine con tus amigos, ¿verdad? ¡Que disfrutes!"',

        // Escena 3
        's3_step1_time': '11:00 a. m.',
        's3_step1_title': '3. REDES SOCIALES - Oferta en tu Feed',
        's3_step1_desc': 'Estás ahorrando para comprar unos audífonos. Luego de buscar reseñas hace unos días, abres tus redes sociales y ves una oferta destacada.',

        's3_step2_time': '11:05 a. m.',
        's3_step2_title': '3. REDES SOCIALES - Comparando Reseñas',
        's3_step2_desc': 'Deslizas la pantalla y te aparecen dos publicaciones distintas con opiniones sobre diferentes marcas de audífonos.',
        's3_opt1': '¡Aprovecharé esta oferta y los compraré de una vez!',
        's3_opt2': 'Siento que el algoritmo sabe exactamente lo que necesito comprar.',
        's3_opt3': 'Imagino que me aparecen porque estuve buscando audífonos previamente.',
        's3_opt4': 'Voy a comparar qué precios y reseñas les aparecen a mis amigos.',

        's3_step3_time': '11:15 a. m.',
        's3_step3_title': '3. REDES SOCIALES - Recordatorio de Salida',
        's3_step3_desc': 'Sigues deslizando la red social y te cruzas con un anuncio de promoción 3x2 en el cine. Recuerdas que hoy quedaste en ir al cine con tus amigos.',

        // Escena 4
        's4_step1_time': '4:30 p. m.',
        's4_step1_title': '4. CINE - Salida con amigos',
        's4_step1_desc': 'Llegas al cine y te encuentras con tu grupo. Mientras Sara va al baño un momento, tu amigo te llama riéndose con el celular en la mano.',

        's4_step2_time': '4:35 p. m.',
        's4_step2_title': '4. CINE - La imagen editada con IA',
        's4_step2_desc': 'Tu amigo te muestra una foto donde usó Inteligencia Artificial para alterar el rostro de Sara en una escena comprometedora de la película.',
        's4_dialog': 'Amigo: "Oye, $userName, ¡mira lo que hice con IA! La mandaré al chat grupal, es un meme muy gracioso."',
        's4_opt1': '¡Ja, ja! Envíalo al grupo de una vez para reírnos todos.',
        's4_opt2': 'No lo hagas, eso le va a incomodar bastante a Sara.',
        's4_opt3': 'Borra esa imagen, no está bien usar su rostro así.',
        's4_opt4': 'Ignoraré esa imagen por completo como si nunca lo hubiera visto.',

        // Escena 5
        's5_step1_time': '7:30 p. m.',
        's5_step1_title': '5. REGRESO A CASA - La propuesta de Papá',
        's5_step1_desc': 'Regresas a casa de noche. Tu papá te recibe algo preocupado.',

        's5_step2_time': '7:35 p. m.',
        's5_step2_title': '5. REGRESO A CASA - Pasajes sospechosos',
        's5_step2_desc': 'Te muestra una publicación que encontró en las redes sociales con pasajes de bus al 30% de descuento. Notas fallas ortográficas en la imagen.',
        's5_dialog': 'Papá: "Hola $userName, mira esta oferta para el viaje familiar. ¿Compro los pasajes aquí de una vez?"',
        's5_opt1': 'Me parece bien papá, si está en redes sociales seguro es una agencia real.',
        's5_opt2': 'Hay que buscar opiniones y reclamos de otros usuarios en las redes antes de pagar.',
        's5_opt3': 'Voy a revisar si la empresa tiene un sitio web oficial o RUC registrado.',
        's5_opt4': 'Comparemos los precios directamente en las agencias de transporte conocidas.',

        // Escena 6
        's6_step1_time': '11:45 p. m.',
        's6_step1_title': '6. NOCHE - El temblor',
        's6_step1_desc': 'Estás a punto de dormir cuando sientes que la cama tiembla fuertemente durante varios segundos.',

        's6_step2_time': '11:46 p. m.',
        's6_step2_title': '6. NOCHE - El susto',
        's6_step2_desc': 'El temblor disminuye poco a poco. Tu celular sigue vibrando con notificaciones de mensajes y redes sociales.',

        's6_step3_time': '11:50 p. m.',
        's6_step3_title': '6. NOCHE - Falsa Alerta de Réplica',
        's6_step3_desc': 'Tomas tu teléfono por susto y ves una imagen circulando en redes con el logo de un organismo estatal sobre una réplica inminente.',
        's6_opt1': 'Salgo corriendo a la calle inmediatamente sin dudarlo.',
        's6_opt2': 'Verifico en la cuenta oficial verificada del instituto sismológico.',
        's6_opt3': 'Aviso a mi familia con calma para revisar si el comunicado es oficial.',
        's6_opt4': 'Lo ignoro por completo y trato de volver a dormir.',

        's6_step4_time': '12:00 a. m.',
        's6_step4_title': 'FIN DEL DÍA - A descansar',
        's6_step4_desc': 'Pasaron muchas cosas y estás cansado. Decides apagar el celular y descansar para el día siguiente.',
      },

      'en': {
        // Main Menu
        'welcome': 'Welcome, $userName! 👋',
        'intro': 'Today you are the protagonist of the story. Experience your daily digital choices on your phone.\n\nEvery decision regarding messages, social media, and Artificial Intelligence will compute your Media and Information Literacy (MIL) profile.',
        'start_story': 'Start My Story',
        'lang_label': 'Language / Idioma',

        // General Buttons
        'continue': 'Continue',
        'decision_question': 'What decision will you make?',
        'analyzing': 'Analyzing decisions...',
        'calculating': 'Calculating today\'s profile...',
        'evaluating_sub': 'Evaluating your reactions to misinformation, AI, and social media...',
        'result_title': 'Your Digital Profile is:',
        'recommendations': '💡 Recommendations for you:',
        'back_menu': 'Back to Main Menu',

        // Scene 1
        's1_step1_time': '8:00 AM',
        's1_step1_title': '1. WAKING UP - Opening your eyes',
        's1_step1_desc': 'You slowly open your eyes. Sunlight enters through your window and you feel your phone constantly vibrating on the nightstand.',

        's1_step2_time': '8:01 AM',
        's1_step2_title': '1. WAKING UP - Bedroom',
        's1_step2_desc': 'You get out of bed rubbing your eyes. The phone keeps ringing. You think: "Strange... who is sending so many messages at this hour?"',

        's1_step3_time': '8:03 AM',
        's1_step3_title': '1. WAKING UP - Message from Uncle',
        's1_step3_desc': 'You pick up your phone and see a screenshot sent by your uncle to the whole family warning about a alleged drinking water outage.',
        's1_opt1': 'Forward the image to other groups immediately so everyone is warned.',
        's1_opt2': 'Search online if authorities confirmed the water outage before sending anything.',
        's1_opt3': 'Text my uncle privately to ask where he got that screenshot.',
        's1_opt4': 'Ignore the notification and put the phone aside.',

        // Scene 2
        's2_step1_time': '8:20 AM',
        's2_step1_title': '2. BREAKFAST - The Kitchen',
        's2_step1_desc': 'You head to the kitchen to make breakfast and run into your mom.',

        's2_step2_time': '8:22 AM',
        's2_step2_title': '2. BREAKFAST - Conversation with Mom',
        's2_step2_desc': 'Your mom looks at you worriedly, waiting for your answer.',
        's2_dialog': 'Mom: "Good morning, $userName. Did you see the urgent alert your uncle sent about the water?"',
        's2_opt1': 'Yes mom, I already forwarded it to all my contacts just in case.',
        's2_opt2': 'I haven\'t investigated much yet, but I\'ll check in a moment.',
        's2_opt3': 'My uncle always believes everything he sees, don\'t pay attention to him.',
        's2_opt4': 'I suggest checking official sources before sending it to her friends.',

        's2_step3_time': '8:30 AM',
        's2_step3_title': '2. BREAKFAST - The Kitchen',
        's2_step3_desc': 'You talk with your mom and she thanks you for your advice.',
        's2_dialog3': 'Mom: "Thanks for your advice, $userName. Now I\'ll finish my tasks since we are planning a trip with dad. You\'re going to the movies with friends today, right? Enjoy!"',

        // Scene 3
        's3_step1_time': '11:00 AM',
        's3_step1_title': '3. SOCIAL MEDIA - Ad in your Feed',
        's3_step1_desc': 'You are saving up to buy headphones. After searching for reviews a few days ago, you open social media and see a featured deal.',

        's3_step2_time': '11:05 AM',
        's3_step2_title': '3. SOCIAL MEDIA - Comparing Reviews',
        's3_step2_desc': 'You scroll and see two different posts with opinions on different headphone brands.',
        's3_opt1': 'I\'ll take advantage of this deal and buy them right away!',
        's3_opt2': 'I feel like the algorithm knows exactly what I need to buy.',
        's3_opt3': 'I guess they appear because I was searching for headphones earlier.',
        's3_opt4': 'I\'ll compare what prices and reviews my friends get.',

        's3_step3_time': '11:15 AM',
        's3_step3_title': '3. REDES SOCIALES - Outing Reminder',
        's3_step3_desc': 'You keep scrolling and come across a 3x2 cinema ticket promo. You remember you agreed to go to the movies with friends today.',

        // Scene 4
        's4_step1_time': '4:30 PM',
        's4_step1_title': '4. CINEMA - Outing with friends',
        's4_step1_desc': 'You arrive at the cinema and meet your group. While Sara goes to the restroom, your friend calls you laughing with his phone in hand.',

        's4_step2_time': '4:35 PM',
        's4_step2_title': '4. CINEMA - AI Edit Image',
        's4_step2_desc': 'Your friend shows you a photo where he used Artificial Intelligence to alter Sara\'s face into a movie scene.',
        's4_dialog': 'Friend: "Hey, $userName, look what I did with AI! I\'ll send it to the group chat, it\'s a hilarious meme."',
        's4_opt1': 'Ha ha! Send it to the group right away so we all laugh.',
        's4_opt2': 'Don\'t do it, that will make Sara really uncomfortable.',
        's4_opt3': 'Delete that image, it\'s not right to use her face like that.',
        's4_opt4': 'I\'ll completely ignore that image as if I never saw it.',

        // Scene 5
        's5_step1_time': '7:30 PM',
        's5_step1_title': '5. RETURNING HOME - Dad\'s Proposal',
        's5_step1_desc': 'You return home at night. Your dad welcomes you somewhat concerned.',

        's5_step2_time': '7:35 PM',
        's5_step2_title': '5. RETURNING HOME - Suspicious Tickets',
        's5_step2_desc': 'He shows you a post he found on social media with bus tickets at a 30% discount. You notice spelling mistakes in the image.',
        's5_dialog': 'Dad: "Hi $userName, look at this deal for the family trip. Should I buy the tickets here right now?"',
        's5_opt1': 'Sounds good dad, if it\'s on social media it\'s probably a real agency.',
        's5_opt2': 'We should check reviews and complaints from other users before paying.',
        's5_opt3': 'I\'ll check if the company has an official website or registered business ID.',
        's5_opt4': 'Let\'s compare prices directly with well-known transport agencies.',

        // Scene 6
        's6_step1_time': '11:45 PM',
        's6_step1_title': '6. NIGHT - The Earthquake',
        's6_step1_desc': 'You are about to sleep when you feel the bed shake strongly for several seconds.',

        's6_step2_time': '11:46 PM',
        's6_step2_title': '6. NIGHT - The Aftershock Scare',
        's6_step2_desc': 'The shaking gradually slows down. Your phone keeps vibrating with notification messages.',

        's6_step3_time': '11:50 PM',
        's6_step3_title': '6. NIGHT - Fake Aftershock Alert',
        's6_step3_desc': 'You pick up your phone out of fear and see an image circulating with a state agency logo about an imminent aftershock.',
        's6_opt1': 'I run out into the street immediately without hesitation.',
        's6_opt2': 'I check the verified official account of the seismological institute.',
        's6_opt3': 'I calmly alert my family to check if the announcement is official.',
        's6_opt4': 'I completely ignore it and try to go back to sleep.',

        's6_step4_time': '12:00 AM',
        's6_step4_title': 'END OF THE DAY - Time to Rest',
        's6_step4_desc': 'A lot happened and you\'re tired. You decide to turn off your phone and rest for the next day.',
      }
    };
  }
}