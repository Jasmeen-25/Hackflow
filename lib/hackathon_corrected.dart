import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const HackFlowApp());
}


// ==================== APP THEME ====================

const Color primary = Color(0xFF059669);    // Emerald green
const Color secondary = Color(0xFF047857); // Deep emerald
const Color accent = Color(0xFFA7F3D0);     // Mint green
const Color background = Color(0xFFECFDF5); // Light green background
const Color ink = Color(0xFF064E3B);        // Dark green text
const Color muted = Color(0xFF6B7280);      // Secondary text
const Color success = Color(0xFF059669);    // Success green
const Color warning = Color(0xFFF59E0B);    // Warning amber

class HackFlowApp extends StatelessWidget {
  const HackFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

// ==================== HOME SCREEN ====================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HackFlow',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              'Hackathon Organizer',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'My Profile',
            icon: const CircleAvatar(
              backgroundColor: primary,
              child: Icon(Icons.person, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primary, secondary],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.rocket_launch, color: Colors.white, size: 36),
                SizedBox(height: 14),
                Text(
                  'Welcome to HackFlow!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Plan. Build. Collaborate. Win.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Event Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: statCard('Participants', '128', Icons.groups, primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: statCard('Teams', '32', Icons.group_work, secondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: statCard('Tasks', '18', Icons.task_alt, success),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: statCard('Rounds', '3', Icons.emoji_events, warning),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Workspace',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          navigationCard(
            context,
            'Phase 2 · Event Management',
            'Event details, schedule and announcements',
            Icons.event_note,
            const OrganizerScreen(),
          ),
          navigationCard(
            context,
            'Phase 3 · Student Tasks',
            'Track and submit project tasks',
            Icons.assignment,
            const TasksScreen(),
          ),
          navigationCard(
            context,
            'Phase 4 · Hackathon Flow',
            'Countdown, rounds and judging',
            Icons.timer,
            const FlowScreen(),
          ),
          navigationCard(
            context,
            'Phase 5 · Results',
            'Leaderboard and certificates',
            Icons.emoji_events,
            const ResultsScreen(),
          ),
          navigationCard(
            context,
            'Phase 6 · Community',
            'Chat, feedback and gallery',
            Icons.forum,
            const CommunityScreen(),
          ),
          const SizedBox(height: 12),
          const Text(
            'HackFlow demo app',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

Widget statCard(String title, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(title, style: const TextStyle(color: muted, fontSize: 12)),
      ],
    ),
  );
}

Widget navigationCard(
  BuildContext context,
  String title,
  String subtitle,
  IconData icon,
  Widget page,
) {
  return Card(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    ),
  );
}

// ==================== PHASE 2: EVENT MANAGEMENT ====================


class OrganizerScreen extends StatelessWidget {
  Future<void> _registerForEvent(
  BuildContext context,
  String eventId,
) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please log in first.')),
    );
    return;
  }

  try {
    final registrationRef = FirebaseFirestore.instance
        .collection('hackathons')
        .doc(eventId)
        .collection('registrations')
        .doc(user.uid);

    final existing = await registrationRef.get();

    if (existing.exists) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already registered!')),
      );
      return;
    }

    await registrationRef.set({
      'userId': user.uid,
      'email': user.email,
      'registeredAt': FieldValue.serverTimestamp(),
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful! 🎉')),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration failed: $e')),
    );
  }

}
  const OrganizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Management')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Hackathon'),
        onPressed: () => _showCreateDialog(context),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('hackathons')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Could not load events. Check Firestore rules.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data?.docs ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event_available, size: 64, color: primary),
                    SizedBox(height: 12),
                    Text(
                      'No hackathons yet',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Tap Create Hackathon to add your first event.'),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index].data();
              final eventDoc = events[index];

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: accent,
                    child: Icon(Icons.emoji_events, color: secondary),
                  ),
                  title: Text(
                    event['title'] ?? 'Untitled Hackathon',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  
subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      '${event['venue'] ?? 'Venue not set'}\n'
      '${event['date'] ?? 'Date not set'}\n'
      '${event['description'] ?? ''}',
    ),
    const SizedBox(height: 8),
    ElevatedButton.icon(
      onPressed: () => _registerForEvent(
        context,
        eventDoc.id,
      ),
      icon: const Icon(Icons.how_to_reg),
      label: const Text('Register Now'),
    ),
  ],
),

                  

trailing: Wrap(
  spacing: 4,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    IconButton(
      tooltip: 'Edit event',
      icon: const Icon(Icons.edit, color: primary),
      onPressed: () => _editEvent(context, eventDoc),
    ),
    IconButton(
      tooltip: 'Delete event',
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      onPressed: () => _deleteEvent(context, eventDoc),
    ),
  ],
),


                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }

Future<void> _editEvent(
  BuildContext context,
  QueryDocumentSnapshot<Map<String, dynamic>> eventDoc,
) async {
  final event = eventDoc.data();
  final titleController =
      TextEditingController(text: event['title'] ?? '');
  final descriptionController =
      TextEditingController(text: event['description'] ?? '');
  final venueController =
      TextEditingController(text: event['venue'] ?? '');
  final dateController =
      TextEditingController(text: event['date'] ?? '');

  final formKey = GlobalKey<FormState>();

  try {
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Hackathon'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Hackathon title',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Enter a title'
                            : null,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Enter a description'
                            : null,
                  ),
                  TextFormField(
                    controller: venueController,
                    decoration: const InputDecoration(
                      labelText: 'Venue',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Enter a venue'
                            : null,
                  ),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Event date',
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    onTap: () async {
                      final now = DateTime.now();
                      final chosen = await showDatePicker(
                        context: dialogContext,
                        initialDate: now,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (chosen != null) {
                        dateController.text =
                            '${chosen.day.toString().padLeft(2, '0')}/'
                            '${chosen.month.toString().padLeft(2, '0')}/'
                            '${chosen.year}';
                      }
                    },
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Choose a date'
                            : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );

    if (shouldSave != true) return;

    await eventDoc.reference.update({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'venue': venueController.text.trim(),
      'date': dateController.text.trim(),
    });

    if (context.mounted) {
      showMessage(context, 'Hackathon updated successfully!');
    }
  } catch (e) {
    debugPrint('EDIT HACKATHON ERROR: $e');
    if (context.mounted) {
      showMessage(context, 'Could not update event. Check permissions.');
    }
  } finally {
    titleController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    dateController.dispose();
  }
}

Future<void> _deleteEvent(
  BuildContext context,
  QueryDocumentSnapshot<Map<String, dynamic>> eventDoc,
) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Hackathon?'),
      content: Text(
        'Are you sure you want to delete '
        '"${eventDoc.data()['title'] ?? 'this event'}"? '
        'This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (shouldDelete != true) return;

  try {
    await eventDoc.reference.delete();

    if (context.mounted) {
      showMessage(context, 'Hackathon deleted successfully.');
    }
  } catch (e) {
    debugPrint('DELETE HACKATHON ERROR: $e');
    if (context.mounted) {
      showMessage(context, 'Could not delete event. Check permissions.');
    }
  }
}

  void _showCreateDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final venueController = TextEditingController();
    final dateController = TextEditingController();
    bool saving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create Hackathon'),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Hackathon title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter a title'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter a description'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: venueController,
                          decoration: const InputDecoration(
                            labelText: 'Venue',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter a venue'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Event date',
                            hintText: 'Choose a date',
                            suffixIcon: Icon(Icons.calendar_month),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 730),
                              ),
                            );

                            if (date != null) {
                              dateController.text =
                                  '${date.day.toString().padLeft(2, '0')}/'
                                  '${date.month.toString().padLeft(2, '0')}/'
                                  '${date.year}';
                            }
                          },
                          validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Choose an event date'
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: saving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            showMessage(context, 'Please sign in first.');
                            return;
                          }

                          setDialogState(() => saving = true);

                          try {
                            await FirebaseFirestore.instance
                                .collection('hackathons')
                                .add({
                              'title': titleController.text.trim(),
                              'description':
                                  descriptionController.text.trim(),
                              'venue': venueController.text.trim(),
                              'date': dateController.text,
                              'organizerId': user.uid,
                              'createdAt':
                                  FieldValue.serverTimestamp(),
                            });

                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }
                            if (context.mounted) {
                              showMessage(
                                context,
                                'Hackathon created successfully!',
                              );
                            }
                          } catch (e) {
                            setDialogState(() => saving = false);
                            showMessage(
                              // ignore: use_build_context_synchronously
                              context,
                              'Could not save event. Check Firestore rules.',
                            );
                            debugPrint('CREATE HACKATHON ERROR: $e');
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(                          strokeWidth: 2,
                          ),
                        )
                      : const Text('Save Event'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget eventInfo(
  BuildContext context,
  IconData icon,
  String title,
  String details,
) {
  return Card(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      leading: Icon(icon, color: primary, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(details),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(title),
            content: Text(details),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    ),
  );
}

// ==================== PHASE 3: STUDENT TASKS ====================

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int selectedFilter = 0;

  final List<Map<String, String>> tasks = [
    {
      'title': 'Problem Statement',
      'description': 'Submit your selected problem statement.',
      'status': 'Reviewed',
    },
    {
      'title': 'UI/UX Prototype',
      'description': 'Submit your first design prototype.',
      'status': 'Submitted',
    },
    {
      'title': 'Working Prototype',
      'description': 'Submit your functional application.',
      'status': 'Pending',
    },
    {
      'title': 'Final Presentation',
      'description': 'Submit your final presentation slides.',
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final visibleTasks = tasks.where((task) {
      if (selectedFilter == 1) return task['status'] == 'Pending';
      if (selectedFilter == 2) return task['status'] != 'Pending';
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Student Tasks')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: submitTask,
        icon: const Icon(Icons.upload_file),
        label: const Text('Submit Project'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('All')),
                ButtonSegment(value: 1, label: Text('Pending')),
                ButtonSegment(value: 2, label: Text('Submitted')),
              ],
              selected: {selectedFilter},
              onSelectionChanged: (value) {
                setState(() => selectedFilter = value.first);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: visibleTasks.length,
              itemBuilder: (context, index) {
                final task = visibleTasks[index];
                final status = task['status']!;

                final Color statusColor = status == 'Pending'
                    ? warning
                    : status == 'Reviewed'
                        ? success
                        : primary;

                return Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task['description']!,
                          style: const TextStyle(color: muted),
                        ),
                        const SizedBox(height: 10),
                        if (status == 'Pending')
                          OutlinedButton.icon(
                            onPressed: submitTask,
                            icon: const Icon(Icons.upload),
                            label: const Text('Submit Task'),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void submitTask() {
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Submit Project'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            labelText: 'Project or GitHub URL',
            hintText: 'https://...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              urlController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (urlController.text.trim().isEmpty) {
                showMessage(context, 'Please enter a project URL.');
                return;
              }

              setState(() {
                final index = tasks.indexWhere(
                  (task) => task['status'] == 'Pending',
                );

                if (index != -1) {
                  tasks[index]['status'] = 'Submitted';
                }
              });

              urlController.dispose();
              Navigator.pop(dialogContext);
              showMessage(context, 'Demo submission completed.');
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// ==================== PHASE 4: HACKATHON FLOW ====================

class FlowScreen extends StatefulWidget {
  const FlowScreen({super.key});

  @override
  State<FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  Timer? timer;
  int seconds = 2 * 3600 + 35 * 60;
  int selectedRound = 1;

  double innovation = 8;
  double technical = 7;
  double design = 9;
  double presentation = 8;

  final List<String> rounds = [
    'Idea Submission',
    'Prototype Development',
    'Final Presentation',
  ];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && seconds > 0) {
        setState(() => seconds--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hackathon Flow')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [secondary, primary],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                const Text(
                  'HACKATHON COUNTDOWN',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Keep building! 🚀',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Select Round',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Round 1')),
              ButtonSegment(value: 1, label: Text('Round 2')),
              ButtonSegment(value: 2, label: Text('Finals')),
            ],
            selected: {selectedRound},
            onSelectionChanged: (value) {
              setState(() => selectedRound = value.first);
            },
          ),
          Card(
            color: Colors.white,
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.flag, color: primary),
              title: Text(
                rounds[selectedRound],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                selectedRound == 0
                    ? 'Completed'
                    : selectedRound == 1
                        ? 'Live'
                        : 'Upcoming',
              ),
            ),
          ),
          const Card(
            color: Colors.white,
            elevation: 0,
            child: ListTile(
              leading: Icon(Icons.mic, color: primary),
              title: Text('Presentation Slot'),
              subtitle: Text('05:30 PM – 05:40 PM'),
            ),
          ),
          const Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Judging Panel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Dr. Anil Sharma'),
                    subtitle: Text('Technical Judge'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Priya Kapoor'),
                    subtitle: Text('Design Judge'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Rahul Mehta'),
                    subtitle: Text('Innovation Judge'),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Judge Scoring',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  scoreSlider(
                    'Innovation',
                    innovation,
                    (v) => setState(() => innovation = v),
                  ),
                  scoreSlider(
                    'Technical',
                    technical,
                    (v) => setState(() => technical = v),
                  ),
                  scoreSlider(
                    'Design',
                    design,
                    (v) => setState(() => design = v),
                  ),
                  scoreSlider(
                    'Presentation',
                    presentation,
                    (v) => setState(() => presentation = v),
                  ),
                  const Divider(),
                  Text(
                    'Total: ${(innovation + technical + design + presentation).round()} / 40',
                    style: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () {
              final total =
                  (innovation + technical + design + presentation).round();

              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Score Submitted'),
                  content: Text('Your score is $total out of 40.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Submit Score'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResultsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.leaderboard),
            label: const Text('View Leaderboard'),
          ),
        ],
      ),
    );
  }
}

Widget scoreSlider(
  String title,
  double value,
  ValueChanged<double> onChanged,
) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            '${value.round()}/10',
            style: const TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Slider(
        value: value,
        min: 0,
        max: 10,
        divisions: 10,
        activeColor: primary,
        onChanged: onChanged,
      ),
    ],
  );
}

// ==================== PHASE 5: RESULTS ====================

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  static const List<Map<String, Object>> teams = [
    {'name': 'Code Warriors', 'points': 1240},
    {'name': 'Byte Force', 'points': 1198},
    {'name': 'NexMind', 'points': 842},
    {'name': 'Tech Titans', 'points': 815},
    {'name': 'Debug Squad', 'points': 789},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Final Results')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primary, secondary],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              children: [
                Icon(Icons.celebration, color: Colors.white, size: 42),
                SizedBox(height: 12),
                Text(
                  'HackFlow 2026 Completed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Congratulations to all participants.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'YOUR RESULT',
                    style: TextStyle(
                      color: muted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '#3',
                    style: TextStyle(
                      color: primary,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'NexMind',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('842 Points', style: TextStyle(color: muted)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Final Leaderboard',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.white,
            elevation: 0,
            child: Column(
              children: [
                for (int i = 0; i < teams.length; i++)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: i < 3 ? primary : background,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: i < 3 ? Colors.white : ink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      teams[i]['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${teams[i]['points']} pts',
                      style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor: i == 2 ? primary.withValues(alpha: 0.06) : null,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color: warning,
                    size: 46,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Digital Certificate',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'NexMind · 3rd Place',
                    style: TextStyle(color: muted),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Certificate Preview'),
                          content: const Text(
                            'Presented to NexMind for securing 3rd place '
                            'at HackFlow 2026.\n\n'
                            'This is a demo certificate.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Certificate'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Achievement(icon: Icons.emoji_events, title: 'Top 3'),
                      Achievement(icon: Icons.code, title: 'Builder'),
                      Achievement(icon: Icons.groups, title: 'Teamwork'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              showMessage(context, 'Sharing is a demo feature.');
            },
            icon: const Icon(Icons.share),
            label: const Text('Share Achievement'),
          ),
        ],
      ),
    );
  }
}

class Achievement extends StatelessWidget {
  final IconData icon;
  final String title;

  const Achievement({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: primary.withValues(alpha: 0.1),
          child: Icon(icon, color: primary),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ==================== PHASE 6: COMMUNITY ====================

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int selectedTab = 0;
  double rating = 4;

  final TextEditingController messageController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  final List<Map<String, String>> messages = [
    {
      'name': 'Organizer',
      'text': 'Welcome to the HackFlow community! 🎉',
      'time': '10:20 AM',
    },
    {
      'name': 'Arsh',
      'text': 'When will the final results be announced?',
      'time': '10:25 AM',
    },
    {
      'name': 'Organizer',
      'text': 'Results are now live! 🏆',
      'time': '10:28 AM',
    },
  ];

  final List<Map<String, Object>> gallery = [
    {'title': 'Opening Ceremony', 'icon': Icons.celebration, 'color': primary},
    {'title': 'Team Building', 'icon': Icons.groups, 'color': secondary},
    {'title': 'Project Showcase', 'icon': Icons.computer, 'color': accent},
    {'title': 'Final Presentation', 'icon': Icons.present_to_all, 'color': warning},
    {'title': 'Prize Distribution', 'icon': Icons.emoji_events, 'color': success},
    {'title': 'Closing Ceremony', 'icon': Icons.photo_camera, 'color': primary},
  ];

  @override
  void dispose() {
    messageController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Chat')),
                ButtonSegment(value: 1, label: Text('Feedback')),
                ButtonSegment(value: 2, label: Text('Gallery')),
              ],
              selected: {selectedTab},
              onSelectionChanged: (value) {
                setState(() => selectedTab = value.first);
              },
            ),
          ),
          Expanded(
            child: selectedTab == 0
                ? chatView()
                : selectedTab == 1
                    ? feedbackView()
                    : galleryView(),
          ),
        ],
      ),
    );
  }

  // CHAT TAB
  Widget chatView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final bool isMine = message['name'] == 'You';

              return Align(
                alignment:
                    isMine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: isMine ? primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['name']!,
                        style: TextStyle(
                          color: isMine ? Colors.white70 : primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        message['text']!,
                        style: TextStyle(
                          color: isMine ? Colors.white : ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message['time']!,
                        style: TextStyle(
                          color: isMine ? Colors.white70 : muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'name': 'You',
        'text': text,
        'time': 'Now',
      });
      messageController.clear();
    });
  }

  // FEEDBACK TAB
  Widget feedbackView() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Help us improve',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Rate your experience and leave a comment.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 18),
        Card(
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Rating',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      onPressed: () {
                        setState(() => rating = index + 1.0);
                      },
                      icon: Icon(
                        Icons.star,
                        size: 32,
                        color: index < rating
                            ? warning
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: feedbackController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'What went well? What can we improve?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: submitFeedback,
                    child: const Text('Submit Feedback'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          color: Colors.white,
          elevation: 0,
          child: ListTile(
            leading: Icon(Icons.support_agent, color: primary),
            title: Text('Need help?'),
            subtitle: Text(
              'Contact the hackathon organizer for assistance.',
            ),
          ),
        ),
      ],
    );
  }

  void submitFeedback() {
    if (feedbackController.text.trim().isEmpty) {
      showMessage(context, 'Please write some feedback first.');
      return;
    }

    feedbackController.clear();
    showMessage(
      context,
      'Thank you for your feedback! Rating: ${rating.round()}/5',
    );
  }

  // GALLERY TAB — Uses GestureDetector, not InkWell.
  Widget galleryView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: gallery.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final item = gallery[index];
        final String title = item['title'] as String;
        final IconData icon = item['icon'] as IconData;
        final Color color = item['color'] as Color;

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: 80),
                    const SizedBox(height: 12),
                    const Text('HackFlow 2026 event memory (demo).'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(icon, color: color, size: 34),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'View memory',
                  style: TextStyle(color: muted, fontSize: 11),

                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        return const AuthScreen();
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignup = false;
  bool _isLoading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final auth = FirebaseAuth.instance;
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isSignup) {
        final name = _nameController.text.trim();

        final credential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = credential.user;
        if (user == null) {
          throw StateError('Firebase created the account but returned no user.');
        }

        await user.updateDisplayName(name);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': 'participant',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      // AuthGate listens to authStateChanges() and will open HomeScreen.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered. Try signing in.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'weak-password':
          message = 'Use a stronger password (at least 6 characters).';
          break;
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Incorrect email or password.';
          break;
        case 'operation-not-allowed':
          message = 'Email/Password sign-in is not enabled in Firebase.';
          break;
        case 'api-key-not-valid':
          message = 'Firebase rejected the Web API key. Check firebase_options.dart and the Browser API key configuration.';
          break;
        default:
          message = e.message ?? 'Authentication failed (${e.code}).';
      }

      debugPrint('AUTH ERROR CODE: ${e.code}');
      debugPrint('AUTH ERROR MESSAGE: ${e.message ?? message}');
      showMessage(context, message);
    } catch (e, stackTrace) {
      debugPrint('SIGNUP/LOGIN ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Signup/Login Error'),
            content: SelectableText(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 76,
                      width: 76,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isSignup ? 'Create your account' : 'Welcome to HackFlow',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignup
                          ? 'Join events, connect, and start your hackathon journey.'
                          : 'Sign in to continue to your hackathon dashboard.',
                      style: const TextStyle(color: muted, fontSize: 15),
                    ),
                    const SizedBox(height: 28),

                    if (_isSignup) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_isSignup &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Please enter your name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(value.trim())) {
                          return 'Enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => _hidePassword = !_hidePassword);
                          },
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isSignup ? 'Create Account' : 'Sign In',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isSignup = !_isSignup;
                              });
                            },
                      child: Text(
                        _isSignup
                            ? 'Already have an account? Sign in'
                            : "Don't have an account? Sign up",
                        style: const TextStyle(color: ink),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ==================== USER PROFILE ====================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Profile')),
        body: const Center(child: Text('No user is currently signed in.')),
      );
    }

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: primary,
              child: Text(
                _profileInitial(user.displayName, user.email),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user.displayName?.trim().isNotEmpty == true
                  ? user.displayName!
                  : 'HackFlow User',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ink,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              user.email ?? 'No email available',
              textAlign: TextAlign.center,
              style: const TextStyle(color: muted),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Account details',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.white,
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: primary),
                  title: const Text('Full name'),
                  subtitle: Text(
                    user.displayName?.trim().isNotEmpty == true
                        ? user.displayName!
                        : 'Name not set',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined, color: primary),
                  title: const Text('Email address'),
                  subtitle: Text(user.email ?? 'No email available'),
                ),
                const Divider(height: 1),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: userDoc.snapshots(),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.data();
                    final role = data?['role'] as String? ?? 'participant';

                    return ListTile(
                      leading: const Icon(Icons.badge_outlined, color: primary),
                      title: const Text('Account role'),
                      subtitle: Text(
                        role[0].toUpperCase() + role.substring(1),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_user_outlined, color: primary),
                  title: const Text('Email verification'),
                  subtitle: Text(
                    user.emailVerified ? 'Verified' : 'Not verified',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () async {
                final shouldSignOut = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Sign out?'),
                    content: const Text(
                      'You will need to sign in again to access HackFlow.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: const Text('Sign out'),
                      ),
                    ],
                  ),
                );

                if (shouldSignOut == true) {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _profileInitial(String? displayName, String? email) {
    final name = displayName?.trim() ?? '';
    if (name.isNotEmpty) return name.substring(0, 1).toUpperCase();

    final emailText = email?.trim() ?? '';
    if (emailText.isNotEmpty) return emailText.substring(0, 1).toUpperCase();

    return 'H';
  }
}
