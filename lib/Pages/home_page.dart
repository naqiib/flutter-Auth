import 'package:flutter/material.dart';
import 'package:flutter_auth/Pages/login_page.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/shared_painters.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

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
            // Background shapes
            Positioned(left: 15, top: 200, child: CustomPaint(size: const Size(16, 16),
                painter: ShapePainter(type: 'plus', color: Colors.white.withOpacity(0.15)))),
            Positioned(right: 25, top: 300, child: CustomPaint(size: const Size(12, 12),
                painter: ShapePainter(type: 'triangle_up', color: const Color(0xFFec4899).withOpacity(0.4)))),
            Positioned(left: 30, bottom: 200, child: CustomPaint(size: const Size(14, 14),
                painter: ShapePainter(type: 'x', color: const Color(0xFFfbbf24).withOpacity(0.3)))),
            Positioned(right: 20, bottom: 300, child: Container(width: 8, height: 8,
                decoration: BoxDecoration(color: const Color(0xFFec4899).withOpacity(0.5),
                    shape: BoxShape.circle))),
            Positioned(left: -30, top: 100, child: SizedBox(width: 120, height: 120,
                child: CustomPaint(painter: ConcentricCirclesPainter()))),
            Positioned(right: -30, bottom: 150, child: SizedBox(width: 120, height: 120,
                child: CustomPaint(painter: ConcentricCirclesPainter()))),

            SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dashboard',
                          style: TextStyle(color: Colors.white, fontSize: 22,
                              fontWeight: FontWeight.w800, letterSpacing: 1)),
                        IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                  (route) => false);
                            }
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: const Icon(Icons.logout_rounded,
                                color: Color(0xFFe91e8c), size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Profile card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3d1a78), Color(0xFF5b2d9e)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF7c3aed).withOpacity(0.4),
                              blurRadius: 20, offset: const Offset(0, 8))
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60, height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFe91e8c),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(
                                  color: const Color(0xFFe91e8c).withOpacity(0.4),
                                  blurRadius: 12, offset: const Offset(0, 4))],
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Welcome back!',
                                  style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(user?.email ?? 'User',
                                  style: const TextStyle(color: Colors.white,
                                      fontSize: 14, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Active',
                              style: TextStyle(color: Colors.greenAccent,
                                  fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Stats row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _statCard('Posts', '24', Icons.article_outlined),
                        const SizedBox(width: 12),
                        _statCard('Followers', '1.2k', Icons.people_outline),
                        const SizedBox(width: 12),
                        _statCard('Likes', '340', Icons.favorite_outline),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Recent Activity label
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Recent Activity',
                        style: TextStyle(color: Colors.white, fontSize: 16,
                            fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Activity list
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _activityItem(Icons.login_rounded, 'Signed in successfully',
                            'Just now', const Color(0xFF7c3aed)),
                        _activityItem(Icons.verified_user_outlined, 'Account verified',
                            '2 min ago', const Color(0xFFe91e8c)),
                        _activityItem(Icons.settings_outlined, 'Profile setup pending',
                            '5 min ago', const Color(0xFFfbbf24)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFe91e8c), size: 22),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white,
                fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(
                color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(IconData icon, String title, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
              style: const TextStyle(color: Colors.white,
                  fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}