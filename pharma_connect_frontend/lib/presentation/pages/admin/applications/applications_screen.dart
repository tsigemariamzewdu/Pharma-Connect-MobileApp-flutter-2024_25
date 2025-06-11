import 'package:flutter/material.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/application_repository_impl.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/application_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/application_notifier.dart';

class AdminApplicationsScreen extends ConsumerStatefulWidget {
  const AdminApplicationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminApplicationsScreen> createState() =>
      _AdminApplicationsScreenState();
}

class _AdminApplicationsScreenState
    extends ConsumerState<AdminApplicationsScreen> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final applicationState = ref.watch(applicationProvider);
    final notifier = ref.read(applicationProvider.notifier);
    List<Application> applications = [];
    bool isLoading = false;
    String? error;
    applicationState.when(
      loading: () {
        isLoading = true;
      },
      error: (err, _) {
        error = err.toString();
      },
      data: (apps) {
        applications = apps;
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Applications'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: ListView.separated(
                    itemCount: applications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final app = applications[index];
                      final isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = isSelected ? null : index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              const SizedBox(height: 8),
                              Text('Owner: \\${app.owner}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              Text('Contact: \\${app.contact}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              Text('Email: \\${app.email}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              Text('Status: \\${app.status}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              if (isSelected && app.status == 'Pending') ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () async {
                                        await notifier
                                            .rejectApplication(app.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Application rejected.')),
                                        );
                                        setState(() => _selectedIndex = null);
                                      },
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      label: const Text('Reject',
                                          style: TextStyle(color: Colors.red)),
                                      style: OutlinedButton.styleFrom(
                                        side:
                                            const BorderSide(color: Colors.red),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await notifier
                                            .approveApplication(app.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Application approved!')),
                                        );
                                        setState(() => _selectedIndex = null);
                                      },
                                      icon: const Icon(Icons.check,
                                          color: Colors.white),
                                      label: const Text('Approve'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
