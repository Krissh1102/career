import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({super.key});

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Basic Info Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _summaryController = TextEditingController();

  // Education Controllers
  final _schoolController = TextEditingController();
  final _degreeController = TextEditingController();
  final _yearController = TextEditingController();
  final _gpaController = TextEditingController();

  // Experience Controllers
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _durationController = TextEditingController();
  final List<String> _responsibilities = [];
  final _responsibilityController = TextEditingController();

  // Skills
  final List<String> _skills = [];
  final _skillController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Build Your Resume',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Left side with Lottie animation
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade50,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Lottie.asset(
                      'asseets/images/Animation - 1740223091474.json', // Make sure this animation file exists
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _getStepTitle(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getStepDescription(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildProgressIndicator(),
                ],
              ),
            ),
          ),
          // Right side with form
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(-5, 0),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: _buildCurrentStep(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 50,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index <= _currentStep ? Colors.amber : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'Education Details';
      case 2:
        return 'Work Experience';
      case 3:
        return 'Skills & Expertise';
      default:
        return '';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 0:
        return 'Let\'s start with your basic details';
      case 1:
        return 'Tell us about your educational background';
      case 2:
        return 'Share your professional journey';
      case 3:
        return 'List your key skills and competencies';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoForm();
      case 1:
        return _buildEducationForm();
      case 2:
        return _buildExperienceForm();
      case 3:
        return _buildSkillsForm();
      default:
        return Container();
    }
  }

  Widget _buildBasicInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStyledTextField(
          controller: _nameController,
          label: 'Full Name',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 20),
        _buildStyledTextField(
          controller: _emailController,
          label: 'Email',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your email' : null,
        ),
        const SizedBox(height: 20),
        _buildStyledTextField(
          controller: _phoneController,
          label: 'Phone',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your phone' : null,
        ),
        const SizedBox(height: 20),
        _buildStyledTextField(
          controller: _summaryController,
          label: 'Professional Summary',
          maxLines: 4,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your summary' : null,
        ),
        const SizedBox(height: 32),
        _buildNextButton(),
      ],
    );
  }

  Widget _buildEducationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStyledTextField(
          controller: _schoolController,
          label: 'School/University',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter school name' : null,
        ),
        const SizedBox(height: 20),
        _buildStyledTextField(
          controller: _degreeController,
          label: 'Degree',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter degree' : null,
        ),
        const SizedBox(height: 20),
        _buildStyledTextField(
          controller: _yearController,
          label: 'Year',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter year' : null,
        ),
        const SizedBox(height: 20),
        _buildStyledTextField(
          controller: _gpaController,
          label: 'GPA',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter GPA' : null,
        ),
        const SizedBox(height: 32),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildExperienceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStyledTextField(
          controller: _companyController,
          label: 'Company',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter company name' : null,
        ),
        const SizedBox(height: 20),
        _buildStyledTextField(
          controller: _positionController,
          label: 'Position',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter position' : null,
        ),
        const SizedBox(height: 20),
        _buildStyledTextField(
          controller: _durationController,
          label: 'Duration',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter duration' : null,
        ),
        const SizedBox(height: 20),
        _buildResponsibilitiesSection(),
        const SizedBox(height: 32),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildSkillsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSkillInput(),
        const SizedBox(height: 20),
        _buildSkillsList(),
        const SizedBox(height: 32),
        _buildNavigationButtons(isLastStep: true),
      ],
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: validator,
    );
  }

  Widget _buildResponsibilitiesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Responsibilities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _responsibilityController,
                  decoration: InputDecoration(
                    labelText: 'Add Responsibility',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (_responsibilityController.text.isNotEmpty) {
                    setState(() {
                      _responsibilities.add(_responsibilityController.text);
                      _responsibilityController.clear();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          if (_responsibilities.isNotEmpty) ...[
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _responsibilities.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(_responsibilities[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _responsibilities.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _skillController,
            decoration: InputDecoration(
              labelText: 'Add Skill',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            if (_skillController.text.isNotEmpty) {
              setState(() {
                _skills.add(_skillController.text);
                _skillController.clear();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
          ),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildSkillsList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _skills
          .map((skill) => Chip(
                label: Text(skill),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() {
                    _skills.remove(skill);
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          setState(() {
            _currentStep++;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildNavigationButtons({bool isLastStep = false}) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep--;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.grey.shade200,
            ),
            child: const Text(
              'Back',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                if (isLastStep) {
                  // Generate and download the resume as PDF
                  _generateAndDownloadResume();
                } else {
                  setState(() {
                    _currentStep++;
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isLastStep ? 'Finish' : 'Next',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _generateAndDownloadResume() async {
  try {
    final pdf = pw.Document();

    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  _nameController.text,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Email: ${_emailController.text} | Phone: ${_phoneController.text}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              // Professional Summary
              pw.Header(
                level: 1,
                child: pw.Text('Professional Summary'),
              ),
              pw.Text(_summaryController.text),
              pw.SizedBox(height: 20),
              // Education
              pw.Header(
                level: 1,
                child: pw.Text('Education'),
              ),
              pw.Text('${_schoolController.text} - ${_degreeController.text}'),
              pw.Text('Year: ${_yearController.text}'),
              pw.Text('GPA: ${_gpaController.text}'),
              pw.SizedBox(height: 20),
              // Experience
              pw.Header(
                level: 1,
                child: pw.Text('Work Experience'),
              ),
              pw.Text('${_positionController.text} at ${_companyController.text}'),
              pw.Text('Duration: ${_durationController.text}'),
              pw.SizedBox(height: 10),
              ...(_responsibilities.map((resp) => pw.Text('• $resp'))),
              pw.SizedBox(height: 20),
              // Skills
              pw.Header(
                level: 1,
                child: pw.Text('Skills'),
              ),
              pw.Text(_skills.join(', ')),
            ],
          );
        },
      ),
    );

    // For web platform
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    html.Url.revokeObjectUrl(url);

    // Hide loading dialog
    Navigator.of(context).pop();
  } catch (e) {
    // Hide loading dialog if showing
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    
    // Show error dialog
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to generate PDF: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

  pw.Widget _buildPdfSection(
    String title,
    List<String> contents, {
    required pw.Font font,
    required pw.Font boldFont,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 18,
          ),
        ),
        pw.SizedBox(height: 8),
        ...contents.map(
          (content) => pw.Text(
            content,
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
            ),
          ),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _summaryController.dispose();
    _schoolController.dispose();
    _degreeController.dispose();
    _yearController.dispose();
    _gpaController.dispose();
    _companyController.dispose();
    _positionController.dispose();
    _durationController.dispose();
    _responsibilityController.dispose();
    _skillController.dispose();
    super.dispose();
  }
}
