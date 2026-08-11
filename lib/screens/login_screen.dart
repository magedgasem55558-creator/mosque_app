import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // تحميل البريد المحفوظ
  // ============================================================

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _emailController.text =
          prefs.getString('saved_email') ?? '';

      _rememberMe =
          prefs.getBool('remember_me') ?? false;
    });
  }

  // ============================================================
  // حفظ خيار تذكرني
  // ============================================================

  Future<void> _handleRememberMe() async {
    final prefs = await SharedPreferences.getInstance();

    if (_rememberMe) {
      await prefs.setString(
        'saved_email',
        _emailController.text.trim(),
      );

      await prefs.setBool(
        'remember_me',
        true,
      );
    } else {
      await prefs.remove('saved_email');

      await prefs.setBool(
        'remember_me',
        false,
      );
    }
  }

  // ============================================================
  // رسائل أخطاء Firebase
  // ============================================================

  String _getAuthErrorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'user-not-found':
      case 'invalid-email':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';

      case 'user-disabled':
        return 'تم تعطيل هذا الحساب من قبل الإدارة';

      case 'too-many-requests':
        return 'تم حظر المحاولات مؤقتاً، حاول لاحقاً';

      case 'network-request-failed':
        return 'تأكد من اتصالك بالإنترنت وأعد المحاولة';

      case 'channel-error':
        return 'يرجى ملء جميع الحقول المطلوبة';

      default:
        return 'حدث خطأ غير متوقع';
    }
  }

  // ============================================================
  // تسجيل الدخول
  // ============================================================

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      _showErrorSnackBar(
        'يرجى إدخال البريد الإلكتروني وكلمة المرور',
      );
      return;
    }

    if (email.isEmpty) {
      _showErrorSnackBar(
        'يرجى إدخال البريد الإلكتروني',
      );
      return;
    }

    if (password.isEmpty) {
      _showErrorSnackBar(
        'يرجى إدخال كلمة المرور',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ========================================================
      // تسجيل الدخول إلى Firebase
      // ========================================================

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ========================================================
      // حفظ FCM Token بعد نجاح تسجيل الدخول
      // ========================================================
      //
      // مهم:
      // NotificationService يتم تشغيله في main.dart
      // قبل تسجيل الدخول، لذلك currentUser يكون null.
      //
      // بعد تسجيل الدخول أصبح لدينا المستخدم،
      // لذلك نحفظ الـ FCM Token الآن داخل:
      //
      // parents/{uid}/fcmToken
      //
      // ========================================================

      await NotificationService.saveCurrentToken();

      // ========================================================
      // حفظ خيار تذكرني
      // ========================================================

      await _handleRememberMe();

      // ========================================================
      // الرجوع إلى الصفحة السابقة
      // ========================================================

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Login Auth Error Code: ${e.code}',
      );

      if (mounted) {
        _showErrorSnackBar(
          _getAuthErrorMessage(e),
        );
      }
    } catch (e) {
      debugPrint(
        'Login General Error: $e',
      );

      if (mounted) {
        _showErrorSnackBar(
          'حدث خطأ أثناء الاتصال بالخادم',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // Snackbar
  // ============================================================

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFC62828),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8F6),
        body: Stack(
          children: [
            // ====================================================
            // الخلفية
            // ====================================================

            Positioned(
              top: -170,
              left: -100,
              child: _buildBackgroundCircle(
                size: 430,
                color: const Color(0xFF0B5D3B),
              ),
            ),

            Positioned(
              top: -100,
              right: -150,
              child: _buildBackgroundCircle(
                size: 350,
                color: const Color(0xFF147A52),
              ),
            ),

            Positioned(
              bottom: -170,
              right: -100,
              child: _buildBackgroundCircle(
                size: 400,
                color: const Color(0xFFE8C56A),
              ),
            ),

            // ====================================================
            // المحتوى
            // ====================================================

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 30,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          _buildTopBrand(),

                          const SizedBox(height: 25),

                          _buildLoginCard(),

                          const SizedBox(height: 24),

                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // دوائر الخلفية
  // ============================================================

  Widget _buildBackgroundCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.08),
      ),
    );
  }

  // ============================================================
  // الشعار والعنوان العلوي
  // ============================================================

  Widget _buildTopBrand() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B6B43),
                  Color(0xFF063D29),
                ],
              ),
            ),
            child: const Icon(
              Icons.mosque_rounded,
              color: Color(0xFFE8C56A),
              size: 43,
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'مرحباً بك',
          style: TextStyle(
            color: Color(0xFF123D2C),
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'سجّل دخولك للوصول إلى حسابك',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 13),

        Container(
          width: 55,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFFD1A83C),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // بطاقة تسجيل الدخول
  // ============================================================

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان البطاقة
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.lock_person_rounded,
                  color: Color(0xFF087046),
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      color: Color(0xFF17231E),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'أدخل بيانات حسابك',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          // البريد الإلكتروني
          _buildTextField(
            controller: _emailController,
            label: 'البريد الإلكتروني',
            hint: 'example@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 15),

          // كلمة المرور
          _buildTextField(
            controller: _passwordController,
            label: 'كلمة المرور',
            hint: 'أدخل كلمة المرور',
            icon: Icons.lock_outline_rounded,
            obscure: _obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword =
                      !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade500,
              ),
            ),
          ),

          const SizedBox(height: 13),

          // تذكرني
          Row(
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe =
                          value ?? false;
                    });
                  },
                  activeColor:
                      const Color(0xFF087046),
                  checkColor: Colors.white,
                  side: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(6),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              const Text(
                'تذكرني',
                style: TextStyle(
                  color: Color(0xFF555C58),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // زر الدخول
          _buildLoginButton(),
        ],
      ),
    );
  }

  // ============================================================
  // حقل الإدخال
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType =
        TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textDirection: TextDirection.rtl,
      style: const TextStyle(
        color: Color(0xFF202623),
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: const Color(0xFF087046),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior:
            FloatingLabelBehavior.auto,

        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
        ),

        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
        ),

        prefixIcon: Container(
          margin: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF5F0),
            borderRadius:
                BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF087046),
            size: 21,
          ),
        ),

        suffixIcon: suffixIcon,

        filled: true,
        fillColor: const Color(0xFFF8FAF9),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 17,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(17),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(17),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: Color(0xFF087046),
            width: 1.7,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // زر تسجيل الدخول
  // ============================================================

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Color(0xFF087046),
              Color(0xFF06482F),
            ],
          ),
          borderRadius:
              BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFF087046)
                      .withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed:
              _isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent,
            disabledBackgroundColor:
                Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(17),
            ),
          ),
          child: AnimatedSwitcher(
            duration:
                const Duration(milliseconds: 250),
            child: _isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 25,
                    height: 25,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    key: ValueKey('login'),
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        'دخول إلى الحساب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // أسفل الصفحة
  // ============================================================

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 35,
              height: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(width: 10),
            Text(
              'أهلاً وسهلاً بك',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 35,
              height: 1,
              color: Colors.grey.shade300,
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security_rounded,
              size: 15,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 5),
            Text(
              'بياناتك محمية وآمنة',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
