import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_jobs_provider.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedJobsProvider>(
      builder: (context, savedProvider, child) {
        final savedJobs = savedProvider.savedJobs;

        return Scaffold(
          appBar: AppBar(title: const Text('Saved Jobs')),
          body: savedJobs.isEmpty
              ? const Center(child: Text('No saved jobs yet.'))
              : ListView.builder(
                  itemCount: savedJobs.length,
                  itemBuilder: (context, index) {
                    final job = savedJobs[index];
                    return Dismissible(
                      key: Key(job.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        savedProvider.removeJob(job);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${job.jobTitle} removed')),
                        );
                      },
                      child: JobCard(
                        job: job,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailScreen(job: job),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
