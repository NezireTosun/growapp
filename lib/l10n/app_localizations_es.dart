// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Inscribirse';

  @override
  String get welcomeBack =>
      '¡Bienvenido de nuevo! Inicia sesión para continuar.';

  @override
  String get createAccount => 'Crea tu cuenta con tu información personal.';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'confirmar Contraseña';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get forgotPassword => '¿Has olvidado tu contraseña?';

  @override
  String get forgotPasswordDesc =>
      'Ingresa tu correo y te enviaremos un código de 6 dígitos.';

  @override
  String get resetPasswordButton => 'Restablecer contraseña';

  @override
  String get resetPasswordSent => '¡Código enviado!';

  @override
  String resetPasswordSentDesc(String email) {
    return 'Enviamos un código de 6 dígitos a $email.';
  }

  @override
  String get enterResetCode =>
      'Ingresa el código de 6 dígitos enviado a tu correo.';

  @override
  String get createNewPassword => 'Crear nueva contraseña';

  @override
  String get createNewPasswordDesc =>
      'Tu nueva contraseña debe tener al menos 6 caracteres.';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get newPasswordHint => 'Ingresa nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get confirmNewPasswordHint => 'Reingresa nueva contraseña';

  @override
  String get resetPasswordSuccess => '¡Contraseña actualizada con éxito!';

  @override
  String get resetPasswordSuccessDesc =>
      'Tu contraseña ha sido cambiada. Ya puedes iniciar sesión con tu nueva contraseña.';

  @override
  String get passwordResetExpired =>
      'El código ha expirado. Por favor solicita uno nuevo.';

  @override
  String get backToLogin => 'Volver al inicio de sesión';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get emailHint => 'ejemplo@email.com';

  @override
  String get fullNameHint => 'Tu nombre completo';

  @override
  String get phoneHint => '5XX XXX XX XX';

  @override
  String get enterEmail => 'Por favor ingrese su correo electrónico';

  @override
  String get validEmail => 'Por favor, introduzca un correo electrónico válido';

  @override
  String get enterPassword => 'Por favor, introduzca su contraseña';

  @override
  String get enterAPassword => 'Por favor, introduzca una contraseña';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get confirmYourPassword => 'Por favor confirme su contraseña';

  @override
  String get passwordsNotMatch => 'Las contraseñas no coinciden';

  @override
  String get enterName => 'Por favor, introduzca su nombre';

  @override
  String get enterPhone => 'Por favor ingrese su número de teléfono';

  @override
  String get continueButton => 'Continuar';

  @override
  String get businessNameFallback => 'El nombre de su empresa';

  @override
  String get enterBusinessName => 'Ingrese el nombre de su empresa';

  @override
  String get businessTypeFallback => '¿Cuál es su tipo de negocio?';

  @override
  String get comingSoon => 'MUY PRONTO';

  @override
  String get analysisStep1 => 'Revisando tus respuestas...';

  @override
  String get analysisStep2 => 'Analizando su tipo de negocio...';

  @override
  String get analysisStep3 => 'Identificando oportunidades de crecimiento...';

  @override
  String get analysisStep4 => 'Preparando tareas personalizadas...';

  @override
  String get analysisStep5 => '¡Casi listo!';

  @override
  String get aiAnalyzingTitle => 'La IA está analizando tu negocio';

  @override
  String get aiAnalyzingSubtitle => 'Esto sólo tomará un momento.';

  @override
  String get welcome => 'BIENVENIDO';

  @override
  String helloName(String name) {
    return 'Hola $name';
  }

  @override
  String get boostSales => '¡Impulsemos\ntus ventas hoy!';

  @override
  String dailyGoalsProgress(int completed, int total) {
    return '$completed de $total objetivos diarios completados';
  }

  @override
  String get details => 'Detalles';

  @override
  String get statusCompleted => 'TERMINADO';

  @override
  String get statusViewed => 'VISTO';

  @override
  String get statusWontDo => 'NO LO HARÉ';

  @override
  String get statusDontSuggest => 'NO SUGERIR';

  @override
  String get highImpact => 'ALTO IMPACTO';

  @override
  String get medImpact => 'IMPACTO MEDICO';

  @override
  String get lowImpact => 'BAJO IMPACTO';

  @override
  String minutesBadge(int minutes) {
    return '$minutes MIN';
  }

  @override
  String get navHome => 'Hogar';

  @override
  String get navAnalytics => 'Analítica';

  @override
  String get navBlog => 'Blog';

  @override
  String get navProfile => 'Perfil';

  @override
  String get taskDetails => 'Detalles de la tarea';

  @override
  String dailyTaskCounter(int current, int total) {
    return 'TAREA DIARIA $current/$total';
  }

  @override
  String get whyItMakesMoney => 'Por qué es rentable';

  @override
  String get howToDoIt => 'Cómo hacerlo';

  @override
  String get readyMadeTemplate => 'Plantilla lista para usar';

  @override
  String get copied => 'Copiado';

  @override
  String get copy => 'Copiar';

  @override
  String get wereHereToHelp => 'Estamos aquí para ayudar';

  @override
  String get needHelpTask =>
      '¿Necesitas ayuda para completar esta tarea? Contacta con nuestro equipo de inmediato.';

  @override
  String get contactUs => 'Contáctenos';

  @override
  String get done => 'Hecho';

  @override
  String get illDoIt => 'Lo haré';

  @override
  String get snooze => 'Lo haré después';

  @override
  String get dontSuggest => 'No sugerir nunca';

  @override
  String get myBusiness => 'Mi negocio';

  @override
  String get growthLevel => 'Nivel de crecimiento 2';

  @override
  String get levelProgress => 'Progreso de nivel';

  @override
  String get businessInfo => 'INFORMACIÓN COMERCIAL';

  @override
  String get personalInfo => 'INFORMACIÓN PERSONAL';

  @override
  String get name => 'Nombre';

  @override
  String get phone => 'Teléfono';

  @override
  String get instagram => 'Instagram';

  @override
  String get city => 'Ciudad';

  @override
  String get cityHint => 'Ej. Estambul';

  @override
  String get updateInfo => 'Actualizar información';

  @override
  String get settings => 'AJUSTES';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get subscriptionPlan => 'Plan de suscripción';

  @override
  String get proPlan => 'Plan Pro';

  @override
  String get aboutUs => 'Sobre nosotros';

  @override
  String get aboutUsPageTitle => 'Sobre nosotros';

  @override
  String get aboutUsDesc =>
      'GrowApp es una plataforma impulsada por IA que ayuda a propietarios de cafeterías y restaurantes a hacer crecer sus negocios.';

  @override
  String get aboutUsMission => 'Nuestra Misión';

  @override
  String get aboutUsMissionDesc =>
      'Hacer accesibles las estrategias de crecimiento para cada pequeño empresario. Ofrecemos tareas diarias personalizadas con IA para ayudarte a crecer paso a paso.';

  @override
  String get aboutUsFeatures => 'Lo que ofrecemos';

  @override
  String get aboutUsFeature1 => 'Tareas diarias personalizadas';

  @override
  String get aboutUsFeature2 => 'Consultoría empresarial con IA';

  @override
  String get aboutUsFeature3 => 'Plantillas de marketing listas';

  @override
  String get aboutUsFeature4 => 'Seguimiento de progreso y analítica';

  @override
  String get aboutUsFeature5 => 'Notificaciones de tareas por WhatsApp';

  @override
  String get aboutUsVersion => 'Versión';

  @override
  String get aboutUsTeam => 'Equipo';

  @override
  String get aboutUsTeamDesc =>
      'Desarrollado por un equipo apasionado con sede en Praga, dedicado a impulsar pequeños negocios.';

  @override
  String get contact => 'Contacto';

  @override
  String get contactPageTitle => 'Contacto';

  @override
  String get contactPageDesc => 'Contáctenos para preguntas o comentarios.';

  @override
  String get contactEmail => 'Correo electrónico';

  @override
  String get contactEmailValue => 'info@salesgrowthsteps.com';

  @override
  String get contactPhone => 'Teléfono';

  @override
  String get contactPhoneValue => '+90 850 123 45 67';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get contactAddress => 'Dirección';

  @override
  String get contactAddressValue => 'Praga, República Checa';

  @override
  String get contactWorkingHours => 'Horario de atención';

  @override
  String get contactWorkingHoursValue => 'Lun-Vie 09:00 - 18:00';

  @override
  String get sendUsMessage => 'Envíenos un mensaje';

  @override
  String get messageSubject => 'Asunto';

  @override
  String get messageSubjectHint => 'Asunto de su mensaje';

  @override
  String get messageBody => 'Mensaje';

  @override
  String get messageBodyHint => 'Escriba su mensaje aquí...';

  @override
  String get sendMessage => 'Enviar mensaje';

  @override
  String get messageSent => '¡Su mensaje ha sido enviado!';

  @override
  String get messageSentDesc => 'Le responderemos lo antes posible.';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get signOut => 'Desconectar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get deleteAccountMessage =>
      '¿Seguro que quieres eliminar tu cuenta? Esta acción es irreversible y todos tus datos se eliminarán definitivamente.';

  @override
  String get signOutMessage =>
      '¿Seguro que quieres cerrar sesión? Se guardará tu progreso diario de tareas.';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get businessNameLabel => 'Nombre de la empresa';

  @override
  String get businessNameHint => 'El nombre de su empresa';

  @override
  String get enterBusinessNameValidation =>
      'Por favor, introduzca el nombre de la empresa';

  @override
  String get phoneHintFull => '+90 555 123 45 67';

  @override
  String get enterPhoneValidation =>
      'Por favor, introduzca el número de teléfono';

  @override
  String get instagramHint => '@tunegocio';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get notificationSettings => 'Configuración de notificaciones';

  @override
  String get dailyTaskReminders => 'Recordatorios de tareas diarias';

  @override
  String get offPeakDeals => 'Ofertas fuera de temporada';

  @override
  String get weeklyProgressReport => 'Informe de progreso semanal';

  @override
  String get newFeaturesUpdates => 'Nuevas funciones y actualizaciones';

  @override
  String get notificationWarning =>
      'Desactivar las notificaciones puede hacer que pierdas oportunidades de crecimiento y consejos de ventas.';

  @override
  String get blog => 'Blog';

  @override
  String get general => 'General';

  @override
  String get categoryInstagram => 'Instagram';

  @override
  String get categoryWhatsapp => 'WhatsApp';

  @override
  String get campaignLabel => 'CAMPAÑA';

  @override
  String get instagramLabel => 'INSTAGRAM';

  @override
  String get whatsappLabel => 'WhatsApp';

  @override
  String get share => 'COMPARTIR';

  @override
  String get blogDetail => 'Detalle del blog';

  @override
  String get popular => 'POPULAR';

  @override
  String get blogFooterText =>
      'Recuerda, las redes sociales no son solo un escaparate, sino un espacio de diálogo. Responder a todas las preguntas con prontitud y estar al tanto de los comentarios ayuda al algoritmo a mostrarte a más personas. Usar plantillas profesionales listas para usar puede ayudarte a aumentar tus ventas.';

  @override
  String get copyTemplate => 'Copiar plantilla';

  @override
  String get like => 'Como';

  @override
  String get shareButton => 'Compartir';

  @override
  String get painPointContinue => 'CONTINUAR';

  @override
  String get verifyYourEmail => 'Verifica tu correo';

  @override
  String get verificationSent => 'Hemos enviado un enlace de verificación a';

  @override
  String get checkInbox =>
      'Por favor, revisa tu bandeja de entrada y haz clic en el enlace de verificación para continuar.';

  @override
  String get openEmailApp => 'Abrir correo';

  @override
  String get resendEmail => 'Reenviar correo';

  @override
  String get iVerified => 'Ya verifiqué';

  @override
  String get emailNotVerified =>
      'Correo no verificado aún. Por favor revisa tu bandeja de entrada.';

  @override
  String get verificationResent => '¡Correo de verificación reenviado!';

  @override
  String get checkSpamFolder => '¡No olvides revisar tu carpeta de spam!';

  @override
  String get accountDeactivated =>
      'Esta cuenta ha sido desactivada. Por favor, contacte con soporte.';

  @override
  String get userNotFound => 'No se encontró una cuenta con este correo.';

  @override
  String get wrongPassword => 'Correo o contraseña incorrectos.';

  @override
  String get tooManyRequests => 'Demasiados intentos. Espere un momento.';

  @override
  String get loginError => 'Error de inicio de sesión. Inténtelo de nuevo.';

  @override
  String get emailAlreadyInUse => 'Este correo ya está registrado.';

  @override
  String get analyticsTitle => 'Analítica';

  @override
  String get overview => 'RESUMEN';

  @override
  String get tasksCompleted => 'Tareas\nCompletadas';

  @override
  String get tasksViewed => 'Tareas\nVistas';

  @override
  String get tasksSkipped => 'Tareas\nOmitidas';

  @override
  String get completionRate => 'Tasa de Finalización';

  @override
  String get tasksByStatus => 'TAREAS POR ESTADO';

  @override
  String get completed => 'Completado';

  @override
  String get viewed => 'Visto';

  @override
  String get skipped => 'Omitido';

  @override
  String get dismissed => 'Descartado';

  @override
  String get pending => 'Pendiente';

  @override
  String get noTasksYet => 'Aún no hay tareas';

  @override
  String get noTasksYetSubtitle =>
      'Completa tareas desde el panel para ver tus análisis aquí.';

  @override
  String get currentStreak => 'RACHA ACTUAL';

  @override
  String streakDays(int count) {
    return '$count Días';
  }

  @override
  String todayPlus(int count) {
    return '+$count hoy';
  }

  @override
  String get weeklyPerformance => 'Rendimiento Semanal';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get completedTasksCount => 'Tareas Completadas';

  @override
  String vsLastWeek(int percent) {
    return '+$percent% vs semana pasada';
  }

  @override
  String vsLastWeekNeg(int percent) {
    return '$percent% vs semana pasada';
  }

  @override
  String get categoryDistribution => 'Distribución por Categoría';

  @override
  String get catAcquisition => 'Adquisición de Clientes';

  @override
  String get catConversion => 'Conversión';

  @override
  String get catRetention => 'Retención de Clientes';

  @override
  String get catOperations => 'Operaciones';

  @override
  String get catB2bSales => 'Ventas B2B';

  @override
  String get catAnalytics => 'Analítica';

  @override
  String get catStaffManagement => 'Gestión de Personal';

  @override
  String get catSocialProof => 'Prueba Social';

  @override
  String get catProfitability => 'Rentabilidad';

  @override
  String get catSalesPower => 'Fuerza de Ventas';

  @override
  String get catExperience => 'Experiencia';

  @override
  String get catLocal => 'Marketing Local';

  @override
  String get catUpsell => 'Venta Cruzada';

  @override
  String get catOther => 'Otros';

  @override
  String get successAnalytics => 'Análisis de Éxito';

  @override
  String get myBusinesses => 'Mis Negocios';

  @override
  String get addBusiness => 'Agregar Negocio';

  @override
  String get switchBusiness => 'Cambiar Negocio';

  @override
  String get currentBusiness => 'ACTUAL';

  @override
  String get upgradeToPremium => 'Actualizar a Premium';

  @override
  String get premiumRequired => 'Se Requiere Premium';

  @override
  String get premiumRequiredMessage =>
      'Actualiza a Premium para agregar múltiples negocios y desbloquear funciones avanzadas.';

  @override
  String get upgrade => 'Actualizar';

  @override
  String get businessLimitReached =>
      'Has alcanzado el número máximo de negocios para tu plan.';

  @override
  String get subscription => 'Suscripción';

  @override
  String get currentPlan => 'Plan Actual';

  @override
  String get freePlan => 'Gratis';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get freePlanPrice => 'Gratis';

  @override
  String get premiumPlanPrice => '\$99/mes';

  @override
  String get freePlanDesc => 'Perfecto para comenzar con un negocio.';

  @override
  String get premiumPlanDesc =>
      'Desbloquea funciones avanzadas y gestiona múltiples negocios.';

  @override
  String get featureDailyTasks => 'Tareas de Crecimiento Diarias';

  @override
  String get featureBlog => 'Blog y Plantillas';

  @override
  String get featureAnalytics => 'Analítica Avanzada';

  @override
  String get featureAiInsights => 'Insights con IA';

  @override
  String get featureMultiBusiness => 'Hasta 5 Negocios';

  @override
  String get featureMultiMember => 'Hasta 3 Miembros';

  @override
  String get upgradeNow => 'Actualizar Ahora';

  @override
  String get downgrade => 'Bajar a Gratis';

  @override
  String get yourCurrentPlan => 'Tu Plan Actual';

  @override
  String get verificationCodeSent =>
      'Hemos enviado un código de verificación a';

  @override
  String get verifyCode => 'Verificar Código';

  @override
  String get resendCode => 'Reenviar Código';

  @override
  String get changeEmail => 'Cambiar';

  @override
  String get invalidCode =>
      'Código inválido o expirado. Por favor, inténtalo de nuevo.';

  @override
  String get markAllRead => 'Marcar todo como leído';

  @override
  String get noNotifications => 'Aún no hay notificaciones';

  @override
  String get noNotificationsDesc =>
      'Cuando recibas asignaciones de tareas y recordatorios, aparecerán aquí.';

  @override
  String get notifTaskAssignedTitle => '¡Nuevas tareas asignadas!';

  @override
  String notifTaskAssignedBody(int count) {
    return 'Tienes $count nuevas tareas esperándote hoy. ¡Hagamos crecer tu negocio!';
  }

  @override
  String get notifTaskReminderTitle => '¡No olvides tus tareas!';

  @override
  String notifTaskReminderBody(int count) {
    return 'Aún tienes $count tareas incompletas hoy. ¡Termínalas antes de que acabe el día!';
  }

  @override
  String get notifDailySummaryTitle => 'Resumen Diario';

  @override
  String notifDailySummaryBody(Object completed, Object total) {
    return 'Completaste $completed de $total tareas hoy. ¡Sigue así!';
  }

  @override
  String get justNow => 'ahora';

  @override
  String get proPlanPrice => '€19,99/mes';

  @override
  String get proPlanDesc =>
      'Acceso completo a todas las herramientas que hacen crecer tu negocio.';

  @override
  String get featureFreeAnalysis =>
      'Análisis empresarial 360° en 7 dimensiones (Q1–Q7)';

  @override
  String get featureFreeTopTasks =>
      'Top 30 tareas estratégicas de visibilidad y reputación';

  @override
  String get featureFreeBasicDashboard => 'Panel básico';

  @override
  String get featureFreeWhatsApp => 'App + WhatsApp (sin notificaciones)';

  @override
  String get featureFreeAiMessages => 'Modelo IA entrenado — 5 mensajes/día';

  @override
  String get featureProAnalysis =>
      'Análisis empresarial interactivo 360° (Q1–Q7)';

  @override
  String get featureProFullLibrary =>
      'Biblioteca completa de tareas — ventas, beneficios, fidelidad y más';

  @override
  String get featureProDashboard => 'Panel visual y analíticas en tiempo real';

  @override
  String get featureProWhatsApp =>
      'Coach de crecimiento WhatsApp — recordatorios diarios e informes semanales';

  @override
  String get featureProUpdatedContent =>
      'Contenido actualizado constantemente — nuevas tácticas cada mes';

  @override
  String get featureProIdTracking =>
      'Seguimiento por ID — ve cuánto gana cada paso';

  @override
  String get errorNetwork =>
      'Sin conexión a internet. Por favor, comprueba tu red.';

  @override
  String get errorRateLimit =>
      'Demasiadas solicitudes. Por favor, espera un momento.';

  @override
  String get errorGeneric => 'Algo salió mal. Por favor, inténtalo de nuevo.';

  @override
  String get monthlyPerformance => 'Rendimiento mensual';

  @override
  String get yearlyPerformance => 'Rendimiento anual';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get thisYear => 'Este año';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get purchaseSuccess =>
      '¡Bienvenido a Pro! Disfruta tus nuevas funciones.';

  @override
  String get purchaseCancelled => 'Compra cancelada.';

  @override
  String get restoreSuccess => 'Compras restauradas con éxito.';

  @override
  String get restoreNoPurchases => 'No se encontraron compras anteriores.';

  @override
  String get buyNow => 'Mejorar';

  @override
  String pointsEarned(int points) {
    return '+$points puntos!';
  }

  @override
  String get taskCompletedMsg =>
      '¡Genial! Completaste la tarea. No olvides hacer seguimiento de los resultados.';

  @override
  String get ok => 'Aceptar';

  @override
  String get resetLinkSent =>
      'Se ha enviado un enlace para restablecer tu contraseña. Por favor, revisa tu correo.';

  @override
  String get privacyPolicyTitle => 'Política de Privacidad';

  @override
  String get privacyPolicyUpdated => 'Última actualización: 8 de abril de 2026';

  @override
  String get privacySection1Title =>
      '1. Declaración de Responsabilidad de Datos';

  @override
  String get privacySection1Body =>
      'Los datos que compartes al usar mis servicios se procesan de acuerdo con el RGPD y los estándares internacionales de protección de datos. La seguridad de tus datos se mantiene al más alto nivel mediante medidas técnicas y administrativas.';

  @override
  String get privacySection2Title => '2. Categorías de Datos Recopilados';

  @override
  String get privacySection2Body =>
      '• Identidad e Información de Contacto: Tu nombre, apellido y correo electrónico proporcionados durante el registro.\n\n• Datos de Suscripción y Financieros: Historial de transacciones y registros de verificación de pagos. Estos procesos están asegurados por la infraestructura de RevenueCat.\n\n• Datos de Diagnóstico Técnico: Registros de errores y estadísticas dentro de la app para detectar fallas y mejorar la experiencia del usuario.';

  @override
  String get privacySection3Title => '3. Finalidades del Tratamiento de Datos';

  @override
  String get privacySection3Body =>
      '• Prestación del Servicio: Gestión de tu cuenta de usuario personalizada y activación de funciones de la app.\n\n• Gestión de Pagos y Derechos: Verificación de procesos de suscripción y prevención de interrupciones del servicio.\n\n• Seguridad y Cumplimiento: Protección de la plataforma contra usos indebidos y cumplimiento legal.';

  @override
  String get privacySection4Title => '4. Compartición de Datos con Terceros';

  @override
  String get privacySection4Body =>
      'Nunca vendo ni comercializo tus datos personales. Tus datos solo se comparten con los siguientes proveedores de confianza:\n\n• Google Cloud & Firebase: Para almacenamiento seguro y autenticación.\n\n• RevenueCat: Para la infraestructura técnica del sistema de suscripción y verificaciones de pago.';

  @override
  String get privacySection5Title => '5. Seguridad y Retención de Datos';

  @override
  String get privacySection5Body =>
      'Tus datos están protegidos durante la transmisión mediante cifrado SSL/TLS. Tus datos se almacenan de forma segura mientras tu cuenta esté activa. Si eliminas tu cuenta, todos tus datos personales serán destruidos permanentemente.';

  @override
  String get privacySection6Title =>
      '6. Derechos del Usuario y Eliminación de Datos';

  @override
  String get privacySection6Body =>
      'Tienes los siguientes derechos sobre tus datos:\n\n• Derecho a saber si tus datos están siendo procesados\n• Derecho a solicitar la corrección de datos incorrectos o incompletos\n• Derecho a solicitar la eliminación o anonimización de tus datos\n\nPuedes eliminar permanentemente tu cuenta y todos los datos asociados desde la sección de Ajustes en la app.';

  @override
  String get privacySection7Title => '7. Contacto';

  @override
  String get privacySection7Body =>
      'Para más información sobre esta política de privacidad o para ejercer tus derechos:\n\n• Correo: info@salesgrowthsteps.com\n• Soporte en la app: Ajustes → Soporte';

  @override
  String get premiumContent => 'Contenido Premium';

  @override
  String get premiumContentDesc =>
      'Esta función es solo para miembros Premium. Únete para profundizar en tus análisis.';

  @override
  String get premiumBuyNow => 'Obtener Premium';
}
