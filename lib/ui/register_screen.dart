import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isObscure = true;
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ✅ fungsi register (sama persis)
  Future<void> register() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Register berhasil, silakan login")),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Register gagal";
      if (e.code == 'email-already-in-use')
        message = "Email sudah digunakan";
      else if (e.code == 'weak-password')
        message = "Password minimal 6 karakter";
      else if (e.code == 'invalid-email')
        message = "Format email tidak valid";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white70 : Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F1B2D), const Color(0xFF1A3A5C)]
                : [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 🔵 Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [cs.primary, const Color(0xFF0288D1)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withOpacity(0.4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Buat Akun Baru",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Daftarkan diri Anda",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 📦 Form card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        // Email
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecor(
                            context,
                            "Email",
                            Icons.email_outlined,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: isObscure,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecor(
                            context,
                            "Password",
                            Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white54,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => isObscure = !isObscure),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? cs.primary
                                  : Colors.white,
                              foregroundColor: isDark
                                  ? Colors.white
                                  : cs.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: isDark ? Colors.white : cs.primary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Daftar",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : cs.primary,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Sudah punya akun? ",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const TextSpan(
                            text: "Masuk",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecor(
    BuildContext context,
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.white54, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
    );
  }
}
