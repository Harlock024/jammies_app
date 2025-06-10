import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:jammies_app/services/track_services.dart';
import 'package:jammies_app/widgets/tracks/track_upload_form.dart';

class TrackUploadScreen extends StatefulWidget {
  const TrackUploadScreen({Key? key}) : super(key: key);

  @override
  State<TrackUploadScreen> createState() => _TrackUploadScreenState();
}

class _TrackUploadScreenState extends State<TrackUploadScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  String? _uploadMessage;
  bool _isSuccess = false;

  final TrackService _trackService = TrackService();

  late AnimationController _backgroundController;
  late AnimationController _successController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );
    _successAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _successController.dispose();
    super.dispose();
  }

  // Aquí integrarías tu función postTrack
  Future<void> _uploadTrack(
    String title,
    File audioFile,
    File coverFile,
  ) async {
    setState(() {
      _isLoading = true;
      _uploadMessage = null;
      _isSuccess = false;
    });

    try {
      final audioMultipart = MultipartFile.fromBytes(
        await audioFile.readAsBytes(),
        filename: audioFile.path.split('/').last,
      );

      final coverMultipart = MultipartFile.fromBytes(
        await coverFile.readAsBytes(),
        filename: coverFile.path.split('/').last,
      );
      if (await _trackService.createTrack(
        title,
        audioMultipart,
        coverMultipart,
      )) {
        _uploadMessage = 'Track uploaded successfully! 🎵';
        _isSuccess = true;
        _isLoading = false;
      } else {
        _uploadMessage = 'Track upload failed!';
        _isSuccess = false;
        _isLoading = false;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _uploadMessage = 'Upload failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f23),
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.0 + (_backgroundAnimation.value * 0.3),
                colors: [
                  Color.lerp(
                    const Color(0xFF1a1a2e),
                    const Color(0xFF7c3aed),
                    _backgroundAnimation.value * 0.1,
                  )!,
                  const Color(0xFF0f0f23),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar personalizada
                  _buildCustomAppBar(),

                  // Contenido principal
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          const SizedBox(height: 32),

                          TrackUploadForm(
                            onUpload: _uploadTrack,
                            isLoading: _isLoading,
                          ),

                          const SizedBox(height: 24),

                          // Mensaje de estado
                          if (_uploadMessage != null) _buildStatusMessage(),

                          const SizedBox(height: 32),

                          // Tips section
                          _buildTipsSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2d3748).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF4a5568).withOpacity(0.5),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Upload Track',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF7c3aed).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF7c3aed).withOpacity(0.3),
              ),
            ),
            child: const Icon(
              Icons.help_outline,
              color: Color(0xFF7c3aed),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF7c3aed).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF7c3aed), size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatusMessage() {
    return AnimatedBuilder(
      animation: _successAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isSuccess ? _successAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  _isSuccess
                      ? const Color(0xFF10b981).withOpacity(0.2)
                      : const Color(0xFFef4444).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _isSuccess
                        ? const Color(0xFF10b981)
                        : const Color(0xFFef4444),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isSuccess ? Icons.check_circle : Icons.error,
                  color:
                      _isSuccess
                          ? const Color(0xFF10b981)
                          : const Color(0xFFef4444),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _uploadMessage!,
                    style: TextStyle(
                      color:
                          _isSuccess
                              ? const Color(0xFF10b981)
                              : const Color(0xFFef4444),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a202c).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2d3748).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3b82f6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF3b82f6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Upload Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem('Use high-quality audio files (320kbps MP3 or FLAC)'),
          _buildTipItem('Cover images should be at least 1000x1000 pixels'),
          _buildTipItem('Choose descriptive titles for better discoverability'),
          _buildTipItem('Supported audio formats: MP3, WAV, FLAC, M4A'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF3b82f6),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
