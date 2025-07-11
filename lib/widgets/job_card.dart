import 'package:flutter/material.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final bool showSaveButton;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.showSaveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(job.companyLogo),
          radius: 28,
          backgroundColor: Colors.grey[200],
        ),
        title: Text(
          job.jobTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.companyName),
            const SizedBox(height: 4),
            Text(
              job.jobExcerpt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              job.jobType,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(job.jobGeo, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
