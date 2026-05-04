import 'package:flutter/material.dart';
import 'package:firebase/ui/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/ui/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ✅ fungsi login (sama persis)
  Future<void> login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login gagal";
      if (e.code == 'user-not-found')
        message = "User tidak ditemukan";
      else if (e.code == 'wrong-password')
        message = "Password salah";
      else if (e.code == 'invalid-email')
        message = "Format email tidak valid";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecor(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.white54, size: 20),
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                        colors: isDark
                            ? [const Color(0xFF1565C0), const Color(0xFF0288D1)]
                            : [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.15),
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Masuk ke akun Anda",
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

                        TextField(
                          controller: passwordController,
                          obscureText: isObscure,
                          style: const TextStyle(color: Colors.white),
                          decoration:
                              _inputDecor(
                                context,
                                "Password",
                                Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: IconButton(
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

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            // Ganti fungsi onPressed lupa password di login_screen.dart
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  final resetController =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: const Text("Reset Password"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Masukkan email Anda untuk menerima tautan reset password.",
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: resetController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            labelText: "Email",
                                            prefixIcon: Icon(
                                              Icons.email_outlined,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Batal"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final email = resetController.text
                                              .trim();
                                          if (email.isEmpty) return;
                                          try {
                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                  email: email,
                                                );
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Tautan reset password telah dikirim ke email Anda",
                                                ),
                                              ),
                                            );
                                          } on FirebaseAuthException catch (e) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  e.code == 'user-not-found'
                                                      ? "Email tidak terdaftar"
                                                      : "Gagal mengirim email reset",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          "Kirim",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Lupa Password?",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : login,
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
                                    "Masuk",
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterScreen()),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Belum punya akun? ",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const TextSpan(
                            text: "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "© 2026 Mahasiswa App",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 11,
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
}
