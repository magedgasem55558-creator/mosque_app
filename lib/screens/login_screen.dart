import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('saved_email') ?? "";
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  Future<void> _handleRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text.trim());
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.setBool('remember_me', false);
    }
  }

  // دالة تحويل أخطاء Firebase إلى رسائل عربية واضحة
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'invalid-email':
      case 'invalid-credential':
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة";
      case 'wrong-password':
        return "كلمة المرور غير صحيحة";
      case 'user-disabled':
        return "تم تعطيل هذا الحساب من قبل الإدارة";
      case 'too-many-requests':
        return "تم حظر المحاولات مؤقتاً بسبب التكرار الخاطئ، حاول لاحقاً";
      case 'network-request-failed':
        return "تأكد من اتصالك بالإنترنت واعد المحاولة";
      case 'channel-error':
        return "يرجى ملء جميع الحقول المطلوبة";
      default:
        return "حدث خطأ غير متوقع: ${e.message ?? e.code}";
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // التحقق المحلي قبل الاتصال بـ Firebase
    if (email.isEmpty && password.isEmpty) {
      _showErrorSnackBar("يرجى إدخال البريد الإلكتروني وكلمة المرور");
      return;
    }
    if (email.isEmpty) {
      _showErrorSnackBar("يرجى إدخال البريد الإلكتروني");
      return;
    }
    if (password.isEmpty) {
      _showErrorSnackBar("يرجى إدخال كلمة المرور");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _handleRememberMe();

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      debugPrint("Login Auth Error Code: ${e.code}");
      if (mounted) {
        _showErrorSnackBar(_getAuthErrorMessage(e));
      }
    } catch (e) {
      debugPrint("Login General Error: $e");
      if (mounted) {
        _showErrorSnackBar("حدث خطأ أثناء الاتصال بالخادم");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1590076215667-873d47343e06?q=80&w=2070',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "دخول أولياء الأمور",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    _emailController,
                    "البريد الإلكتروني",
                    Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    _passwordController,
                    "كلمة المرور",
                    Icons.lock,
                    obscure: true,
                  ),
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white70),
                    child: CheckboxListTile(
                      title: const Text(
                        "تذكرني",
                        style: TextStyle(color: Colors.white70),
                      ),
                      value: _rememberMe,
                      activeColor: Colors.tealAccent,
                      checkColor: Colors.black,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() => _rememberMe = value ?? false);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.tealAccent)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent[700],
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: _login,
                          child: const Text(
                            "دخول",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
