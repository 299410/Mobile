import 'package:flutter/material.dart';
import 'package:api/api.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';
import 'package:intl/intl.dart';

class LecturerAvailabilityScreen extends StatefulWidget {
  final String roundId;
  final String roundName;

  const LecturerAvailabilityScreen({
    super.key,
    required this.roundId,
    required this.roundName,
  });

  @override
  State<LecturerAvailabilityScreen> createState() =>
      _LecturerAvailabilityScreenState();
}

class _LecturerAvailabilityScreenState
    extends State<LecturerAvailabilityScreen> {
  final LecturerApi _api = LecturerApi();
  List<DefenseDay> _days = [];
  bool _isLoading = true;
  // Giả lập lưu trạng thái đã tick (trong thực tế API sẽ trả về status hiện tại)
  final Set<String> _selectedDays = {};
  String? _processingDayId;

  @override
  void initState() {
    super.initState();
    _fetchDays();
  }

  Future<void> _fetchDays() async {
    try {
      // Fetch both valid days and my availability in parallel
      final results = await Future.wait([
        _api.getDefenseDays(widget.roundId),
        _api.getLecturerAvailability(widget.roundId),
      ]);

      final validDays = results[0] as List<DefenseDay>;
      final myAvailability = results[1] as List<DateTime>;

      // Normalize dates to remove time components for comparison
      final myDates =
          myAvailability.map((d) => DateTime(d.year, d.month, d.day)).toSet();

      if (mounted) {
        setState(() {
          _days = validDays;
          _selectedDays.clear();
          for (var day in validDays) {
            final date = DateTime(day.date.year, day.date.month, day.date.day);
            // Check if this date (or string representation) matches my availability
            final isAvailable = myDates.any((myDate) =>
                myDate.year == date.year &&
                myDate.month == date.month &&
                myDate.day == date.day);

            if (isAvailable) {
              _selectedDays.add(day.id);
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  void _showCancelConfirmation(String dayId, DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Registration?', style: AppTextStyles.h2),
        content: Text(
          'Are you sure you want to cancel your availability for ${DateFormat('dd/MM/yyyy').format(date)}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _toggleAvailability(dayId, false);
            },
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleAvailability(String dayId, bool value) async {
    setState(() {
      _processingDayId = dayId;
    });

    try {
      final day = _days.firstWhere((d) => d.id == dayId);
      await _api.registerAvailability(day.roundId, day.date, value);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value ? 'Date registered' : 'Date unregistered'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Wait for a short delay to let user see the message before changing state
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          setState(() {
            _processingDayId = null;
            if (value) {
              _selectedDays.add(dayId);
            } else {
              _selectedDays.remove(dayId);
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _processingDayId = null);
        // Clean up error message by removing "Exception:" prefix
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roundName),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];

                final isSelected = _selectedDays.contains(day.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          // Status Strip
                          Container(
                            width: 6,
                            color: isSelected
                                ? const Color.from(
                                    alpha: 1,
                                    red: 0.063,
                                    green: 0.725,
                                    blue: 0.506)
                                : AppColors.textSecondary
                                    .withValues(alpha: 0.2),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Date Display
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        day.date.day.toString().padLeft(2, '0'),
                                        style: AppTextStyles.h2.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('E')
                                            .format(day.date)
                                            .toUpperCase(),
                                        style:
                                            AppTextStyles.bodyMedium.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  // Month & Status
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('MMMM yyyy')
                                              .format(day.date),
                                          style:
                                              AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color.from(
                                                        alpha: 1,
                                                        red: 0.063,
                                                        green: 0.725,
                                                        blue: 0.506)
                                                    .withValues(alpha: 0.1)
                                                : AppColors.textSecondary
                                                    .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            isSelected
                                                ? 'Registered'
                                                : 'Available',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? const Color.from(
                                                      alpha: 1,
                                                      red: 0.063,
                                                      green: 0.725,
                                                      blue: 0.506)
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Action Button
                                  if (day.id == _processingDayId)
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          isSelected
                                              ? AppColors.error
                                              : AppColors.primary,
                                        ),
                                      ),
                                    )
                                  else if (isSelected)
                                    TextButton(
                                      onPressed: () => _showCancelConfirmation(
                                          day.id, day.date),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.error,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () =>
                                          _toggleAvailability(day.id, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.onPrimary,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: isSmallScreen ? 12 : 20,
                                            vertical: isSmallScreen ? 8 : 12),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text('Register'),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
