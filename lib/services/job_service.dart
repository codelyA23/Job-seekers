import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job.dart';

class JobService {
  static const String _baseUrl = 'https://jobicy.com/api/v2/remote-jobs';

  /// Fetches a list of remote jobs from the Jobicy API.
  /// Optional query params: count, geo, industry, tag
  static Future<List<Job>> fetchJobs({
    int count = 20,
    String? geo,
    String? industry,
    String? tag,
  }) async {
    final Map<String, String> params = {
      'count': count.toString(),
    };

    if (geo != null) params['geo'] = geo;
    if (industry != null) params['industry'] = industry;
    if (tag != null) params['tag'] = tag;

    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // The API response contains a 'jobs' key with the list of jobs
      final List<dynamic> jobs = data['jobs'] ?? [];
      return jobs.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs: ${response.statusCode}');
    }
  }
}
