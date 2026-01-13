import 'package:flutter/material.dart';
import '../models/activity_log.dart';
import '../models/daily_goals.dart';
import '../widgets/bottom_nav.dart';
import 'add_activity_page.dart';

class ActivityPage extends StatelessWidget {
  final Function(String, {String? activity}) navigateTo;
  final List<ActivityLog> activities;
  final DailyGoals dailyGoals;

  const ActivityPage({
    super.key,
    required this.navigateTo,
    required this.activities,
    required this.dailyGoals,
  });

  int _getTotalCaloriesBurned() {
    return activities.fold(0, (sum, a) => sum + a.caloriesBurned);
  }

  Map<String, dynamic> _getActivityStats(ActivityType type) {
    final filtered = activities.where((a) => a.type == type).toList();
    final totalDuration = filtered.fold(0, (sum, a) => sum + a.duration);
    final totalCalories = filtered.fold(0, (sum, a) => sum + a.caloriesBurned);
    return {
      'count': filtered.length,
      'duration': totalDuration,
      'calories': totalCalories,
    };
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final totalCaloriesBurned = _getTotalCaloriesBurned();
    final dailyBurnGoal = dailyGoals.caloriesToBurn;
    final remainingCalories = (dailyBurnGoal - totalCaloriesBurned).clamp(0, double.infinity).toInt();
    final progressPercentage = (totalCaloriesBurned / dailyBurnGoal * 100).clamp(0.0, 100.0);

    final walkingStats = _getActivityStats(ActivityType.walking);
    final runningStats = _getActivityStats(ActivityType.running);
    final cyclingStats = _getActivityStats(ActivityType.cycling);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.4),
                    width: 1,
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activity Goal Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.local_fire_department, color: Color(0xFFEA580C), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Daily Burn Goal',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFEA580C), Color(0xFFDC2626)],
                            ).createShader(bounds),
                            child: Text(
                              '$totalCaloriesBurned',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'of $dailyBurnGoal calories burned',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: progressPercentage / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEA580C)),
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress: ${progressPercentage.round()}%',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              Text(
                                remainingCalories > 0
                                    ? '$remainingCalories cal remaining'
                                    : 'Goal achieved! 🎉',
                                style: TextStyle(
                                  color: remainingCalories > 0
                                      ? const Color(0xFFEA580C)
                                      : const Color(0xFF14B8A6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'Log Activity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActivityButton(
                            context,
                            'walking',
                            Icons.directions_walk,
                            'Walk',
                            walkingStats['calories'] as int,
                            () => navigateTo('addactivity', activity: 'walking'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActivityButton(
                            context,
                            'running',
                            Icons.directions_run,
                            'Running',
                            runningStats['calories'] as int,
                            () => navigateTo('addactivity', activity: 'running'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActivityButton(
                            context,
                            'cycling',
                            Icons.directions_bike,
                            'Cycling',
                            cyclingStats['calories'] as int,
                            () => navigateTo('addactivity', activity: 'cycling'),
                          ),
                        ),
                      ],
                    ),

                    if (totalCaloriesBurned > 0) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard('Activities', activities.length.toString()),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Minutes',
                              activities.fold(0, (sum, a) => sum + a.duration).toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Avg Cal/Min',
                              activities.isNotEmpty
                                  ? (totalCaloriesBurned /
                                          activities.fold(0, (sum, a) => sum + a.duration))
                                      .round()
                                      .toString()
                                  : '0',
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Recent Activities
                    const Text(
                      'Recent Activities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (activities.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.trending_up, color: Colors.white, size: 32),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No activities logged yet',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Start logging your workouts to track calories burned!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...activities.reversed.take(5).map((activity) {
                        return _buildActivityCard(activity);
                      }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentPage: 'activity',
        onNavigate: (page) => navigateTo(page),
      ),
    );
  }

  Widget _buildActivityButton(
    BuildContext context,
    String type,
    IconData icon,
    String label,
    int calories,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF14B8A6), size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (calories > 0) ...[
              const SizedBox(height: 4),
              Text(
                '$calories cal',
                style: const TextStyle(
                  color: Color(0xFF14B8A6),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(ActivityLog activity) {
    final emoji = activity.type == ActivityType.walking
        ? '🚶'
        : activity.type == ActivityType.running
            ? '🏃'
            : '🚴';
    final name = activity.type == ActivityType.walking
        ? 'Walking'
        : activity.type == ActivityType.running
            ? 'Running'
            : 'Cycling';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      '${activity.duration} min • ${_formatTime(activity.timestamp)}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)],
                ).createShader(bounds),
                child: Text(
                  '${activity.caloriesBurned}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                'cal',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
