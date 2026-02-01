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

  @override
  void initState() {
    super.initState();
    _fetchDays();
  }

  Future<void> _fetchDays() async {
    try {
      final days = await _api.getDefenseDays(widget.roundId);
      if (mounted) {
        setState(() {
          _days = days;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleAvailability(String dayId, bool value) async {
    setState(() {
      if (value) {
        _selectedDays.add(dayId);
      } else {
        _selectedDays.remove(dayId);
      }
    });

    try {
      final day = _days.firstWhere((d) => d.id == dayId);
      // Gọi API thực
      await _api.registerAvailability(day.roundId, day.date, value);
    } catch (e) {
      // Revert nếu lỗi
      setState(() {
        if (value) {
          _selectedDays.remove(dayId);
        } else {
          _selectedDays.add(dayId);
        }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                final formattedDate =
                    DateFormat('EEEE, dd/MM/yyyy').format(day.date);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: CheckboxListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      formattedDate,
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      isSelected ? 'You are available' : 'Not registered',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                    value: isSelected,
                    activeColor: AppColors.primary,
                    onChanged: (bool? value) {
                      if (value != null) {
                        _toggleAvailability(day.id, value);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
