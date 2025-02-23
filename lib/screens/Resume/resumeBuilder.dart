// // main.dart
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';

// // models/resume_data.dart
// class ResumeData extends ChangeNotifier {
//   String name = '';
//   String email = '';
//   String phone = '';
//   String summary = '';
//   List<Education> education = [];
//   List<Experience> experience = [];
//   List<String> skills = [];

//   void updateBasicInfo(
//       {String? name, String? email, String? phone, String? summary}) {
//     if (name != null) this.name = name;
//     if (email != null) this.email = email;
//     if (phone != null) this.phone = phone;
//     if (summary != null) this.summary = summary;
//     notifyListeners();
//   }

//   void addEducation(Education edu) {
//     education.add(edu);
//     notifyListeners();
//   }

//   void addExperience(Experience exp) {
//     experience.add(exp);
//     notifyListeners();
//   }

//   void addSkill(String skill) {
//     skills.add(skill);
//     notifyListeners();
//   }
// }

// class Education {
//   final String school;
//   final String degree;
//   final String year;
//   final String gpa;

//   Education({
//     required this.school,
//     required this.degree,
//     required this.year,
//     required this.gpa,
//   });
// }

// class Experience {
//   final String company;
//   final String position;
//   final String duration;
//   final List<String> responsibilities;

//   Experience({
//     required this.company,
//     required this.position,
//     required this.duration,
//     required this.responsibilities,
//   });
// }

// // pages/education_page.dart
// class EducationPage extends StatefulWidget {
//   const EducationPage({super.key});

//   @override
//   State<EducationPage> createState() => _EducationPageState();
// }

// class _EducationPageState extends State<EducationPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _schoolController = TextEditingController();
//   final _degreeController = TextEditingController();
//   final _yearController = TextEditingController();
//   final _gpaController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Education'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _schoolController,
//                 decoration:
//                     const InputDecoration(labelText: 'School/University'),
//                 validator: (value) {
//                   if (value?.isEmpty ?? true) {
//                     return 'Please enter school name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _degreeController,
//                 decoration: const InputDecoration(labelText: 'Degree'),
//                 validator: (value) {
//                   if (value?.isEmpty ?? true) {
//                     return 'Please enter degree';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _yearController,
//                 decoration: const InputDecoration(labelText: 'Year'),
//                 validator: (value) {
//                   if (value?.isEmpty ?? true) {
//                     return 'Please enter year';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _gpaController,
//                 decoration: const InputDecoration(labelText: 'GPA'),
//                 validator: (value) {
//                   if (value?.isEmpty ?? true) {
//                     return 'Please enter GPA';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     context.read<ResumeData>().addEducation(
//                           Education(
//                             school: _schoolController.text,
//                             degree: _degreeController.text,
//                             year: _yearController.text,
//                             gpa: _gpaController.text,
//                           ),
//                         );
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const ExperiencePage()),
//                     );
//                   }
//                 },
//                 child: const Text('Next: Experience'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ExperiencePage extends StatefulWidget {
//   const ExperiencePage({super.key});

//   @override
//   State<ExperiencePage> createState() => _ExperiencePageState();
// }

// class _ExperiencePageState extends State<ExperiencePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _companyController = TextEditingController();
//   final _positionController = TextEditingController();
//   final _durationController = TextEditingController();
//   final List<String> _responsibilities = [];
//   final _responsibilityController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text('Work Experience'),
//         elevation: 0,
//       ),
//       body: Row(
//         children: [
//           // Left side with Lottie animation
//           Expanded(
//             flex: 2,
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 30),
//               color: Colors.cyan.shade50,
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 24, horizontal: 10),
//                     decoration: BoxDecoration(

//                         // borderRadius: BorderRadius.circular(20),
//                         ),
//                     child: Column(
//                       children: [
//                         Lottie.network(
//                           'asseets/images/Animation - 1740223091474.json',
//                           height: 300,
//                         ),
//                         const SizedBox(height: 24),
//                         Text(
//                           'Share Your Professional Journey',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey.shade800,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Tell us about your work experience and achievements',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey.shade600,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Right side with form
//           Expanded(
//             flex: 3,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   bottomLeft: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade200,
//                     blurRadius: 10,
//                     offset: const Offset(-5, 0),
//                   ),
//                 ],
//               ),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(32),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       TextFormField(
//                         controller: _companyController,
//                         decoration: InputDecoration(
//                           labelText: 'Company',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey.shade50,
//                         ),
//                         validator: (value) {
//                           if (value?.isEmpty ?? true) {
//                             return 'Please enter company name';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _positionController,
//                         decoration: InputDecoration(
//                           labelText: 'Position',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey.shade50,
//                         ),
//                         validator: (value) {
//                           if (value?.isEmpty ?? true) {
//                             return 'Please enter position';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _durationController,
//                         decoration: InputDecoration(
//                           labelText: 'Duration',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey.shade50,
//                         ),
//                         validator: (value) {
//                           if (value?.isEmpty ?? true) {
//                             return 'Please enter duration';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Responsibilities',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: TextFormField(
//                                     controller: _responsibilityController,
//                                     decoration: InputDecoration(
//                                       labelText: 'Add Responsibility',
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     if (_responsibilityController
//                                         .text.isNotEmpty) {
//                                       setState(() {
//                                         _responsibilities.add(
//                                             _responsibilityController.text);
//                                         _responsibilityController.clear();
//                                       });
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     padding: const EdgeInsets.all(16),
//                                   ),
//                                   child: const Icon(Icons.add),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: _responsibilities.length,
//                         itemBuilder: (context, index) {
//                           return Card(
//                             color: Colors.amber[100],
//                             margin: const EdgeInsets.only(bottom: 8),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               title: Text(_responsibilities[index]),
//                               trailing: IconButton(
//                                 icon:
//                                     const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () {
//                                   setState(() {
//                                     _responsibilities.removeAt(index);
//                                   });
//                                 },
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 32),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState?.validate() ?? false) {
//                             context.read<ResumeData>().addExperience(
//                                   Experience(
//                                     company: _companyController.text,
//                                     position: _positionController.text,
//                                     duration: _durationController.text,
//                                     responsibilities:
//                                         List.from(_responsibilities),
//                                   ),
//                                 );
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const PreviewPage()),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           'Next: Skills',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PreviewPage extends StatelessWidget {
//   const PreviewPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final resumeData = context.watch<ResumeData>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Resume Preview'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(resumeData.name,
//                 style: Theme.of(context).textTheme.headlineMedium),
//             const SizedBox(height: 8),
//             Text(resumeData.email),
//             Text(resumeData.phone),
//             const SizedBox(height: 16),
//             Text(resumeData.summary),
//             const SizedBox(height: 24),
//             const Text('Education',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             ...resumeData.education.map((edu) => ListTile(
//                   title: Text(edu.degree),
//                   subtitle: Text('${edu.school}\n${edu.year}\nGPA: ${edu.gpa}'),
//                 )),
//             const SizedBox(height: 16),
//             const Text('Experience',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             ...resumeData.experience.map((exp) => ListTile(
//                   title: Text(exp.position),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('${exp.company} - ${exp.duration}'),
//                       ...exp.responsibilities.map((r) => Text('• $r')),
//                     ],
//                   ),
//                 )),
//             const SizedBox(height: 16),
//             const Text('Skills',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             Wrap(
//               spacing: 8,
//               children: resumeData.skills
//                   .map((skill) => Chip(label: Text(skill)))
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
