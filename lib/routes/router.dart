import 'package:career/screens/Resume/basicInfo.dart';
import 'package:career/screens/homeScreen.dart';
import 'package:career/screens/Resume/resumeBuilder.dart';
import 'package:career/screens/roadmap/roadmapScreen.dart';
import 'package:career/screens/search/jobSearch.dart';
import 'package:go_router/go_router.dart';

class AppRounter {
  static final GoRouter router = GoRouter(initialLocation: '/home', routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => CareerGuidanceApp(),
    ),
    GoRoute(
      path: '/resume',
      builder: (context, state) => ResumeFormPage(),
    ),
    GoRoute(
      path: '/job',
      builder: (context, state) => JobSearchScreen(),
    ),
    GoRoute(
      path: '/roadmap',
      builder: (context, state) => TopCourseVideosScreen(),
    ),
  ]);
}
