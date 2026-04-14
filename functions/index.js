const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const nodemailer = require("nodemailer");

initializeApp();

function getTransporter() {
  return nodemailer.createTransport({
    host: process.env.SMTP_HOST || "iam.gofast.cz",
    port: 465,
    secure: true,
    auth: {
      user: process.env.SMTP_USER || "info@salesgrowthsteps.com",
      pass: process.env.SMTP_PASS,
    },
  });
}

function getEmailTexts(locale) {
  const texts = {
    tr: {
      subject: "Sales Growth Steps — Şifre Sıfırlama Kodunuz: ",
      title: "Şifrenizi sıfırlayın",
      desc: "Şifrenizi sıfırlamak için aşağıdaki kodu kullanın:",
      valid: "Bu kod 10 dakika geçerlidir.",
      notYou: "⚠️ Bu işlemi siz başlatmadıysanız bu e-postayı dikkate almayın.",
      doNotShare: "Sales Growth Steps — Bu kodu kimseyle paylaşmayın.",
    },
    en: {
      subject: "Sales Growth Steps — Your password reset code: ",
      title: "Reset your password",
      desc: "Use the following code to reset your password:",
      valid: "This code is valid for 10 minutes.",
      notYou: "⚠️ If you did not initiate this, please ignore this email.",
      doNotShare: "Sales Growth Steps — Do not share this code with anyone.",
    },
    de: {
      subject: "Sales Growth Steps — Ihr Passwort-Reset-Code: ",
      title: "Passwort zurücksetzen",
      desc: "Verwenden Sie den folgenden Code, um Ihr Passwort zurückzusetzen:",
      valid: "Dieser Code ist 10 Minuten gültig.",
      notYou: "⚠️ Wenn Sie diese Aktion nicht gestartet haben, ignorieren Sie diese E-Mail.",
      doNotShare: "Sales Growth Steps — Teilen Sie diesen Code mit niemandem.",
    },
    es: {
      subject: "Sales Growth Steps — Tu código de restablecimiento: ",
      title: "Restablecer contraseña",
      desc: "Usa el siguiente código para restablecer tu contraseña:",
      valid: "Este código es válido por 10 minutos.",
      notYou: "⚠️ Si no iniciaste esta acción, ignora este correo.",
      doNotShare: "Sales Growth Steps — No compartas este código con nadie.",
    },
    cs: {
      subject: "Sales Growth Steps — Váš kód pro reset hesla: ",
      title: "Resetování hesla",
      desc: "Pro resetování hesla použijte následující kód:",
      valid: "Tento kód je platný 10 minut.",
      notYou: "⚠️ Pokud jste tuto akci nespustili, ignorujte tento e-mail.",
      doNotShare: "Sales Growth Steps — Nesdílejte tento kód s nikým.",
    },
  };
  return texts[locale] || texts["tr"];
}

async function sendResetEmail(toEmail, code, locale = "tr") {
  const t = getEmailTexts(locale);
  const html = `
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
  <h2 style="color: #2F4FA3; text-align: center;">Sales Growth Steps</h2>
  <div style="background: #F5F7FB; border-radius: 12px; padding: 30px; margin: 20px 0; text-align: center;">
    <p style="color: #253354; font-size: 16px; margin-bottom: 24px;">${t.desc}</p>
    <div style="background: #2F4FA3; color: white; font-size: 36px; font-weight: bold; letter-spacing: 12px; padding: 20px 30px; border-radius: 12px; display: inline-block;">${code}</div>
    <p style="color: #8A97AF; font-size: 13px; margin-top: 24px;">${t.valid}</p>
    <p style="color: #EF4444; font-size: 13px; margin-top: 8px;">${t.notYou}</p>
  </div>
  <p style="text-align: center; color: #9CA3AF; font-size: 12px;">${t.doNotShare}</p>
</div>`;

  const transporter = getTransporter();
  await transporter.sendMail({
    from: `"Sales Growth Steps" <${process.env.SMTP_USER || "info@salesgrowthsteps.com"}>`,
    to: toEmail,
    subject: `${t.subject}${code}`,
    html,
  });
}

function getVerifyTexts(locale) {
  const texts = {
    tr: {
      subject: "Sales Growth Steps — Doğrulama Kodunuz: ",
      desc: "E-posta adresinizi doğrulamak için aşağıdaki kodu kullanın:",
      valid: "Bu kod 10 dakika geçerlidir.",
      spam: "⚠️ Kodu bulamıyorsanız spam/önemsiz klasörünü kontrol edin.",
      doNotShare: "Sales Growth Steps — Bu kodu kimseyle paylaşmayın.",
    },
    en: {
      subject: "Sales Growth Steps — Your verification code: ",
      desc: "Use the following code to verify your email address:",
      valid: "This code is valid for 10 minutes.",
      spam: "⚠️ If you can't find the code, check your spam folder.",
      doNotShare: "Sales Growth Steps — Do not share this code with anyone.",
    },
    de: {
      subject: "Sales Growth Steps — Ihr Bestätigungscode: ",
      desc: "Verwenden Sie den folgenden Code, um Ihre E-Mail-Adresse zu bestätigen:",
      valid: "Dieser Code ist 10 Minuten gültig.",
      spam: "⚠️ Falls Sie den Code nicht finden, überprüfen Sie Ihren Spam-Ordner.",
      doNotShare: "Sales Growth Steps — Teilen Sie diesen Code mit niemandem.",
    },
    es: {
      subject: "Sales Growth Steps — Tu código de verificación: ",
      desc: "Usa el siguiente código para verificar tu dirección de correo:",
      valid: "Este código es válido por 10 minutos.",
      spam: "⚠️ Si no encuentras el código, revisa tu carpeta de spam.",
      doNotShare: "Sales Growth Steps — No compartas este código con nadie.",
    },
    cs: {
      subject: "Sales Growth Steps — Váš ověřovací kód: ",
      desc: "Pro ověření e-mailové adresy použijte následující kód:",
      valid: "Tento kód je platný 10 minut.",
      spam: "⚠️ Pokud kód nenajdete, zkontrolujte složku se spamem.",
      doNotShare: "Sales Growth Steps — Nesdílejte tento kód s nikým.",
    },
  };
  return texts[locale] || texts["tr"];
}

async function sendVerificationEmail(toEmail, code, locale = "tr") {
  const t = getVerifyTexts(locale);
  const html = `
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
  <h2 style="color: #2F4FA3; text-align: center;">Sales Growth Steps</h2>
  <div style="background: #F5F7FB; border-radius: 12px; padding: 30px; margin: 20px 0; text-align: center;">
    <p style="color: #253354; font-size: 16px; margin-bottom: 24px;">${t.desc}</p>
    <div style="background: #2F4FA3; color: white; font-size: 36px; font-weight: bold; letter-spacing: 12px; padding: 20px 30px; border-radius: 12px; display: inline-block;">${code}</div>
    <p style="color: #8A97AF; font-size: 13px; margin-top: 24px;">${t.valid}</p>
    <p style="color: #EF4444; font-size: 13px; margin-top: 8px;">${t.spam}</p>
  </div>
  <p style="text-align: center; color: #9CA3AF; font-size: 12px;">${t.doNotShare}</p>
</div>`;

  const transporter = getTransporter();
  await transporter.sendMail({
    from: `"Sales Growth Steps" <${process.env.SMTP_USER || "info@salesgrowthsteps.com"}>`,
    to: toEmail,
    subject: `${t.subject}${code}`,
    html,
  });
}

/**
 * Sends email verification code to authenticated user.
 * Called with { locale }.
 */
exports.sendVerificationCode = onCall(
  { allowUnverifiedAppCheckToken: true },
  async (request) => {
    const { locale = "tr" } = request.data;

    // Kullanıcı authenticate olmuş olmalı
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Login required.");
    }

    const uid = request.auth.uid;
    const email = request.auth.token.email;
    if (!email) throw new HttpsError("invalid-argument", "No email on account.");

    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expires = Date.now() + 10 * 60 * 1000;

    const db = getFirestore();
    await db.collection("users").doc(uid).set(
      { verification_code: code, verification_code_expires: expires },
      { merge: true }
    );

    try {
      await sendVerificationEmail(email, code, locale);
    } catch (err) {
      console.error("SMTP error (verification):", err);
      throw new HttpsError("internal", "Failed to send email.");
    }

    return { success: true };
  }
);

/**
 * Generates a 6-digit reset code, saves it to Firestore, sends email via SMTP.
 * Called with { email, locale }.
 */
exports.sendPasswordResetCode = onCall(
  { allowUnverifiedAppCheckToken: true },
  async (request) => {
    const { email, locale = "tr" } = request.data;
    if (!email) throw new HttpsError("invalid-argument", "Missing email.");

    const auth = getAuth();

    // Firebase Auth üzerinden kullanıcı var mı kontrol et (Firestore query gerekmez)
    let userRecord;
    try {
      userRecord = await auth.getUserByEmail(email);
    } catch (err) {
      if (err.code === "auth/user-not-found") {
        throw new HttpsError("not-found", "user-not-found");
      }
      throw new HttpsError("internal", "Auth lookup failed.");
    }

    const db = getFirestore();

    // Hesap devre dışıysa işlemi durdur
    const userDoc = await db.collection("users").doc(userRecord.uid).get();
    if (userDoc.exists && userDoc.data()["is_active"] === false) {
      throw new HttpsError("permission-denied", "account_deactivated");
    }

    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expires = Date.now() + 10 * 60 * 1000; // 10 dakika

    // Kodu users/{uid} doc'una yaz (Admin SDK ile — security rules bypass)
    await db.collection("users").doc(userRecord.uid).set(
      { password_reset_code: code, password_reset_expires: expires },
      { merge: true }
    );

    try {
      await sendResetEmail(email, code, locale);
    } catch (err) {
      console.error("SMTP error:", err);
      throw new HttpsError("internal", "Failed to send email.");
    }

    return { success: true };
  }
);

/**
 * Verifies the reset code without changing the password.
 * Called with { email, code }.
 */
exports.verifyPasswordResetCode = onCall(
  { allowUnverifiedAppCheckToken: true },
  async (request) => {
    const { email, code } = request.data;
    if (!email || !code) throw new HttpsError("invalid-argument", "Missing fields.");

    const auth = getAuth();
    let userRecord;
    try {
      userRecord = await auth.getUserByEmail(email);
    } catch (err) {
      throw new HttpsError("not-found", "user-not-found");
    }

    const db = getFirestore();
    const doc = await db.collection("users").doc(userRecord.uid).get();
    if (!doc.exists) throw new HttpsError("not-found", "user-not-found");

    const data = doc.data();
    const storedCode = data["password_reset_code"];
    const expires = data["password_reset_expires"];

    if (!storedCode || !expires) throw new HttpsError("failed-precondition", "invalid-code");
    if (Date.now() > expires) throw new HttpsError("deadline-exceeded", "expired");
    if (storedCode !== String(code)) throw new HttpsError("invalid-argument", "invalid-code");

    return { valid: true };
  }
);

/**
 * Sends a contact/support email from authenticated user.
 * Called with { subject, body }.
 */
exports.sendContactMessage = onCall(
  { allowUnverifiedAppCheckToken: true },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Login required.");
    }

    const { subject, body } = request.data;
    if (!subject || !body) {
      throw new HttpsError("invalid-argument", "Missing subject or body.");
    }

    const fromEmail = request.auth.token.email || "unknown";
    const toEmail = process.env.SMTP_USER || "info@salesgrowthsteps.com";

    const html = `
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
  <h2 style="color: #2F4FA3; text-align: center;">Sales Growth Steps - Contact</h2>
  <div style="background: #F5F7FB; border-radius: 12px; padding: 20px; margin: 20px 0;">
    <p><strong>From:</strong> ${fromEmail}</p>
    <p><strong>Subject:</strong> ${subject}</p>
    <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 16px 0;">
    <p>${body.replace(/\n/g, "<br>")}</p>
  </div>
  <p style="text-align: center; color: #9CA3AF; font-size: 13px;">This message was sent via Sales Growth Steps app.</p>
</div>`;

    try {
      const transporter = getTransporter();
      await transporter.sendMail({
        from: `"Sales Growth Steps" <${toEmail}>`,
        to: toEmail,
        subject: `Sales Growth Steps Contact: ${subject}`,
        html,
      });
    } catch (err) {
      console.error("SMTP error (contact):", err);
      throw new HttpsError("internal", "Failed to send email.");
    }

    return { success: true };
  }
);

exports.resetPasswordWithCode = onCall(
  { allowUnverifiedAppCheckToken: true, invoker: "public" },
  async (request) => {
    const { email, code, newPassword } = request.data;

    if (!email || !code || !newPassword) {
      throw new HttpsError("invalid-argument", "Missing required fields.");
    }

    if (newPassword.length < 6) {
      throw new HttpsError("invalid-argument", "Password must be at least 6 characters.");
    }

    const auth = getAuth();
    let userRecord;
    try {
      userRecord = await auth.getUserByEmail(email);
    } catch (err) {
      throw new HttpsError("not-found", "user-not-found");
    }

    const db = getFirestore();
    const docRef = db.collection("users").doc(userRecord.uid);
    const doc = await docRef.get();
    if (!doc.exists) throw new HttpsError("not-found", "user-not-found");

    const data = doc.data();
    const storedCode = data["password_reset_code"];
    const expires = data["password_reset_expires"];

    if (!storedCode || !expires) {
      throw new HttpsError("failed-precondition", "invalid-code");
    }

    if (Date.now() > expires) {
      throw new HttpsError("deadline-exceeded", "expired");
    }

    if (storedCode !== String(code)) {
      console.error(`Code mismatch: stored=${storedCode} received=${code}`);
      throw new HttpsError("invalid-argument", "invalid-code");
    }

    await auth.updateUser(userRecord.uid, { password: newPassword });

    // Hesap devre dışıysa şifre sıfırlamaya izin verme
    if (data["is_active"] === false) {
      throw new HttpsError("permission-denied", "account_deactivated");
    }

    await docRef.update({
      password_reset_code: FieldValue.delete(),
      password_reset_expires: FieldValue.delete(),
    });

    return { success: true };
  }
);
