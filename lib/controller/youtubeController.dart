import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:convert';
import 'dart:async';

class CourseController {
  static const String PREFS_COINS = 'coins';
  static const String PREFS_WATCHED_MINUTES = 'watched_minutes';
  static const String PREFS_LAST_WATCH_DATE = 'last_watch_date';
  static const String PREFS_TARGET_ACHIEVED = 'target_achieved';
  static const apiKey = 'AIzaSyBECCdiT6qc2bANTxprUWfvECurFWmpRKI';

  final Function(void Function()) setState;
  YoutubePlayerController? youtubeController;
  List<YoutubeVideoData> videos = [];
  bool isLoading = false;
  String? selectedVideoId;
  int totalMinutes = 0;
  double? dailyTargetMinutes;
  int coins = 0;
  int todayWatchedMinutes = 0;
  DateTime? lastWatchDate;
  bool targetAchievedToday = false;
  Function? onTargetAchieved;

  CourseController(this.setState);

  Future<void> initialize() async {
    await loadUserProgress();
  }

  Future<void> loadUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt(PREFS_COINS) ?? 0;
      todayWatchedMinutes = prefs.getInt(PREFS_WATCHED_MINUTES) ?? 0;
      targetAchievedToday = prefs.getBool(PREFS_TARGET_ACHIEVED) ?? false;

      final lastWatchString = prefs.getString(PREFS_LAST_WATCH_DATE);
      if (lastWatchString != null) {
        lastWatchDate = DateTime.parse(lastWatchString);
        if (!_isSameDay(DateTime.now(), lastWatchDate!)) {
          todayWatchedMinutes = 0;
          targetAchievedToday = false;
          saveProgress();
        }
      }
    });
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PREFS_COINS, coins);
    await prefs.setInt(PREFS_WATCHED_MINUTES, todayWatchedMinutes);
    await prefs.setBool(PREFS_TARGET_ACHIEVED, targetAchievedToday);
    await prefs.setString(
        PREFS_LAST_WATCH_DATE, DateTime.now().toIso8601String());
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void updateWatchProgress(int minutes) {
    if (dailyTargetMinutes != null) {
      setState(() {
        todayWatchedMinutes += minutes;
        lastWatchDate = DateTime.now();

        if (todayWatchedMinutes >= dailyTargetMinutes! &&
            !targetAchievedToday) {
          coins += 10;
          targetAchievedToday = true;
          onTargetAchieved?.call();
        }
      });
      saveProgress();
    }
  }

  void calculateDailyTarget(String monthsText) {
    if (monthsText.isEmpty) return;

    int months = int.tryParse(monthsText) ?? 0;
    if (months <= 0) return;

    int totalDays = months * 30;
    setState(() {
      dailyTargetMinutes = totalMinutes / totalDays;
    });
  }

  Future<void> searchVideos(String searchText) async {
    if (searchText.isEmpty) return;

    setState(() {
      isLoading = true;
      videos.clear();
      selectedVideoId = null;
      totalMinutes = 0;
      dailyTargetMinutes = null;
    });

    try {
      final searchQuery = '$searchText complete course tutorial playlist';
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet'
          '&q=$searchQuery'
          '&type=video'
          '&videoDuration=long'
          '&videoDefinition=high'
          '&relevanceLanguage=en'
          '&order=relevance'
          '&maxResults=10'
          '&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        final videoIds = items.map((item) => item['id']['videoId']).join(',');
        final statsResponse = await http.get(
          Uri.parse(
            'https://www.googleapis.com/youtube/v3/videos?part=statistics,contentDetails,snippet'
            '&id=$videoIds'
            '&key=$apiKey',
          ),
        );

        if (statsResponse.statusCode == 200) {
          final statsData = json.decode(statsResponse.body);
          final statsItems = statsData['items'] as List;

          final processedVideos = _processVideoData(statsItems);

          setState(() {
            videos = processedVideos;
            totalMinutes = videos.fold(0, (sum, video) => sum + video.minutes);

            if (videos.isNotEmpty) {
              selectedVideoId = videos.first.id;
              initializeYoutubeController(selectedVideoId!);
            }
          });
        }
      }
    } catch (e) {
      print('Error searching videos: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<YoutubeVideoData> _processVideoData(List statsItems) {
    final processedVideos = statsItems.map((stats) {
      final videoSnippet = stats['snippet'];
      final duration = stats['contentDetails']['duration'];
      final minutes = _parseDuration(duration);

      final viewCount = int.parse(stats['statistics']['viewCount']);
      final likeCount =
          int.tryParse(stats['statistics']['likeCount'] ?? '0') ?? 0;
      final title = videoSnippet['title'].toString().toLowerCase();
      final description = videoSnippet['description'].toString().toLowerCase();

      final bool hasEducationalKeywords =
          _hasEducationalKeywords(title, description);
      final relevanceScore = _calculateRelevanceScore(
          viewCount, likeCount, hasEducationalKeywords, minutes);

      return {
        'video': YoutubeVideoData(
          id: stats['id'],
          title: videoSnippet['title'],
          thumbnail: videoSnippet['thumbnails']['high']['url'],
          channelTitle: videoSnippet['channelTitle'],
          viewCount: viewCount,
          duration: duration,
          minutes: minutes,
        ),
        'relevanceScore': relevanceScore,
      };
    }).toList();

    processedVideos.sort((a, b) =>
        (b['relevanceScore'] as num).compareTo(a['relevanceScore'] as num));

    return processedVideos
        .where((v) => (v['video'] as YoutubeVideoData).minutes >= 10)
        .map((v) => v['video'] as YoutubeVideoData)
        .take(5)
        .toList();
  }

  bool _hasEducationalKeywords(String title, String description) {
    return title.contains('course') ||
        title.contains('tutorial') ||
        title.contains('learn') ||
        title.contains('complete') ||
        description.contains('curriculum') ||
        description.contains('learn');
  }

  num _calculateRelevanceScore(
      int viewCount, int likeCount, bool hasEducationalKeywords, int minutes) {
    return (viewCount / 1000) +
        (likeCount * 10) +
        (hasEducationalKeywords ? 10000 : 0) +
        (minutes > 20 ? 5000 : 0);
  }

  Future<void> initializeYoutubeController(String videoId) async {
    if (youtubeController != null) {
      await youtubeController!.loadVideoById(videoId: videoId);
    } else {
      youtubeController = YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
          loop: false,
        ),
      );

      youtubeController?.listen((event) {
        if (event.playerState == PlayerState.ended) {
          final video = videos.firstWhere((v) => v.id == selectedVideoId);
          updateWatchProgress(video.minutes);
        }
      });

      await youtubeController?.loadVideoById(videoId: videoId);
    }

    setState(() {
      selectedVideoId = videoId;
    });
  }

  int _parseDuration(String duration) {
    duration = duration.replaceAll('PT', '');
    final hours = RegExp(r'(\d+)H').firstMatch(duration)?.group(1);
    final minutes = RegExp(r'(\d+)M').firstMatch(duration)?.group(1);
    final seconds = RegExp(r'(\d+)S').firstMatch(duration)?.group(1);

    int totalMinutes = 0;
    if (hours != null) totalMinutes += int.parse(hours) * 60;
    if (minutes != null) totalMinutes += int.parse(minutes);
    if (seconds != null) totalMinutes += (int.parse(seconds) / 60).ceil();

    return totalMinutes;
  }

  String formatViewCount(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    }
    return '$views views';
  }

  void dispose() {
    youtubeController?.close();
  }
}

class YoutubeVideoData {
  final String id;
  final String title;
  final String thumbnail;
  final String channelTitle;
  final int viewCount;
  final String duration;
  final int minutes;

  YoutubeVideoData({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.channelTitle,
    required this.viewCount,
    required this.duration,
    required this.minutes,
  });
}
