import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';

class SavedJobsProvider with ChangeNotifier {
  static const _storageKey = 'saved_jobs';
  List<Job> _savedJobs = [];

  List<Job> get savedJobs => _savedJobs;

  Future<void> loadSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getStringList(_storageKey) ?? [];

    _savedJobs =
        savedData.map((jsonStr) => Job.fromJson(json.decode(jsonStr))).toList();
    notifyListeners();
  }

  Future<void> saveJob(Job job) async {
    if (_savedJobs.any((j) => j.id == job.id)) return;

    _savedJobs.add(job);
    await _persist();
    notifyListeners();
  }

  Future<void> removeJob(Job job) async {
    _savedJobs.removeWhere((j) => j.id == job.id);
    await _persist();
    notifyListeners();
  }

  bool isSaved(Job job) {
    return _savedJobs.any((j) => j.id == job.id);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        _savedJobs.map((job) => json.encode(job.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }
}
