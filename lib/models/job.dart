import '../utils/string_utils.dart';

class Job {
  final String id;
  final String url;
  final String jobTitle;
  final String companyName;
  final String companyLogo;
  final String jobIndustry;
  final String jobType;
  final String jobGeo;
  final String jobLevel;
  final String jobExcerpt;
  final String jobDescription;
  final DateTime pubDate;
  final int? salaryMin;
  final int? salaryMax;
  final String? salaryCurrency;
  final String? salaryPeriod;

  Job({
    required this.id,
    required this.url,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogo,
    required this.jobIndustry,
    required this.jobType,
    required this.jobGeo,
    required this.jobLevel,
    required this.jobExcerpt,
    required this.jobDescription,
    required this.pubDate,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.salaryPeriod,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    // Helper function to safely get and decode string values
    String _getDecodedString(dynamic value) {
      if (value == null) return '';
      final str = value.toString();
      if (str.isEmpty) return str;
      return StringUtils.decodeHtml(str);
    }

    return Job(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      jobTitle: _getDecodedString(json['jobTitle']),
      companyName: _getDecodedString(json['companyName']),
      companyLogo: json['companyLogo']?.toString() ?? '',
      jobIndustry: _getDecodedString(json['jobIndustry']),
      jobType: _getDecodedString(json['jobType']),
      jobGeo: _getDecodedString(json['jobGeo']),
      jobLevel: _getDecodedString(json['jobLevel']),
      jobExcerpt: _getDecodedString(json['jobExcerpt']),
      jobDescription: _getDecodedString(json['jobDescription']),
      pubDate: json['pubDate'] != null ? DateTime.parse(json['pubDate'].toString()) : DateTime.now(),
      salaryMin: json['salaryMin'] != null ? int.tryParse(json['salaryMin'].toString()) : null,
      salaryMax: json['salaryMax'] != null ? int.tryParse(json['salaryMax'].toString()) : null,
      salaryCurrency: json['salaryCurrency']?.toString(),
      salaryPeriod: json['salaryPeriod']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'jobIndustry': jobIndustry,
      'jobType': jobType,
      'jobGeo': jobGeo,
      'jobLevel': jobLevel,
      'jobExcerpt': jobExcerpt,
      'jobDescription': jobDescription,
      'pubDate': pubDate.toIso8601String(),
      'salaryMin': salaryMin,
      'salaryMax': salaryMax,
      'salaryCurrency': salaryCurrency,
      'salaryPeriod': salaryPeriod,
    };
  }
}
