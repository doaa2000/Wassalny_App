import 'app_locale.dart';

/// Lookup table for all UI copy in English, Arabic and Spanish.
///
/// Proper nouns and demo/sample values (names, phone numbers, sample places,
/// fixed amounts) are intentionally identical across languages.
class AppTranslations {
  AppTranslations._();

  /// Returns the value for [key] in the current language, falling back to
  /// English, then to the key itself.
  static String get(String key) {
    final Map<String, String>? entry = _data[key];
    if (entry == null) return key;
    return entry[AppLocale.lang] ?? entry['en'] ?? key;
  }

  static const Map<String, Map<String, String>> _data = {
    'appName': {'en': 'Wassalny', 'ar': 'Wassalny', 'es': 'Wassalny'},
    'appVersion': {
      'en': 'Wassalny · v1.0.0',
      'ar': 'Wassalny · v1.0.0',
      'es': 'Wassalny · v1.0.0'
    },

    // Welcome
    'welcomeTitle': {
      'en': 'Your ride,\none tap away.',
      'ar': 'رحلتك،\nبضغطة واحدة.',
      'es': 'Tu viaje,\na un toque.'
    },
    'welcomeSubtitle': {
      'en':
          'Compare nearby drivers, see real prices, and book the perfect ride across El Qusair in seconds.',
      'ar':
          'قارن بين السائقين القريبين، واطّلع على الأسعار الحقيقية، واحجز رحلتك المثالية في القصير خلال ثوانٍ.',
      'es':
          'Compara conductores cercanos, consulta precios reales y reserva el viaje perfecto por El Qusair en segundos.'
    },
    'getStarted': {'en': 'Get started', 'ar': 'ابدأ الآن', 'es': 'Comenzar'},
    'haveAccount': {
      'en': 'I already have an account',
      'ar': 'لديّ حساب بالفعل',
      'es': 'Ya tengo una cuenta'
    },

    // Onboarding
    'skip': {'en': 'Skip', 'ar': 'تخطٍّ', 'es': 'Omitir'},
    'onboardingTitle': {
      'en': 'Compare drivers,\npick your perfect ride.',
      'ar': 'قارن السائقين،\nواختر رحلتك المثالية.',
      'es': 'Compara conductores,\nelige tu viaje ideal.'
    },
    'onboardingSubtitle': {
      'en':
          'See real ratings, arrival times and prices side by side — then book in a single tap.',
      'ar':
          'شاهد التقييمات الحقيقية وأوقات الوصول والأسعار جنبًا إلى جنب — ثم احجز بضغطة واحدة.',
      'es':
          'Mira valoraciones reales, tiempos de llegada y precios lado a lado, y reserva con un solo toque.'
    },
    'continueLabel': {'en': 'Continue', 'ar': 'متابعة', 'es': 'Continuar'},

    // Location permission
    'enableLocationTitle': {
      'en': 'Enable your location',
      'ar': 'فعّل موقعك',
      'es': 'Activa tu ubicación'
    },
    'enableLocationSubtitle': {
      'en':
          'We use your location to find nearby drivers and set your pickup point accurately across El Qusair.',
      'ar':
          'نستخدم موقعك للعثور على السائقين القريبين وتحديد نقطة انطلاقك بدقة في القصير.',
      'es':
          'Usamos tu ubicación para encontrar conductores cercanos y fijar tu punto de recogida con precisión en El Qusair.'
    },
    'allowLocation': {
      'en': 'Allow location access',
      'ar': 'السماح بالوصول إلى الموقع',
      'es': 'Permitir acceso a la ubicación'
    },
    'enterManually': {
      'en': 'Enter location manually',
      'ar': 'إدخال الموقع يدويًا',
      'es': 'Introducir ubicación manualmente'
    },

    // Auth
    'welcomeBack': {
      'en': 'Welcome back',
      'ar': 'مرحبًا بعودتك',
      'es': 'Bienvenido de nuevo'
    },
    'loginSubtitle': {
      'en': 'Log in to book your next ride.',
      'ar': 'سجّل الدخول لحجز رحلتك التالية.',
      'es': 'Inicia sesión para reservar tu próximo viaje.'
    },
    'emailOrPhone': {
      'en': 'Email or phone',
      'ar': 'البريد الإلكتروني أو الهاتف',
      'es': 'Correo o teléfono'
    },
    'password': {'en': 'Password', 'ar': 'كلمة المرور', 'es': 'Contraseña'},
    'forgotPassword': {
      'en': 'Forgot password?',
      'ar': 'نسيت كلمة المرور؟',
      'es': '¿Olvidaste tu contraseña?'
    },
    'login': {'en': 'Log in', 'ar': 'تسجيل الدخول', 'es': 'Iniciar sesión'},
    'orContinueWith': {
      'en': 'or continue with',
      'ar': 'أو تابع باستخدام',
      'es': 'o continúa con'
    },
    'google': {'en': 'Google', 'ar': 'Google', 'es': 'Google'},
    'apple': {'en': 'Apple', 'ar': 'Apple', 'es': 'Apple'},
    'newToWassalny': {
      'en': 'New to Wassalny? ',
      'ar': 'جديد على Wassalny؟ ',
      'es': '¿Nuevo en Wassalny? '
    },
    'createAccount': {
      'en': 'Create account',
      'ar': 'إنشاء حساب',
      'es': 'Crear cuenta'
    },
    'signupSubtitle': {
      'en': 'Join Wassalny in under a minute.',
      'ar': 'انضم إلى Wassalny في أقل من دقيقة.',
      'es': 'Únete a Wassalny en menos de un minuto.'
    },
    'fullName': {'en': 'Full name', 'ar': 'الاسم الكامل', 'es': 'Nombre completo'},
    'phoneNumber': {
      'en': 'Phone number',
      'ar': 'رقم الهاتف',
      'es': 'Número de teléfono'
    },
    'agreePrefix': {
      'en': "I agree to Wassalny's ",
      'ar': 'أوافق على ',
      'es': 'Acepto los '
    },
    'termsOfService': {
      'en': 'Terms of Service',
      'ar': 'شروط الخدمة',
      'es': 'Términos del servicio'
    },
    'and': {'en': ' and ', 'ar': ' و ', 'es': ' y '},
    'privacyPolicy': {
      'en': 'Privacy Policy',
      'ar': 'سياسة الخصوصية',
      'es': 'Política de privacidad'
    },
    'alreadyHaveAccount': {
      'en': 'Already have an account? ',
      'ar': 'لديك حساب بالفعل؟ ',
      'es': '¿Ya tienes una cuenta? '
    },

    // OTP
    'verifyNumberTitle': {
      'en': 'Verify your number',
      'ar': 'تأكيد رقمك',
      'es': 'Verifica tu número'
    },
    'verifyNumberSubtitle': {
      'en': 'Enter the 4-digit code we sent to',
      'ar': 'أدخل الرمز المكوّن من 4 أرقام الذي أرسلناه إلى',
      'es': 'Introduce el código de 4 dígitos que enviamos a'
    },
    'demoPhone': {
      'en': '+20 100 234 5678',
      'ar': '+20 100 234 5678',
      'es': '+20 100 234 5678'
    },
    'didntGetCode': {
      'en': "Didn't get a code? ",
      'ar': 'لم يصلك الرمز؟ ',
      'es': '¿No recibiste el código? '
    },
    'resendIn': {
      'en': 'Resend in 0:28',
      'ar': 'إعادة الإرسال خلال 0:28',
      'es': 'Reenviar en 0:28'
    },
    'verify': {'en': 'Verify', 'ar': 'تأكيد', 'es': 'Verificar'},

    // Forgot
    'forgotTitle': {
      'en': 'Forgot password?',
      'ar': 'نسيت كلمة المرور؟',
      'es': '¿Olvidaste tu contraseña?'
    },
    'forgotSubtitle': {
      'en':
          "No worries. Enter your email and we'll send you a reset code.",
      'ar': 'لا تقلق. أدخل بريدك الإلكتروني وسنرسل لك رمز إعادة التعيين.',
      'es':
          'No te preocupes. Introduce tu correo y te enviaremos un código de restablecimiento.'
    },
    'emailAddress': {
      'en': 'Email address',
      'ar': 'البريد الإلكتروني',
      'es': 'Correo electrónico'
    },
    'sendResetCode': {
      'en': 'Send reset code',
      'ar': 'إرسال رمز إعادة التعيين',
      'es': 'Enviar código'
    },
    'backToLogin': {
      'en': 'Back to login',
      'ar': 'العودة لتسجيل الدخول',
      'es': 'Volver al inicio de sesión'
    },

    // Home
    'currentLocation': {
      'en': 'Qusair Fort, El Qusair',
      'ar': 'Qusair Fort, El Qusair',
      'es': 'Qusair Fort, El Qusair'
    },
    'greeting': {
      'en': 'Good evening, Layla',
      'ar': 'مساء الخير يا ليلى',
      'es': 'Buenas noches, Layla'
    },
    'whereTo': {
      'en': 'Where would you like to go?',
      'ar': 'إلى أين تريد الذهاب؟',
      'es': '¿A dónde quieres ir?'
    },
    'whereToShort': {'en': 'Where to?', 'ar': 'إلى أين؟', 'es': '¿A dónde?'},
    'setOnMap': {
      'en': 'Set on map',
      'ar': 'تحديد على الخريطة',
      'es': 'Fijar en el mapa'
    },
    'driversNearYou': {
      'en': 'Drivers near you',
      'ar': 'سائقون بالقرب منك',
      'es': 'Conductores cerca de ti'
    },
    'compareAll': {'en': 'Compare all', 'ar': 'قارن الكل', 'es': 'Comparar todos'},

    // Search
    'planYourRide': {
      'en': 'Plan your ride',
      'ar': 'خطّط لرحلتك',
      'es': 'Planifica tu viaje'
    },
    'recent': {'en': 'Recent', 'ar': 'الأخيرة', 'es': 'Recientes'},
    'savedPlaces': {
      'en': 'Saved places',
      'ar': 'الأماكن المحفوظة',
      'es': 'Lugares guardados'
    },
    'findDriver': {'en': 'Find a driver', 'ar': 'ابحث عن سائق', 'es': 'Buscar conductor'},
    'setDropoffFirst': {
      'en': 'Set your destination',
      'ar': 'حدّد وجهتك',
      'es': 'Fija tu destino'
    },

    // Driver select
    'chooseDriver': {
      'en': 'Choose your driver',
      'ar': 'اختر سائقك',
      'es': 'Elige tu conductor'
    },
    'tripRoute': {
      'en': 'Qusair Fort → Sirena Beach',
      'ar': 'Qusair Fort → Sirena Beach',
      'es': 'Qusair Fort → Sirena Beach'
    },
    'arrives': {'en': 'Arrives', 'ar': 'يصل خلال', 'es': 'Llega en'},
    'plate': {'en': 'Plate', 'ar': 'اللوحة', 'es': 'Placa'},
    'estFare': {'en': 'Est. fare', 'ar': 'الأجرة التقديرية', 'es': 'Tarifa est.'},

    // Confirm
    'confirmRide': {
      'en': 'Confirm your ride',
      'ar': 'أكّد رحلتك',
      'es': 'Confirma tu viaje'
    },
    'confirmRideAction': {
      'en': 'Confirm ride',
      'ar': 'تأكيد الرحلة',
      'es': 'Confirmar viaje'
    },
    'requestRide': {'en': 'Request ride', 'ar': 'اطلب رحلة', 'es': 'Solicitar viaje'},
    'pickup': {'en': 'PICKUP', 'ar': 'الانطلاق', 'es': 'RECOGIDA'},
    'dropoff': {'en': 'DROP-OFF', 'ar': 'الوجهة', 'es': 'DESTINO'},
    'dropoffPlace': {
      'en': 'Sirena Beach',
      'ar': 'Sirena Beach',
      'es': 'Sirena Beach'
    },
    'change': {'en': 'Change', 'ar': 'تغيير', 'es': 'Cambiar'},
    'paymentMethod': {
      'en': 'Payment method',
      'ar': 'طريقة الدفع',
      'es': 'Método de pago'
    },
    'fareBreakdown': {
      'en': 'Fare breakdown',
      'ar': 'تفاصيل الأجرة',
      'es': 'Desglose de tarifa'
    },

    // Finding
    'findingDriver': {
      'en': 'Finding your driver',
      'ar': 'جارٍ البحث عن سائق',
      'es': 'Buscando tu conductor'
    },
    'findingSubtitle': {
      'en':
          'Matching you with the best nearby driver\nfor your trip to Sirena Beach',
      'ar': 'نبحث لك عن أفضل سائق قريب\nلرحلتك إلى Sirena Beach',
      'es':
          'Buscando el mejor conductor cercano\npara tu viaje a Sirena Beach'
    },
    'cancel': {'en': 'Cancel', 'ar': 'إلغاء', 'es': 'Cancelar'},
    'noDriversFound': {
      'en': 'No captains available right now',
      'ar': 'مفيش كباتن متاحين دلوقتي',
      'es': 'No hay conductores disponibles ahora'
    },
    'noDriversFoundSubtitle': {
      'en':
          'No one nearby accepted your request. Try raising your offer or search again in a bit.',
      'ar': 'محدش قريب قبل طلبك. جربي تزودي السعر أو حاولي تاني بعد شوية.',
      'es':
          'Nadie cercano aceptó tu solicitud. Intenta subir tu oferta o vuelve a intentarlo pronto.'
    },
    'tryAgain': {'en': 'Try again', 'ar': 'حاول تاني', 'es': 'Intentar de nuevo'},
    'backToSearch': {
      'en': 'Back to search',
      'ar': 'رجوع للبحث',
      'es': 'Volver a la búsqueda'
    },

    // Assigned
    'trackYourRide': {
      'en': 'Track your ride',
      'ar': 'تتبّع رحلتك',
      'es': 'Sigue tu viaje'
    },
    'cancelRide': {'en': 'Cancel ride', 'ar': 'إلغاء الرحلة', 'es': 'Cancelar viaje'},
    'tripInProgress': {
      'en': 'Trip in progress',
      'ar': 'الرحلة جارية',
      'es': 'Viaje en curso'
    },
    'call': {'en': 'Call', 'ar': 'اتصال', 'es': 'Llamar'},
    'chat': {'en': 'Chat', 'ar': 'محادثة', 'es': 'Chat'},
    'share': {'en': 'Share', 'ar': 'مشاركة', 'es': 'Compartir'},

    // Tracking
    'arrivingIn': {'en': 'Arriving in', 'ar': 'يصل خلال', 'es': 'Llega en'},
    'arrivingValue': {
      'en': '11 min · 6.4 km',
      'ar': '11 دقيقة · 6.4 كم',
      'es': '11 min · 6.4 km'
    },
    'sos': {'en': 'SOS', 'ar': 'SOS', 'es': 'SOS'},
    'completeTripDemo': {
      'en': 'Complete trip (demo)',
      'ar': 'إنهاء الرحلة (تجريبي)',
      'es': 'Completar viaje (demo)'
    },

    // Completed
    'arrivedTitle': {
      'en': "You've arrived!",
      'ar': 'لقد وصلت!',
      'es': '¡Has llegado!'
    },
    'arrivedSubtitle': {
      'en': 'Hope you enjoyed your ride with Ahmed.',
      'ar': 'نتمنى أن تكون قد استمتعت برحلتك مع أحمد.',
      'es': 'Esperamos que hayas disfrutado tu viaje con Ahmed.'
    },
    'addTip': {'en': 'Add a tip', 'ar': 'أضف إكرامية', 'es': 'Añadir propina'},
    'leaveReview': {
      'en': 'Leave a review (optional)',
      'ar': 'اترك تقييمًا (اختياري)',
      'es': 'Deja una reseña (opcional)'
    },
    'submitDone': {
      'en': 'Submit & done',
      'ar': 'إرسال وإنهاء',
      'es': 'Enviar y listo'
    },
    'howWasTrip': {
      'en': 'How was your trip?',
      'ar': 'كيف كانت رحلتك؟',
      'es': '¿Qué tal tu viaje?'
    },

    // Wallet
    'wallet': {'en': 'Wallet', 'ar': 'المحفظة', 'es': 'Cartera'},
    'availableBalance': {
      'en': 'Available balance',
      'ar': 'الرصيد المتاح',
      'es': 'Saldo disponible'
    },
    'balance': {'en': 'EGP 340.00', 'ar': 'EGP 340.00', 'es': 'EGP 340.00'},
    'addFunds': {'en': 'Add funds', 'ar': 'إضافة رصيد', 'es': 'Añadir fondos'},
    'send': {'en': 'Send', 'ar': 'إرسال', 'es': 'Enviar'},
    'paymentMethods': {
      'en': 'Payment methods',
      'ar': 'طرق الدفع',
      'es': 'Métodos de pago'
    },
    'addNewCard': {
      'en': 'Add a new card',
      'ar': 'إضافة بطاقة جديدة',
      'es': 'Añadir tarjeta'
    },
    'recentTransactions': {
      'en': 'Recent transactions',
      'ar': 'المعاملات الأخيرة',
      'es': 'Transacciones recientes'
    },

    // History
    'yourRides': {'en': 'Your rides', 'ar': 'رحلاتك', 'es': 'Tus viajes'},
    'all': {'en': 'All', 'ar': 'الكل', 'es': 'Todos'},
    'completed': {'en': 'Completed', 'ar': 'مكتملة', 'es': 'Completados'},
    'cancelled': {'en': 'Cancelled', 'ar': 'ملغاة', 'es': 'Cancelados'},
    'rebook': {'en': 'Rebook', 'ar': 'إعادة الحجز', 'es': 'Reservar de nuevo'},
    'getReceipt': {
      'en': 'Get receipt',
      'ar': 'الحصول على إيصال',
      'es': 'Obtener recibo'
    },

    // Notifications
    'notifications': {
      'en': 'Notifications',
      'ar': 'الإشعارات',
      'es': 'Notificaciones'
    },
    'markAllRead': {
      'en': 'Mark all read',
      'ar': 'تحديد الكل كمقروء',
      'es': 'Marcar todo leído'
    },
    'today': {'en': 'Today', 'ar': 'اليوم', 'es': 'Hoy'},
    'earlier': {'en': 'Earlier', 'ar': 'سابقًا', 'es': 'Anteriores'},

    // Profile
    'riderName': {
      'en': 'Layla Mansour',
      'ar': 'Layla Mansour',
      'es': 'Layla Mansour'
    },
    'riderPhone': {
      'en': '+20 100 234 5678',
      'ar': '+20 100 234 5678',
      'es': '+20 100 234 5678'
    },
    'riderTag': {'en': '4.9 · Rider', 'ar': '4.9 · راكب', 'es': '4.9 · Pasajero'},
    'personalInfo': {
      'en': 'Personal information',
      'ar': 'المعلومات الشخصية',
      'es': 'Información personal'
    },
    'savedLocations': {
      'en': 'Saved locations',
      'ar': 'المواقع المحفوظة',
      'es': 'Ubicaciones guardadas'
    },
    'language': {'en': 'Language', 'ar': 'اللغة', 'es': 'Idioma'},
    'languageValue': {'en': 'English', 'ar': 'العربية', 'es': 'Español'},
    'helpSupport': {
      'en': 'Help & support',
      'ar': 'المساعدة والدعم',
      'es': 'Ayuda y soporte'
    },
    'rateApp': {'en': 'Rate the app', 'ar': 'قيّم التطبيق', 'es': 'Valora la app'},
    'aboutUs': {'en': 'About us', 'ar': 'من نحن', 'es': 'Acerca de nosotros'},
    'logout': {'en': 'Log out', 'ar': 'تسجيل الخروج', 'es': 'Cerrar sesión'},

    // Bottom nav
    'navHome': {'en': 'Home', 'ar': 'الرئيسية', 'es': 'Inicio'},
    'navRides': {'en': 'Rides', 'ar': 'الرحلات', 'es': 'Viajes'},
    'navWallet': {'en': 'Wallet', 'ar': 'المحفظة', 'es': 'Cartera'},
    'navAlerts': {'en': 'Alerts', 'ar': 'التنبيهات', 'es': 'Alertas'},
    'navProfile': {'en': 'Profile', 'ar': 'الملف الشخصي', 'es': 'Perfil'},

    // Map / pickup
    'setPickupHint': {
      'en': 'Move the map to set pickup…',
      'ar': 'حرّك الخريطة لتحديد الانطلاق…',
      'es': 'Mueve el mapa para fijar la recogida…'
    },
    'pickerHint': {
      'en': 'Move the map or tap to choose the spot',
      'ar': 'حرّك الخريطة أو اضغط لاختيار المكان',
      'es': 'Mueve el mapa o toca para elegir el punto'
    },
    'locating': {'en': 'Locating…', 'ar': 'جارٍ التحديد…', 'es': 'Localizando…'},
    'confirm': {'en': 'Confirm', 'ar': 'تأكيد', 'es': 'Confirmar'},
    'outsideServiceArea': {
      'en': "Sorry, we don't serve this area yet.",
      'ar': 'عذرًا، الخدمة غير متاحة في هذه المنطقة حاليًا.',
      'es': 'Lo sentimos, aún no operamos en esta zona.'
    },
    'placeHome': {'en': 'Home', 'ar': 'المنزل', 'es': 'Casa'},
    'placeWork': {'en': 'Work', 'ar': 'العمل', 'es': 'Trabajo'},

    // Confirm extras
    'estimatedTotal': {
      'en': 'Estimated total',
      'ar': 'الإجمالي التقديري',
      'es': 'Total estimado'
    },
    'fareNote': {
      'en':
          'A nearby captain will accept your request. Final fare may vary with the route.',
      'ar': 'سيقبل طلبك كابتن قريب. قد تختلف الأجرة النهائية حسب المسار.',
      'es':
          'Un conductor cercano aceptará tu solicitud. La tarifa final puede variar según la ruta.'
    },
    'yourOffer': {
      'en': 'Your offer',
      'ar': 'السعر اللي بتعرضه',
      'es': 'Tu oferta'
    },
    'suggestedFare': {
      'en': 'Suggested',
      'ar': 'المقترح',
      'es': 'Sugerido'
    },
    'priceTooLow': {
      'en': 'Enter a fair price to get a captain faster',
      'ar': 'اكتب سعر مناسب عشان تلاقي كابتن أسرع',
      'es': 'Ingresa un precio justo para conseguir un conductor más rápido'
    },
    'tapToAddAddress': {
      'en': 'Tap to add address',
      'ar': 'دوس لإضافة العنوان',
      'es': 'Toca para añadir dirección'
    },
    'renamePlace': {
      'en': 'Rename place',
      'ar': 'إعادة تسمية المكان',
      'es': 'Renombrar lugar'
    },
    'save': {'en': 'Save', 'ar': 'حفظ', 'es': 'Guardar'},
    'couldNotLoadPlaces': {
      'en': 'Could not load places. Pull down to retry.',
      'ar': 'تعذّر تحميل الأماكن. اسحبي للأسفل للمحاولة مرة أخرى.',
      'es': 'No se pudieron cargar los lugares. Desliza hacia abajo para reintentar.'
    },
    'couldNotAddPlace': {
      'en': 'Could not save this place. Check your connection and try again.',
      'ar': 'تعذّر حفظ المكان. تأكدي من الاتصال بالإنترنت وحاولي مرة أخرى.',
      'es': 'No se pudo guardar este lugar. Verifica tu conexión e inténtalo de nuevo.'
    },
    'couldNotRenamePlace': {
      'en': 'Could not rename this place. Try again.',
      'ar': 'تعذّر تغيير اسم المكان. حاولي مرة أخرى.',
      'es': 'No se pudo renombrar este lugar. Inténtalo de nuevo.'
    },
    'couldNotRemovePlace': {
      'en': 'Could not remove this place. Try again.',
      'ar': 'تعذّر حذف المكان. حاولي مرة أخرى.',
      'es': 'No se pudo eliminar este lugar. Inténtalo de nuevo.'
    },

    // Rate app
    'rateTitle': {
      'en': 'Enjoying Wassalny?',
      'ar': 'هل تستمتع بـ Wassalny؟',
      'es': '¿Disfrutas Wassalny?'
    },
    'ratePrompt': {
      'en': 'Tap a star to rate your experience.',
      'ar': 'اضغط على نجمة لتقييم تجربتك.',
      'es': 'Toca una estrella para valorar tu experiencia.'
    },
    'submit': {'en': 'Submit', 'ar': 'إرسال', 'es': 'Enviar'},
    'rateThanks': {
      'en': 'Thanks for your feedback! ⭐',
      'ar': 'شكرًا لتقييمك! ⭐',
      'es': '¡Gracias por tu opinión! ⭐'
    },

    // About
    'aboutDescription': {
      'en':
          'Wassalny is a ride-hailing app that connects riders with nearby captains across El Qusair. Set your pickup on the map, request a ride, and a nearby captain accepts and drives you to your destination — simply and affordably.',
      'ar':
          'Wassalny تطبيق لطلب الرحلات يربط الركاب بالكباتن القريبين في القصير. حدّد نقطة انطلاقك على الخريطة، اطلب رحلة، ويقبلها كابتن قريب ليوصلك إلى وجهتك — ببساطة وبأسعار مناسبة.',
      'es':
          'Wassalny es una app de transporte que conecta a pasajeros con conductores cercanos en El Qusair. Fija tu recogida en el mapa, solicita un viaje y un conductor cercano lo acepta y te lleva a tu destino — de forma simple y económica.'
    },
    'aboutRights': {
      'en': '© 2026 Wassalny. All rights reserved.',
      'ar': '© 2026 Wassalny. جميع الحقوق محفوظة.',
      'es': '© 2026 Wassalny. Todos los derechos reservados.'
    },
  };
}
