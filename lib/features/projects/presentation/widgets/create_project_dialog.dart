import 'package:flutter/material.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:hackathon/features/team/domain/repo/team_repository.dart';
import 'package:intl/intl.dart';

class CreateProjectDialog extends StatefulWidget {
  final Project? projectToEdit;

  const CreateProjectDialog({
    super.key,
    this.projectToEdit,
  });

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descController;
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  
  String _selectedStatus = 'planning';
  String _selectedPriority = 'medium';
  String _selectedCompletionStatus = 'planning';
  
  int? _selectedTeamId;
  List<Team> _teams = [];
  bool _loadingTeams = true;

  final List<String> _statuses = ['planning', 'active', 'paused', 'completed', 'cancelled'];
  final List<String> _priorities = ['low', 'medium', 'high', 'critical'];
  final List<String> _completionStatuses = ['planning', 'execution', 'monitoring', 'closure'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.projectToEdit?.name ?? '');
    _descController = TextEditingController(text: widget.projectToEdit?.description ?? '');
    
    if (widget.projectToEdit != null) {
      _startDate = widget.projectToEdit!.startDate;
      _endDate = widget.projectToEdit!.endDate;
      _selectedStatus = widget.projectToEdit!.status;
      _selectedPriority = widget.projectToEdit!.priority;
      _selectedCompletionStatus = widget.projectToEdit!.completionStatus;
      _selectedTeamId = widget.projectToEdit!.teamId;
    }
    
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    try {
      final token = getIt<User>().employeeToken ?? getIt<User>().token ?? '';
      final result = await getIt<TeamRepository>().getTeams(token);
      result.fold(
        (failure) {
          debugPrint("Failed to fetch teams: ${failure.message}");
          if (mounted) {
            setState(() {
              _loadingTeams = false;
            });
          }
        },
        (teams) {
          if (mounted) {
            setState(() {
              _teams = teams;
              _loadingTeams = false;
              // If there are teams, auto-select the first one if we aren't editing
              if (widget.projectToEdit == null && teams.isNotEmpty) {
                _selectedTeamId = teams.first.id;
              }
            });
          }
        },
      );
    } catch (e) {
      debugPrint("Error fetching teams: $e");
      if (mounted) {
        setState(() {
          _loadingTeams = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.black,
            surface: Color(0xFF16161A),
            onSurface: Colors.white,
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Color(0xFF0F0F11),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.projectToEdit != null;

    return Dialog(
      backgroundColor: const Color(0xFF0F0F11),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white10),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Project' : 'Create New Project',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10, height: 24),
                
                // Name
                const Text('PROJECT NAME', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter project name',
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: const Color(0xFF16161A),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white38),
                    ),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Project name is required' : null,
                ),
                const SizedBox(height: 16),

                // Description
                const Text('DESCRIPTION', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter project details/scope',
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: const Color(0xFF16161A),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white38),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Team selection
                const Text('ASSIGNED TEAM', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _loadingTeams
                    ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator.adaptive()))
                    : _teams.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16161A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: const Text(
                              'No teams available. Please create a team first.',
                              style: TextStyle(color: Colors.amber, fontSize: 13),
                            ),
                          )
                        : DropdownButtonFormField<int>(
                            value: _selectedTeamId,
                            dropdownColor: const Color(0xFF16161A),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF16161A),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white38),
                              ),
                            ),
                            items: _teams.map((t) {
                              return DropdownMenuItem<int>(
                                value: t.id,
                                child: Text(t.name),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedTeamId = val),
                            validator: (value) => value == null ? 'Assigned team is required' : null,
                          ),
                const SizedBox(height: 16),

                // Timelines
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16161A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('START DATE', style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(DateFormat('MMM dd, yyyy').format(_startDate), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16161A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('END DATE', style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(DateFormat('MMM dd, yyyy').format(_endDate), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status, Priority & Completion Status Dropdowns
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('STATUS', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            dropdownColor: const Color(0xFF16161A),
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF16161A),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white38),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _statuses.map((s) {
                              return DropdownMenuItem<String>(
                                value: s,
                                child: Text(s.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedStatus = val!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PRIORITY', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedPriority,
                            dropdownColor: const Color(0xFF16161A),
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF16161A),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white38),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _priorities.map((p) {
                              return DropdownMenuItem<String>(
                                value: p,
                                child: Text(p.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedPriority = val!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PHASE', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedCompletionStatus,
                            dropdownColor: const Color(0xFF16161A),
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF16161A),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white38),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _completionStatuses.map((c) {
                              return DropdownMenuItem<String>(
                                value: c,
                                child: Text(c.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedCompletionStatus = val!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Save button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _selectedTeamId != null) {
                          final orgId = getIt<User>().organisation?.id ?? 0;
                          final userId = getIt<User>().user?.id ?? 0;
                          
                          final proj = Project(
                            id: isEditing ? widget.projectToEdit!.id : 0,
                            name: _nameController.text.trim(),
                            description: _descController.text.trim(),
                            startDate: _startDate,
                            endDate: _endDate,
                            organisationId: orgId,
                            teamId: _selectedTeamId!,
                            createdBy: isEditing ? widget.projectToEdit!.createdBy : userId,
                            status: _selectedStatus,
                            priority: _selectedPriority,
                            completionStatus: _selectedCompletionStatus,
                            milestones: isEditing ? widget.projectToEdit!.milestones : const [],
                          );
                          
                          Navigator.pop(context, proj);
                        }
                      },
                      child: Text(isEditing ? 'Save Changes' : 'Create Project', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
