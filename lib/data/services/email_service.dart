import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  EmailService._();

  static const _host = String.fromEnvironment('SMTP_HOST', defaultValue: 'iam.gofast.cz');
  static const _port = int.fromEnvironment('SMTP_PORT', defaultValue: 465);
  static const _username = String.fromEnvironment('SMTP_USER', defaultValue: 'info@salesgrowthsteps.com');
  static const _password = String.fromEnvironment('SMTP_PASS');
  static const _from = String.fromEnvironment('SMTP_FROM', defaultValue: 'info@salesgrowthsteps.com');

  static _EmailTexts _texts(String locale) {
    switch (locale) {
      case 'de':
        return _EmailTexts(
          verifyTitle: 'E-Mail-Adresse bestätigen',
          verifyDesc: 'Verwenden Sie den folgenden Code, um Ihre E-Mail-Adresse zu bestätigen:',
          codeValid: 'Dieser Code ist 10 Minuten gültig.',
          spamNote: '⚠️ Falls Sie den Code nicht finden, überprüfen Sie Ihren Spam-Ordner.',
          doNotShare: 'Sales Growth Steps — Teilen Sie diesen Code mit niemandem.',
          verifySubject: 'Sales Growth Steps — Ihr Bestätigungscode: ',
          resetTitle: 'Passwort zurücksetzen',
          resetDesc: 'Verwenden Sie den folgenden Code, um Ihr Passwort zurückzusetzen:',
          notYou: '⚠️ Wenn Sie diese Aktion nicht gestartet haben, ignorieren Sie diese E-Mail.',
          resetSubject: 'Sales Growth Steps — Ihr Passwort-Reset-Code: ',
        );
      case 'es':
        return _EmailTexts(
          verifyTitle: 'Verifica tu correo electrónico',
          verifyDesc: 'Usa el siguiente código para verificar tu dirección de correo:',
          codeValid: 'Este código es válido por 10 minutos.',
          spamNote: '⚠️ Si no encuentras el código, revisa tu carpeta de spam.',
          doNotShare: 'Sales Growth Steps — No compartas este código con nadie.',
          verifySubject: 'Sales Growth Steps — Tu código de verificación: ',
          resetTitle: 'Restablecer contraseña',
          resetDesc: 'Usa el siguiente código para restablecer tu contraseña:',
          notYou: '⚠️ Si no iniciaste esta acción, ignora este correo.',
          resetSubject: 'Sales Growth Steps — Tu código de restablecimiento: ',
        );
      case 'cs':
        return _EmailTexts(
          verifyTitle: 'Ověřte svůj e-mail',
          verifyDesc: 'Pro ověření e-mailové adresy použijte následující kód:',
          codeValid: 'Tento kód je platný 10 minut.',
          spamNote: '⚠️ Pokud kód nenajdete, zkontrolujte složku se spamem.',
          doNotShare: 'Sales Growth Steps — Nesdílejte tento kód s nikým.',
          verifySubject: 'Sales Growth Steps — Váš ověřovací kód: ',
          resetTitle: 'Resetování hesla',
          resetDesc: 'Pro resetování hesla použijte následující kód:',
          notYou: '⚠️ Pokud jste tuto akci nespustili, ignorujte tento e-mail.',
          resetSubject: 'Sales Growth Steps — Váš kód pro reset hesla: ',
        );
      case 'en':
        return _EmailTexts(
          verifyTitle: 'Verify your email',
          verifyDesc: 'Use the following code to verify your email address:',
          codeValid: 'This code is valid for 10 minutes.',
          spamNote: '⚠️ If you can\'t find the code, check your spam folder.',
          doNotShare: 'Sales Growth Steps — Do not share this code with anyone.',
          verifySubject: 'Sales Growth Steps — Your verification code: ',
          resetTitle: 'Reset your password',
          resetDesc: 'Use the following code to reset your password:',
          notYou: '⚠️ If you did not initiate this, please ignore this email.',
          resetSubject: 'Sales Growth Steps — Your password reset code: ',
        );
      default: // tr
        return _EmailTexts(
          verifyTitle: 'E-posta adresinizi doğrulayın',
          verifyDesc: 'E-posta adresinizi doğrulamak için aşağıdaki kodu kullanın:',
          codeValid: 'Bu kod 10 dakika geçerlidir.',
          spamNote: '⚠️ Kodu bulamıyorsanız spam/önemsiz klasörünü kontrol edin.',
          doNotShare: 'Sales Growth Steps — Bu kodu kimseyle paylaşmayın.',
          verifySubject: 'Sales Growth Steps — Doğrulama Kodunuz: ',
          resetTitle: 'Şifrenizi sıfırlayın',
          resetDesc: 'Şifrenizi sıfırlamak için aşağıdaki kodu kullanın:',
          notYou: '⚠️ Bu işlemi siz başlatmadıysanız bu e-postayı dikkate almayın.',
          resetSubject: 'Sales Growth Steps — Şifre Sıfırlama Kodunuz: ',
        );
    }
  }

  static Future<void> sendVerificationCodeEmail({
    required String toEmail,
    required String code,
    String locale = 'tr',
  }) async {
    final t = _texts(locale);
    final htmlBody = '''
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
  <h2 style="color: #2F4FA3; text-align: center;">Sales Growth Steps</h2>
  <div style="background: #F5F7FB; border-radius: 12px; padding: 30px; margin: 20px 0; text-align: center;">
    <p style="color: #253354; font-size: 16px; margin-bottom: 24px;">${t.verifyDesc}</p>
    <div style="background: #2F4FA3; color: white; font-size: 36px; font-weight: bold; letter-spacing: 12px; padding: 20px 30px; border-radius: 12px; display: inline-block;">$code</div>
    <p style="color: #8A97AF; font-size: 13px; margin-top: 24px;">${t.codeValid}</p>
    <p style="color: #EF4444; font-size: 13px; margin-top: 8px;">${t.spamNote}</p>
  </div>
  <p style="text-align: center; color: #9CA3AF; font-size: 12px;">${t.doNotShare}</p>
</div>''';

    final smtpServer = SmtpServer(
      _host,
      port: _port,
      ssl: true,
      username: _username,
      password: _password,
    );

    final message = Message()
      ..from = Address(_from, 'Sales Growth Steps')
      ..recipients.add(toEmail)
      ..subject = '${t.verifySubject}$code'
      ..html = htmlBody;

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('[EmailService] Verification code sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      debugPrint('[EmailService] Verification mail error: $e');
      rethrow;
    }
  }

  static Future<void> sendPasswordResetCodeEmail({
    required String toEmail,
    required String code,
    String locale = 'tr',
  }) async {
    final t = _texts(locale);
    final htmlBody = '''
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
  <h2 style="color: #2F4FA3; text-align: center;">Sales Growth Steps</h2>
  <div style="background: #F5F7FB; border-radius: 12px; padding: 30px; margin: 20px 0; text-align: center;">
    <p style="color: #253354; font-size: 16px; margin-bottom: 24px;">${t.resetDesc}</p>
    <div style="background: #2F4FA3; color: white; font-size: 36px; font-weight: bold; letter-spacing: 12px; padding: 20px 30px; border-radius: 12px; display: inline-block;">$code</div>
    <p style="color: #8A97AF; font-size: 13px; margin-top: 24px;">${t.codeValid}</p>
    <p style="color: #EF4444; font-size: 13px; margin-top: 8px;">${t.notYou}</p>
  </div>
  <p style="text-align: center; color: #9CA3AF; font-size: 12px;">${t.doNotShare}</p>
</div>''';

    final smtpServer = SmtpServer(
      _host,
      port: _port,
      ssl: true,
      username: _username,
      password: _password,
    );

    final message = Message()
      ..from = Address(_from, 'Sales Growth Steps')
      ..recipients.add(toEmail)
      ..subject = '${t.resetSubject}$code'
      ..html = htmlBody;

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('[EmailService] Password reset code sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      debugPrint('[EmailService] Password reset mail error: $e');
      rethrow;
    }
  }

  static Future<void> sendContactEmail({
    required String fromEmail,
    required String subject,
    required String body,
  }) async {
    final htmlBody = '''
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
  <h2 style="color: #2F4FA3; text-align: center;">Sales Growth Steps - Contact</h2>
  <div style="background: #F5F7FB; border-radius: 12px; padding: 20px; margin: 20px 0;">
    <p><strong>From:</strong> $fromEmail</p>
    <p><strong>Subject:</strong> $subject</p>
    <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 16px 0;">
    <p>${body.replaceAll('\n', '<br>')}</p>
  </div>
  <p style="text-align: center; color: #9CA3AF; font-size: 13px;">This message was sent via Sales Growth Steps app.</p>
</div>''';

    final smtpServer = SmtpServer(
      _host,
      port: _port,
      ssl: true,
      username: _username,
      password: _password,
    );

    final message = Message()
      ..from = Address(_from, 'Sales Growth Steps')
      ..recipients.add(_from)
      ..subject = 'Sales Growth Steps Contact: $subject'
      ..html = htmlBody;

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('[EmailService] Mail gönderildi: ${sendReport.toString()}');
    } on MailerException catch (e) {
      debugPrint('[EmailService] Mail hatası: $e');
      for (final p in e.problems) {
        debugPrint('[EmailService] Problem: ${p.code} - ${p.msg}');
      }
      rethrow;
    }
  }
}

class _EmailTexts {
  final String verifyTitle;
  final String verifyDesc;
  final String codeValid;
  final String spamNote;
  final String doNotShare;
  final String verifySubject;
  final String resetTitle;
  final String resetDesc;
  final String notYou;
  final String resetSubject;

  const _EmailTexts({
    required this.verifyTitle,
    required this.verifyDesc,
    required this.codeValid,
    required this.spamNote,
    required this.doNotShare,
    required this.verifySubject,
    required this.resetTitle,
    required this.resetDesc,
    required this.notYou,
    required this.resetSubject,
  });
}
