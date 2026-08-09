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
      if (mounted) _showErrorSnackBar(_getAuthErrorMessage(e));
    } catch (e) {
      debugPrint("Login General Error: $e");
      if (mounted) _showErrorSnackBar("حدث خطأ أثناء الاتصال بالخادم");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
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
      extendBodyBehindAppBar: true,
      body: Container(
        // الخلفية الرسمية
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32), // أخضر غامق
              Color(0xFF42A5F5), // أزرق
              Color(0xFFF5F5F5), // رمادي فاتح
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // شريط عنوان أبيض أنيق
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Text(
                      "دخول أولياء الأمور",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // حقل البريد الإلكتروني
                  _buildTextField(
                    _emailController,
                    "البريد الإلكتروني",
                    Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  // حقل كلمة المرور
                  _buildTextField(
                    _passwordController,
                    "كلمة المرور",
                    Icons.lock,
                    obscure: true,
                  ),
                  const SizedBox(height: 10),

                  // خيار "تذكرني"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() => _rememberMe = value ?? false);
                          },
                          activeColor: Colors.teal,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "تذكرني",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // زر الدخول
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.teal)
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _login,
                            child: const Text(
                              "دخول",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal.shade600),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
        ),
      ),
    );
  }
}
