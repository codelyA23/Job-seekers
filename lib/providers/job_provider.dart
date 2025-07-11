import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/job_service.dart';

class JobProvider with ChangeNotifier {
  List<Job> _jobs = [];
  bool _isLoading = false;
  String? _error;

  List<Job> get jobs => _jobs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadJobs({
    String? geo,
    String? industry,
    String? tag,
    bool refresh = false,
  }) async {
    try {
      // Set loading state
      _isLoading = true;
      _error = null;
      if (refresh) {
        _jobs = [];
      }
      
      // Schedule the notifyListeners call for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isLoading) { // Only notify if we're still in loading state
          notifyListeners();
        }
      });

      // Add artificial delay to show loading state (for demo purposes)
      await Future.delayed(const Duration(milliseconds: 500));

      // Fetch a mix of job types
      final List<Job> allJobs = [];
      final List<String> jobTypes = ['full-time', 'part-time', 'contract', 'freelance'];
      
      // Fetch jobs for each type and combine them
      for (final type in jobTypes) {
        try {
          final jobs = await JobService.fetchJobs(
            count: 25, // 25 jobs per type
            geo: geo,
            industry: industry,
            tag: type,
          ).timeout(
            const Duration(seconds: 10),
          );
          allJobs.addAll(jobs);
        } catch (e) {
          // If one type fails, continue with others
          if (kDebugMode) {
            print('Failed to load jobs of type $type: $e');
          }
        }
      }
      
      // Shuffle the combined list to mix the job types
      final newJobs = allJobs..shuffle();

      if (refresh) {
        _jobs = newJobs..shuffle();
      } else {
        _jobs.addAll(newJobs);
      }
    } on SocketException catch (_) {
      _error = 'No internet connection. Please check your network settings.';
    } on TimeoutException catch (e) {
      _error = e.message;
    } on FormatException catch (_) {
      _error = 'Error parsing data. Please try again later.';
    } catch (e) {
      _error = 'Failed to load jobs. Please try again.';
      if (kDebugMode) {
        print('Error loading jobs: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    }

  void clearJobs() {
    _jobs = [];
    // Schedule the notifyListeners call for the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
  
  void clearError() {
    _error = null;
    // Schedule the notifyListeners call for the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
