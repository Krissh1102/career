import 'package:career/controller/youtubeController.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:async';

class TopCourseVideosScreen extends StatefulWidget {
  const TopCourseVideosScreen({super.key});

  @override
  State<TopCourseVideosScreen> createState() => _TopCourseVideosScreenState();
}

class _TopCourseVideosScreenState extends State<TopCourseVideosScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  late final CourseController _controller;
  Timer? _progressTimer;
  int coins = 0; 

  @override
  void initState() {
    super.initState();
    _controller = CourseController(setState);
    _controller.onTargetAchieved = _showRewardDialog;
    _controller.initialize();
    _startProgressTracking();
  }

  void _startProgressTracking() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_controller.youtubeController?.value.playerState ==
          PlayerState.playing) {
        setState(() {
          _controller.updateWatchProgress(1);
        });
      }
    });
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Daily Target Achieved! 🎉',
            style: TextStyle(color: Colors.cyan.shade700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stars, color: Colors.amber, size: 60),
            const SizedBox(height: 16),
            const Text('Congratulations! You\'ve earned'),
            const SizedBox(height: 8),
            Text('10 Coins',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                coins += 10; // Add coins when target is achieved
              });
              Navigator.pop(context);
            },
            child: Text('Continue Learning',
                style: TextStyle(color: Colors.cyan.shade700)),
          ),
        ],
      ),
    );
  }
  

  @override
  void dispose() {
    _searchController.dispose();
    _monthsController.dispose();
    _progressTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.cyan.shade50,
              Colors.white,
              Colors.amber.shade50,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.cyan.shade700, Colors.cyan.shade400],
                    ),
                  ),
                ),
                title: const Text(
                  'Course Planning Assistant',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
              actions: [
                // Add coin display in AppBar
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber.shade300),
                      const SizedBox(width: 4),
                      Text(
                        coins.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchCard(),
                    const SizedBox(height: 24),
                    if (_controller.isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.cyan.shade700,
                        ),
                      )
                    else if (_controller.selectedVideoId != null &&
                        _controller.youtubeController != null)
                      _buildVideoSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_controller.dailyTargetMinutes != null) _buildProgressCard(),
            _buildSearchField(),
            if (_controller.totalMinutes > 0) ...[
              const SizedBox(height: 16),
              _buildDurationInfo(),
              const SizedBox(height: 16),
              _buildMonthsInput(),
              if (_controller.dailyTargetMinutes != null)
                _buildDailyTargetCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    if (_controller.dailyTargetMinutes == null) return const SizedBox.shrink();

    final progress =
        _controller.todayWatchedMinutes / _controller.dailyTargetMinutes!;
    final isTargetAchieved = progress >= 1.0;

    return Card(
      color: Colors.cyan[100],
      margin: const EdgeInsets.all(30),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Daily Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.cyan.shade700,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              color: isTargetAchieved ? Colors.green : Colors.amber,
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              '${_controller.todayWatchedMinutes}/${_controller.dailyTargetMinutes!.ceil()} minutes',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isTargetAchieved) ...[
              const SizedBox(height: 8),
              const Text(
                '🎉 Daily target achieved! 🎉',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Enter course name',
        labelStyle: TextStyle(color: Colors.cyan.shade700),
        prefixIcon: Icon(Icons.school, color: Colors.cyan),
        suffixIcon: IconButton(
          icon: Icon(Icons.search, color: Colors.amber),
          onPressed: () => _controller.searchVideos(_searchController.text),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.cyan.shade700),
        ),
      ),
      onSubmitted: (value) => _controller.searchVideos(value),
    );
  }

  Widget _buildDurationInfo() {
    return Text(
      'Total Course Duration: ${(_controller.totalMinutes / 60).floor()}h ${_controller.totalMinutes % 60}m',
      style: TextStyle(
        fontSize: 16,
        color: Colors.cyan.shade700,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMonthsInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _monthsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Months to complete',
              labelStyle: TextStyle(color: Colors.cyan.shade700),
              prefixIcon: Icon(Icons.calendar_today, color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () =>
              _controller.calculateDailyTarget(_monthsController.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Calculate'),
        ),
      ],
    );
  }

  Widget _buildDailyTargetCard() {
    return Card(
      color: Colors.cyan.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.bolt, color: Colors.amber, size: 40),
            const SizedBox(height: 8),
            Text(
              'Daily Study Target',
              style: TextStyle(
                fontSize: 18,
                color: Colors.cyan.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_controller.dailyTargetMinutes!.ceil()} minutes per day',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: YoutubePlayer(
                    controller: _controller.youtubeController!,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _controller.videos
                      .firstWhere((v) => v.id == _controller.selectedVideoId)
                      .title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._controller.videos.map((video) => _buildVideoListItem(video)),
      ],
    );
  }

  Widget _buildVideoListItem(YoutubeVideoData video) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            video.thumbnail,
            width: 120,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          video.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${video.channelTitle}\n${_controller.formatViewCount(video.viewCount)} • ${video.minutes} minutes',
        ),
        selected: _controller.selectedVideoId == video.id,
        selectedTileColor: Colors.cyan.shade50,
        onTap: () => _controller.initializeYoutubeController(video.id),
      ),
    );
  }
}
