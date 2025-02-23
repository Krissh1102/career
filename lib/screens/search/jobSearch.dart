import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<dynamic> jobs = [];
  bool isLoading = false;

  Future<void> searchJobs() async {
    setState(() {
      isLoading = true;
    });

    // Replace with your actual JSearch API key
    const apiKey = 'f7ee50cdd3msh587900994e2fee3p187dbdjsn2b26c21435e5';
    final query = _searchController.text;
    final location = _locationController.text;

    try {
      final response = await http.get(
        Uri.parse(
          'https://jsearch.p.rapidapi.com/search?query=$query in $location&page=1&num_pages=1',
        ),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'jsearch.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          jobs = data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _launchJobUrl(String? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job URL not available')),
      );
      return;
    }

    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch job posting')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan.shade700, Colors.cyan.shade300],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Find Your Dream Job',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Job title, keywords, or company',
                      prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Location',
                      prefixIcon:
                          const Icon(Icons.location_on, color: Colors.cyan),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: searchJobs,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Search Jobs',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(color: Colors.cyan),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final job = jobs[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: () => _launchJobUrl(
                          job['job_apply_link'] ?? job['job_google_link']),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: job['employer_logo'] != null
                              ? Image.network(
                                  job['employer_logo'],
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.business,
                                          color: Colors.grey),
                                )
                              : const Icon(Icons.business, color: Colors.grey),
                        ),
                        title: Text(
                          job['job_title'] ?? 'No title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan.shade700,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(job['employer_name'] ?? 'Unknown company'),
                            const SizedBox(height: 4),
                            Text(job['job_city'] ?? 'Location not specified'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Chip(
                                  label: Text(
                                    job['job_employment_type'] ??
                                        'Not specified',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.cyan,
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(
                                    job['job_is_remote'] ? 'Remote' : 'On-site',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.amber,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward,
                            color: Colors.amber),
                      ),
                    ),
                  );
                },
                childCount: jobs.length,
              ),
            ),
        ],
      ),
    );
  }
}
