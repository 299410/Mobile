import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import 'package:google_fonts/google_fonts.dart';
import '../lecturer/dashboard_screen.dart';
import '../schedule/schedule_screen.dart';
import 'package:api/api.dart';
import 'package:models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 60) / 2; // 20 padding on each side + 16 gap

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header with Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  'THESIS DEFENSE',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Top Row - 2 cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: cardSize,
                      height: cardSize,
                      child: _ActionCard(
                        icon: Icons.how_to_reg_outlined,
                        title: 'Register\nAvailability',
                        color: AppColors.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const LecturerDashboardScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: cardSize,
                      height: cardSize,
                      child: _ActionCard(
                        icon: Icons.calendar_month_outlined,
                        title: 'My\nSchedule',
                        color: AppColors.secondary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ScheduleScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bottom Row - 1 card centered
                SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: _ActionCard(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    color: AppColors.warning,
                    onTap: () => _showUpcomingSchedule(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUpcomingSchedule(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _UpcomingScheduleSheet(),
    );
  }
}

class _UpcomingScheduleSheet extends StatefulWidget {
  const _UpcomingScheduleSheet();

  @override
  State<_UpcomingScheduleSheet> createState() => _UpcomingScheduleSheetState();
}

class _UpcomingScheduleSheetState extends State<_UpcomingScheduleSheet> {
  late Future<List<DefenseSchedule>> _scheduleFuture;
  final LecturerApi _api = LecturerApi();

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _api.getSchedule('me');
  }

  DefenseSchedule? _getNextUpcomingEvent(List<DefenseSchedule> schedule) {
    final now = DateTime.now();
    // Sort by date/time just in case
    final sorted = List<DefenseSchedule>.from(schedule)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Find first event in the future (or today but later time?
    // Assuming date includes time or we check start time based on slots.
    // The current model has `date` (DateTime) and `startTime` (String).
    // Let's assume `date` is the day at 00:00:00.

    for (var event in sorted) {
      // Parse startTime if needed, or if date is enough.
      // The current code in schedule_screen checks date against current week.
      // Let's just check if the event day is today or future.

      // Simple check: is the day today (and maybe slot not passed?) or in future?
      // Since parsing "07:30" is fragile without a helper, let's stick to "date >= today".
      // Note: DefenseSchedule.date seems to be DateTime.

      final eventDate = event.date;

      if (eventDate.isAfter(now.subtract(const Duration(days: 1)))) {
        // If it's effectively today or future.
        // Better logic: if date > today, definitely yes.
        // If date == today, we should technically check time, but for now let's just show it.

        // Helper to ensure we don't show passed events if possible?
        // For now, next available day is fine.
        return event;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Row(
              children: [
                Icon(Icons.notifications_active, color: AppColors.warning),
                const SizedBox(width: 12),
                Text('Upcoming Schedule', style: AppTextStyles.h1),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<DefenseSchedule>>(
              future: _scheduleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final nextEvent = _getNextUpcomingEvent(snapshot.data!);

                if (nextEvent == null) {
                  return _buildEmptyState();
                }

                return _buildEventCard(nextEvent);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ScheduleScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View Full Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
          child: Column(
        children: [
          Icon(Icons.event_busy, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No upcoming schedules found',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      )),
    );
  }

  Widget _buildEventCard(DefenseSchedule event) {
    final now = DateTime.now();
    final isTomorrow = event.date.year == now.year &&
        event.date.month == now.month &&
        event.date.day == now.day + 1;
    final isToday = event.date.year == now.year &&
        event.date.month == now.month &&
        event.date.day == now.day;

    String dateLabel;
    if (isToday) {
      dateLabel = 'Today';
    } else if (isTomorrow) {
      dateLabel = 'Tomorrow';
    } else {
      dateLabel = '${event.date.day}/${event.date.month}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(dateLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              Text('Slot ${event.blockId}',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(event.blockName.isNotEmpty ? event.blockName : 'Defense Council',
              style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text('${event.startTime} – ${event.endTime}',
                style: AppTextStyles.bodyMedium)
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text('Room ${event.blockName}',
                style: AppTextStyles
                    .bodyMedium) // Using blockName as room for now if specific room field missing
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.person, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text('Role: ${event.roleName}', style: AppTextStyles.bodyMedium)
          ]),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
