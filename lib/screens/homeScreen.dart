import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CareerGuidanceApp extends StatefulWidget {
  const CareerGuidanceApp({super.key});

  @override
  _CareerGuidanceAppState createState() => _CareerGuidanceAppState();
}

class _CareerGuidanceAppState extends State<CareerGuidanceApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _signInAsGuest();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _signInAsGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      setState(() {
        isAuthenticated = true;
      });
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isAuthenticated
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          _buildAppBar(constraints),
                          _buildHeroSection(context, constraints),
                          _buildToolsSection(constraints),
                          const SizedBox(height: 60),
                          const Divider(),
                          const SizedBox(height: 60),
                          const Text('Git good'),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAppBar(BoxConstraints constraints) {
    bool isMobile = constraints.maxWidth < 800;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: isMobile
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLogo(),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        // Show drawer or bottom sheet for navigation
                      },
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                _buildLogo(),
                const Spacer(),
                _buildNavItem('Industry Insights'),
                _buildNavItem('Career Growth Tools'),
                _buildNavItem('Community'),
                const CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 20,
                ),
              ],
            ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('LOGO'),
    );
  }

  Widget _buildNavItem(String text) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, BoxConstraints constraints) {
    bool isMobile = constraints.maxWidth < 800;

    return Container(
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(24.0),
      child: isMobile
          ? Column(
              children: [
                _buildHeroText(),
                const SizedBox(height: 24),
                _buildHeroAnimation(),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildHeroText()),
                Expanded(child: _buildHeroAnimation()),
              ],
            ),
    );
  }

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'ELEVATE YOUR CAREER\nWITH AI-POWERED\nGUIDANCE',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Advance your career with personalized guidance, interview prep,\nand AI-powered tools for job success.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeroAnimation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.cyan.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Lottie.asset(
        'asseets/images/Animation - 1740207667762.json',
        height: 300,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildToolsSection(BoxConstraints constraints) {
    bool isMobile = constraints.maxWidth < 800;

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text(
            'POWERFUL TOOLS FOR YOUR SUCCESS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Everything you need to build a successful career',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildToolCard(
                'Interview Preparation',
                'Practice with role-specific questions and get instant feedback to improve performance',
                () {},
                maxWidth: isMobile ? constraints.maxWidth - 48 : 200,
              ),
              _buildToolCard(
                'Job Search',
                'Explore job opportunities with personalized job matching and career guidance',
                () {
                  context.push('/job');
                },
                maxWidth: isMobile ? constraints.maxWidth - 48 : 200,
              ),
              _buildToolCard(
                'Smart Resume Creation',
                'Generate ATS-optimized resumes with AI assistance',
                () {
                  context.push('/resume');
                },
                maxWidth: isMobile ? constraints.maxWidth - 48 : 200,
              ),
              _buildToolCard(
                'Expert-Led Community',
                'Connect with professionals and peers, get your questions answered, and get guidance from industry experts',
                () {},
                maxWidth: isMobile ? constraints.maxWidth - 48 : 200,
              ),
              _buildToolCard(
                'RoadMap Builder',
                'Create a personalized career roadmap with actionable steps and milestones',
                () {
                  context.push('/roadmap');
                },
                maxWidth: isMobile ? constraints.maxWidth - 48 : 200,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    String title,
    String description,
    VoidCallback ontap, {
    required double maxWidth,
  }) {
    ValueNotifier<bool> isHovered = ValueNotifier(false);

    return InkWell(
      onTap: ontap,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: ValueListenableBuilder<bool>(
          valueListenable: isHovered,
          builder: (context, hovering, child) {
            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              tween: Tween<double>(begin: 1, end: hovering ? 1.05 : 1),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: maxWidth,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: hovering
                          ? [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
