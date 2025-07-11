import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/job.dart';
import '../providers/saved_jobs_provider.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  void _launchJobUrl() async {
    final uri = Uri.parse(job.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch ${job.url}';
    }
  }
  
  Widget _buildCompanyPlaceholder() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.business, size: 36, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.jobTitle),
        actions: [
          Consumer<SavedJobsProvider>(
            builder: (context, savedJobsProvider, _) {
              final isSaved = savedJobsProvider.isSaved(job);
              return IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Colors.amber : null,
                ),
                onPressed: () {
                  if (isSaved) {
                    savedJobsProvider.removeJob(job);
                    _showSnackBar(context, 'Removed from saved jobs');
                  } else {
                    savedJobsProvider.saveJob(job);
                    _showSnackBar(context, 'Job saved');
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _launchJobUrl,
            tooltip: 'Open job posting',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: job.companyLogo.isNotEmpty && Uri.tryParse(job.companyLogo)?.hasAbsolutePath == true
                        ? Image.network(
                            job.companyLogo,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildCompanyPlaceholder(),
                          )
                        : _buildCompanyPlaceholder(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.companyName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      Chip(label: Text(job.jobType)),
                      Chip(label: Text(job.jobGeo)),
                      Chip(label: Text(job.jobLevel)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (job.salaryMin != null && job.salaryMax != null)
              Card(
                color: Colors.green[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Salary: ${job.salaryMin} - ${job.salaryMax} ${job.salaryCurrency ?? ''} (${job.salaryPeriod ?? 'N/A'})',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Divider(thickness: 1.2),
            const SizedBox(height: 12),
            const Text(
              'Job Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              margin: const EdgeInsets.only(top: 8),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Html(
                  data: job.jobDescription
                      .replaceAll('&amp;', '&')
                      .replaceAll('&lt;', '<')
                      .replaceAll('&gt;', '>')
                      .replaceAll('&quot;', '"')
                      .replaceAll('&#039;', "'"),
                  style: {
                    "body": Style(
                      fontSize: FontSize.medium,
                      lineHeight: LineHeight.number(1.7),
                      color: Colors.black87,
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(
                      margin: Margins.only(bottom: 12),
                    ),
                    "ul": Style(
                      margin: Margins.only(bottom: 12, left: 16),
                    ),
                    "li": Style(
                      margin: Margins.only(bottom: 4),
                    ),
                  },
                  onLinkTap: (url, __, ___) {
                    if (url != null) {
                      final uri = Uri.tryParse(url);
                      if (uri != null) {
                        canLaunchUrl(uri).then((canLaunch) {
                          if (canLaunch) {
                            launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        });
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Optional helper to strip basic HTML tags from description

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
