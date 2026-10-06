import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070C),
      body: SafeArea(
        child: Stack(
          children: [
            // Background glow
            Positioned(
              top: -120,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6C3BFF).withOpacity(0.16),
                ),
              ),
            ),

            Positioned(
              bottom: -140,
              left: -100,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withOpacity(0.10),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 35),

                  // Logo / Shield
                  Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFF4F46E5),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.45),
                          blurRadius: 35,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      size: 58,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 700.ms)
                      .scale(
                    begin: const Offset(0.75, 0.75),
                    end: const Offset(1, 1),
                    duration: 700.ms,
                    curve: Curves.easeOutBack,
                  ),

                  const SizedBox(height: 24),

                  // Brand
                  const Text(
                    'SpamX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 250.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 7),

                  Text(
                    'AI-POWERED MESSAGE SECURITY',
                    style: TextStyle(
                      color: const Color(0xFFA78BFA),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms),

                  const SizedBox(height: 34),

                  // Main heading
                  const Text(
                    'Know what’s hiding\nbehind the message.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 700.ms)
                      .slideY(begin: 0.15, end: 0),

                  const SizedBox(height: 12),

                  Text(
                    'SpamX uses machine learning to analyze messages, '
                        'detect potential spam and help you understand what '
                        'you are dealing with.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.58),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 650.ms, duration: 700.ms),

                  const SizedBox(height: 28),

                  // Feature cards
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _FeatureCard(
                            icon: Icons.radar_rounded,
                            title: 'Smart Detection',
                            description:
                            'Analyze messages and identify whether they are safe or spam.',
                          )
                              .animate()
                              .fadeIn(delay: 750.ms, duration: 500.ms)
                              .slideX(begin: -0.08, end: 0),

                          const SizedBox(height: 10),

                          _FeatureCard(
                            icon: Icons.psychology_rounded,
                            title: 'Machine Learning',
                            description:
                            'A trained ML model looks for patterns commonly found in spam.',
                          )
                              .animate()
                              .fadeIn(delay: 850.ms, duration: 500.ms)
                              .slideX(begin: 0.08, end: 0),

                          const SizedBox(height: 10),

                          _FeatureCard(
                            icon: Icons.category_rounded,
                            title: 'Threat Categories',
                            description:
                            'Understand whether a message looks like a scam, phishing attempt, promotion or financial threat.',
                          )
                              .animate()
                              .fadeIn(delay: 950.ms, duration: 500.ms)
                              .slideX(begin: -0.08, end: 0),

                          const SizedBox(height: 10),

                          _FeatureCard(
                            icon: Icons.analytics_rounded,
                            title: 'Activity & Insights',
                            description:
                            'Keep track of your recent analyses and see your spam detection activity.',
                          )
                              .animate()
                              .fadeIn(delay: 1050.ms, duration: 500.ms)
                              .slideX(begin: 0.08, end: 0),

                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),

                  // Get Started button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8B5CF6),
                              Color(0xFF5B5BF7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withOpacity(0.30),
                              blurRadius: 22,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/home',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 21,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 700.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111119),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFA78BFA),
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.48),
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}