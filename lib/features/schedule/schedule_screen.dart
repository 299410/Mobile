import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import 'package:api/api.dart';
import 'package:models/models.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _currentWeekStart = _getWeekStart(DateTime.now());
  int _selectedYear = DateTime.now().year;

  static DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  void _previousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      _selectedYear = _currentWeekStart.year;
    });
  }

  void _nextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      _selectedYear = _currentWeekStart.year;
    });
  }

  final LecturerApi _api = LecturerApi();
  List<DefenseSchedule> _fullSchedule = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    try {
      final schedule = await _api.getSchedule('me'); // 'me' or valid ID
      if (mounted) {
        setState(() {
          _fullSchedule = schedule;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Error handling if needed
      }
    }
  }

  Map<String, List<_ScheduleEvent>> get _weekSchedule {
    final Map<String, List<_ScheduleEvent>> map = {};
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));

    for (var item in _fullSchedule) {
      // Check if date is within current week
      if (item.date
              .isAfter(_currentWeekStart.subtract(const Duration(days: 1))) &&
          item.date.isBefore(weekEnd.add(const Duration(days: 1)))) {
        // Format Key: Mon-1, Tue-2...
        final dayName = DateFormat('E').format(item.date); // Mon, Tue...
        final slotNum = item.blockId;
        final key = '$dayName-$slotNum';

        if (!map.containsKey(key)) map[key] = [];

        map[key]!.add(_ScheduleEvent(
          title: item.blockName,
          role: item.roleName,
          timeRange: '${item.startTime} - ${item.endTime}',
          location: item.blockName,
          lecturerName: item.lecturerName,
          lecturerEmail: item.lecturerEmail,
        ));
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    final weekRangeText =
        '${DateFormat('dd/MM').format(_currentWeekStart)} – ${DateFormat('dd/MM').format(weekEnd)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('My Schedule'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Week Navigation Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Year Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.textSecondary.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text('$_selectedYear',
                                style: AppTextStyles.bodyLarge
                                    .copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Week Navigation
                      IconButton(
                        onPressed: _previousWeek,
                        icon: const Icon(Icons.chevron_left),
                        color: AppColors.textPrimary,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          weekRangeText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _nextWeek,
                        icon: const Icon(Icons.chevron_right),
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),

                // Timetable Grid
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: _buildTimetableGrid(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTimetableGrid() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const slots = [
      'Slot 1',
      'Slot 2',
      'Slot 3',
      'Slot 4',
      'Slot 5',
      'Slot 6',
      'Slot 7'
    ];

    const cellWidth = 140.0;
    const cellHeight = 90.0;
    const slotLabelWidth = 80.0;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Headers Row
          Row(
            children: [
              const SizedBox(width: slotLabelWidth), // Empty corner
              ...List.generate(days.length, (index) {
                final dayDate = _currentWeekStart.add(Duration(days: index));
                return Container(
                  width: cellWidth,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        days[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat('dd').format(dayDate),
                        style: AppTextStyles.h2
                            .copyWith(color: AppColors.onSecondary),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 8),

          // Slot Rows
          ...List.generate(slots.length, (slotIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slot Label
                  Container(
                    width: slotLabelWidth,
                    height: cellHeight,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          slots[slotIndex],
                          style: AppTextStyles.bodyMedium
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  // Day Cells
                  ...List.generate(days.length, (dayIndex) {
                    final slotNumber = slotIndex + 1; // Slot 1-7
                    final key = '${days[dayIndex]}-$slotNumber';
                    final events = _weekSchedule[key] ?? [];
                    return Container(
                      width: cellWidth,
                      height: cellHeight,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.textSecondary.withOpacity(0.1)),
                      ),
                      child: events.isEmpty
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () => _showEventPopup(events.first),
                              child: _buildEventCard(events.first),
                            ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEventCard(_ScheduleEvent event) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            event.title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  event.role,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            event.location,
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showEventPopup(_ScheduleEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(event.title, style: AppTextStyles.h1),
              const SizedBox(height: 20),
              // Info rows
              _buildPopupRow(Icons.person, 'Role', event.role),
              const SizedBox(height: 16),
              _buildPopupRow(Icons.access_time, 'Time', event.timeRange),
              const SizedBox(height: 16),
              _buildPopupRow(Icons.location_on, 'Location', event.location),
              const SizedBox(height: 16),
              _buildPopupRow(Icons.school, 'Lecturer',
                  '${event.lecturerName}\n${event.lecturerEmail}'),
              const SizedBox(height: 24),
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Text(value,
                style: AppTextStyles.bodyLarge
                    .copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _ScheduleEvent {
  final String title;
  final String role;
  final String timeRange;
  final String location;
  final String lecturerName;
  final String lecturerEmail;

  _ScheduleEvent({
    required this.title,
    required this.role,
    required this.timeRange,
    required this.location,
    required this.lecturerName,
    required this.lecturerEmail,
  });
}
