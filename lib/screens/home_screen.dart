import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job.dart';
import '../providers/job_provider.dart';
import '../providers/saved_jobs_provider.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';
import 'saved_jobs_screen.dart' show SavedJobsScreen;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // UI State
  String _searchQuery = '';
  bool _isSearching = false;
  bool _showFilters = false;
  bool _isInitialized = false;
  
  // Filter states
  String _selectedJobType = 'All';
  String? _selectedLocation;
  String? _selectedCompany;
  
  // Available filter options
  final Set<String> _jobTypes = {'All', 'Full-time', 'Part-time', 'Contract', 'Freelance'};
  final Set<String> _locations = {};
  final Set<String> _companies = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      _loadData();
    }
  }
  
  Future<void> _loadData() async {
    final jobProvider = context.read<JobProvider>();
    final savedJobsProvider = context.read<SavedJobsProvider>();
    
    await jobProvider.loadJobs(refresh: true);
    if (mounted) {
      await savedJobsProvider.loadSavedJobs();
      if (mounted) {
        _extractFilterOptions(jobProvider);
      }
    }
  }
  
  void _extractFilterOptions(JobProvider jobProvider) {
    final jobs = jobProvider.jobs;
    final locations = <String>{};
    final companies = <String>{};

    for (final job in jobs) {
      if (job.jobGeo.isNotEmpty) {
        locations.add(job.jobGeo);
      }
      if (job.companyName.isNotEmpty) {
        companies.add(job.companyName);
      }
    }

    if (mounted) {
      setState(() {
        _locations
          ..clear()
          ..addAll(locations);
        _companies
          ..clear()
          ..addAll(companies);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }
  
  Widget _buildFiltersPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100]!.withValues(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _showFilters = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Job Type Filter
          _buildFilterChips(
            title: 'Job Type',
            selectedValue: _selectedJobType,
            values: _jobTypes.toList(),
            onSelected: (value) {
              setState(() {
                _selectedJobType = value;
              });
            },
          ),
          const SizedBox(height: 8),
          // Location Filter
          if (_locations.isNotEmpty)
            _buildFilterDropdown(
              title: 'Location',
              value: _selectedLocation,
              hint: 'All Locations',
              items: _locations.toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
            ),
          const SizedBox(height: 8),
          // Company Filter
          if (_companies.isNotEmpty)
            _buildFilterDropdown(
              title: 'Company',
              value: _selectedCompany,
              hint: 'All Companies',
              items: _companies.toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCompany = value;
                });
              },
            ),
          const SizedBox(height: 8),
          // Clear Filters Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedJobType = 'All';
                  _selectedLocation = null;
                  _selectedCompany = null;
                });
              },
              child: const Text('Clear Filters'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChips({
    required String title,
    required String selectedValue,
    required List<String> values,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((value) {
            final isSelected = value == selectedValue;
            return FilterChip(
              label: Text(value),
              selected: isSelected,
              onSelected: (_) => onSelected(value),
              backgroundColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor.withValues(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1),
              checkmarkColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildFilterDropdown({
    required String title,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          isDense: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          hint: Text(hint),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(hint, style: const TextStyle(color: Colors.grey)),
            ),
            ...items.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                )),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search jobs...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('Remote Jobs'),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _stopSearch,
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _showFilters ? Theme.of(context).primaryColor : null,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, _) {
          return RefreshIndicator(
            onRefresh: () => jobProvider.loadJobs(refresh: true),
            child: CustomScrollView(
              slivers: [
                // Filters panel
                if (_showFilters)
                  SliverToBoxAdapter(
                    child: _buildFiltersPanel(),
                  ),
                // Job list
                _buildJobList(jobProvider),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavedJobsScreen()),
        ),
        child: const Icon(Icons.bookmark),
      ),
    );
  }
  
  Widget _buildJobList(JobProvider jobProvider) {
    // Loading State with Skeleton
    if (jobProvider.isLoading && jobProvider.jobs.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildJobCardSkeleton(),
          childCount: 5, // Show 5 skeleton loaders
        ),
      );
    }
    
    // Error State
    if (jobProvider.error != null) {
      final isNetworkError = jobProvider.error!.toLowerCase().contains('internet') || 
                           jobProvider.error!.toLowerCase().contains('connection');
      
      return SliverFillRemaining(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isNetworkError ? Icons.signal_wifi_off_rounded : Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                isNetworkError ? 'No Internet Connection' : 'Something Went Wrong',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isNetworkError 
                  ? 'Please check your internet connection and try again.'
                  : jobProvider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => jobProvider.loadJobs(refresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
              if (isNetworkError) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Show cached jobs if available
                    if (jobProvider.jobs.isNotEmpty) {
                      setState(() {
                        // Clear error to show the cached jobs
                        jobProvider.clearError();
                      });
                    }
                  },
                  icon: const Icon(Icons.offline_bolt),
                  label: const Text('Show Cached Jobs'),
                ),
              ],
            ],
          ),
        ),
      );
    }
    
    // Empty State
    if (jobProvider.jobs.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64),
              SizedBox(height: 16),
              Text('No jobs found'),
              SizedBox(height: 8),
              Text('Pull down to refresh or try again later'),
            ],
          ),
        ),
      );
    }
    
    final filteredJobs = _getFilteredJobs(jobProvider.jobs);
    
    if (filteredJobs.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text('No jobs match your filters'),
        ),
      );
    }
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final job = filteredJobs[index];
          return JobCard(
            key: ValueKey(job.id),
            job: job,
            onTap: () {
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetailScreen(job: job),
                ),
              );
            },
            showSaveButton: true,
          );
        },
        childCount: filteredJobs.length,
      ),
    );
  }

  String _normalize(String value) {
    if (value.isEmpty) return '';
    return value
        .toLowerCase()
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .trim();
  }

  // Skeleton loading widget for job cards
  Widget _buildJobCardSkeleton() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 200,
                        color: Colors.grey[200],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 14,
                        width: 150,
                        color: Colors.grey[200],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 14,
              width: double.infinity,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 4),
            Container(
              height: 14,
              width: 250,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 24,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Job> _getFilteredJobs(List<Job> jobs) {
    return jobs.where((job) {
      // Search query filter
      final searchMatch = _searchQuery.isEmpty ||
          (job.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          (job.companyName.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      // Job type filter
      bool typeMatch = true;
      if (_selectedJobType != 'All') {
        final type = job.jobType;
        if (type.isNotEmpty) {
          final normalizedSelected = _normalize(_selectedJobType);
          typeMatch = _normalize(type).contains(normalizedSelected);
        } else {
          typeMatch = false;
        }
      }
      
      // Location filter
      final jobGeo = job.jobGeo;
      final locationMatch = _selectedLocation == null || 
          (jobGeo.isNotEmpty && jobGeo.toLowerCase().contains(_selectedLocation!.toLowerCase()));
      
      // Company filter
      final companyName = job.companyName;
      final companyMatch = _selectedCompany == null ||
          companyName.toLowerCase().contains(_selectedCompany!.toLowerCase());
      
      return searchMatch && typeMatch && locationMatch && companyMatch;
    }).toList();
  }
}
