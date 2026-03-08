import 'package:flutter/material.dart';
import 'package:flutter_auth/Pages/signup_page.dart';
import 'package:flutter_auth/Pages/home_page.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/shared_painters.dart';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      await _authService.signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a0533), Color(0xFF2d1b69), Color(0xFF1a0533)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            ..._buildBgShapes(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          children: [
                            _buildHeader(),
                            _buildForm(),
                          ],
                        ),
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

  Widget _buildHeader() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3d1a78), Color(0xFF5b2d9e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(left: -40, bottom: -40,
              child: SizedBox(width: 160, height: 160,
                  child: CustomPaint(painter: ConcentricCirclesPainter()))),
          Positioned(right: -40, top: -40,
              child: SizedBox(width: 160, height: 160,
                  child: CustomPaint(painter: ConcentricCirclesPainter()))),
          ..._headerShapes(),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF7c3aed),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF7c3aed).withOpacity(0.5),
                      blurRadius: 20, offset: const Offset(0, 4))
                ],
              ),
              child: const Text('WELCOME',
                style: TextStyle(color: Colors.white, fontSize: 24,
                    fontWeight: FontWeight.w800, letterSpacing: 4)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _headerShapes() {
    final shapes = [
      ShapeData(left: 20, top: 20, type: 'triangle_up', color: const Color(0xFFec4899), size: 14),
      ShapeData(right: 30, top: 30, type: 'triangle_down', color: const Color(0xFFec4899), size: 12),
      ShapeData(left: 80, top: 15, type: 'circle', color: Colors.white, size: 8),
      ShapeData(right: 80, bottom: 30, type: 'circle', color: Colors.white, size: 6),
      ShapeData(left: 40, bottom: 20, type: 'plus', color: Colors.white, size: 14),
      ShapeData(right: 50, top: 60, type: 'plus', color: const Color(0xFFfbbf24), size: 12),
      ShapeData(left: 120, top: 40, type: 'x', color: const Color(0xFFfbbf24), size: 10),
      ShapeData(right: 120, bottom: 40, type: 'triangle_up', color: const Color(0xFFec4899), size: 10),
      ShapeData(left: 160, bottom: 15, type: 'lines', color: Colors.white, size: 30),
    ];
    return shapes.map((s) => Positioned(
      left: s.left, right: s.right, top: s.top, bottom: s.bottom,
      child: CustomPaint(size: Size(s.size, s.size),
          painter: ShapePainter(type: s.type, color: s.color)),
    )).toList();
  }

  Widget _buildForm() {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text('USER LOGIN',
              style: TextStyle(color: Color(0xFF333333), fontSize: 16,
                  fontWeight: FontWeight.w700, letterSpacing: 2)),
            const SizedBox(height: 20),
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 12),
            ],
            buildPinkField(controller: _emailController, hint: 'Username / Email',
              icon: Icons.person_outline,
              validator: (val) => (val == null || val.isEmpty) ? 'Required' : null),
            const SizedBox(height: 12),
            buildPinkField(
              controller: _passwordController, hint: 'Password',
              icon: Icons.lock_outline, obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70, size: 18),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignupPage())),
                  child: const Text('Become a member',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 11,
                        decoration: TextDecoration.underline)),
                ),
                const Text('Forgot password?',
                  style: TextStyle(color: Color(0xFF888888), fontSize: 11,
                      decoration: TextDecoration.underline)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 130, height: 40,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFe91e8c),
                  foregroundColor: Colors.white, elevation: 6,
                  shadowColor: const Color(0xFFe91e8c).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Sign in',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBgShapes() {
    return [
      Positioned(left: 20, top: 100, child: _floatingDot(const Color(0xFF7c3aed).withOpacity(0.3), 8, 0)),
      Positioned(right: 30, top: 200, child: _floatingDot(const Color(0xFFec4899).withOpacity(0.4), 6, 1)),
      Positioned(left: 15, top: 300, child: CustomPaint(size: const Size(16, 16),
          painter: ShapePainter(type: 'plus', color: Colors.white.withOpacity(0.2)))),
      Positioned(right: 20, bottom: 250, child: CustomPaint(size: const Size(14, 14),
          painter: ShapePainter(type: 'plus', color: const Color(0xFFec4899).withOpacity(0.3)))),
      Positioned(right: 15, top: 350, child: CustomPaint(size: const Size(12, 12),
          painter: ShapePainter(type: 'triangle_down', color: const Color(0xFFec4899).withOpacity(0.5)))),
      Positioned(left: 10, bottom: 200, child: Container(width: 60, height: 60,
          decoration: BoxDecoration(shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5)))),
    ];
  }

  Widget _floatingDot(Color color, double size, int delay) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, __) {
        final offset = math.sin((_floatController.value + delay * 0.3) * math.pi) * 8;
        return Transform.translate(
          offset: Offset(0, offset),
          child: Container(width: size, height: size,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        );
      },
    );
  }
}