import 'package:flutter/material.dart';
import 'package:flutter_auth/Pages/home_page.dart';

import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/shared_painters.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      await _authService.signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false);
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
            Positioned(left: 15, top: 300, child: CustomPaint(size: const Size(16, 16),
                painter: ShapePainter(type: 'plus', color: Colors.white.withOpacity(0.2)))),
            Positioned(right: 20, bottom: 200, child: CustomPaint(size: const Size(14, 14),
                painter: ShapePainter(type: 'plus', color: const Color(0xFFec4899).withOpacity(0.3)))),
            Positioned(right: 30, top: 150, child: Container(width: 8, height: 8,
                decoration: BoxDecoration(color: const Color(0xFFec4899).withOpacity(0.4),
                    shape: BoxShape.circle))),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.4),
                              blurRadius: 40, offset: const Offset(0, 20))
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(children: [_buildHeader(), _buildForm()]),
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
      height: 180, width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3d1a78), Color(0xFF5b2d9e)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(left: -40, bottom: -40, child: SizedBox(width: 160, height: 160,
              child: CustomPaint(painter: ConcentricCirclesPainter()))),
          Positioned(right: -40, top: -40, child: SizedBox(width: 160, height: 160,
              child: CustomPaint(painter: ConcentricCirclesPainter()))),
          Positioned(left: 20, top: 20, child: CustomPaint(size: const Size(14, 14),
              painter: ShapePainter(type: 'triangle_up', color: const Color(0xFFec4899)))),
          Positioned(right: 30, top: 30, child: CustomPaint(size: const Size(12, 12),
              painter: ShapePainter(type: 'triangle_down', color: const Color(0xFFec4899)))),
          Positioned(left: 40, bottom: 20, child: CustomPaint(size: const Size(14, 14),
              painter: ShapePainter(type: 'plus', color: Colors.white))),
          Positioned(right: 50, top: 60, child: CustomPaint(size: const Size(12, 12),
              painter: ShapePainter(type: 'plus', color: const Color(0xFFfbbf24)))),
          Positioned(left: 120, top: 40, child: CustomPaint(size: const Size(10, 10),
              painter: ShapePainter(type: 'x', color: const Color(0xFFfbbf24)))),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF7c3aed),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: const Color(0xFF7c3aed).withOpacity(0.5),
                    blurRadius: 20, offset: const Offset(0, 4))],
              ),
              child: const Text('JOIN US',
                style: TextStyle(color: Colors.white, fontSize: 24,
                    fontWeight: FontWeight.w800, letterSpacing: 4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text('CREATE ACCOUNT',
              style: TextStyle(color: Color(0xFF333333), fontSize: 15,
                  fontWeight: FontWeight.w700, letterSpacing: 2)),
            const SizedBox(height: 16),
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(_errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 10),
            ],
            buildPinkField(controller: _emailController, hint: 'Email',
              icon: Icons.email_outlined,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (!val.contains('@')) return 'Invalid email';
                return null;
              }),
            const SizedBox(height: 10),
            buildPinkField(controller: _passwordController, hint: 'Password',
              icon: Icons.lock_outline, obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70, size: 18),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (val.length < 6) return 'Min 6 characters';
                return null;
              }),
            const SizedBox(height: 10),
            buildPinkField(controller: _confirmController, hint: 'Confirm Password',
              icon: Icons.lock_outline, obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70, size: 18),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (val != _passwordController.text) return "Passwords don't match";
                return null;
              }),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 11)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Sign in',
                      style: TextStyle(color: Color(0xFFd63384), fontSize: 11,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150, height: 40,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
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
                    : const Text('Create Account',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}