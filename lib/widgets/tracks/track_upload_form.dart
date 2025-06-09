import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:jammies_app/services/track_services.dart';

class TrackUploadForm extends StatefulWidget {
  final Function(String, File, File) onUpload;
  final bool isLoading;

  const TrackUploadForm({
    Key? key,
    required this.onUpload,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<TrackUploadForm> createState() => _TrackUploadFormState();
}

class _TrackUploadFormState extends State<TrackUploadForm>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  File? _audioFile;
  File? _coverFile;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickCoverFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _coverFile = File(result.files.single.path!);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _audioFile != null &&
        _coverFile != null) {
      widget.onUpload(_titleController.text, _audioFile!, _coverFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF1a1a2e), const Color(0xFF16213e)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2d3748).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4c1d95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Upload New Track',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Title Input
              _buildInputField(
                label: 'Track Title',
                child: TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter track title...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color(0xFF2d3748),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF7c3aed),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a track title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Audio File Picker
              _buildInputField(
                label: 'Audio File',
                child: _buildFilePicker(
                  label:
                      _audioFile != null
                          ? _audioFile!.path.split('/').last
                          : 'Choose audio file',
                  icon: Icons.audiotrack,
                  onTap: _pickAudioFile,
                  hasFile: _audioFile != null,
                ),
              ),
              const SizedBox(height: 24),

              // Cover Image Picker
              _buildInputField(
                label: 'Cover Image',
                child: _buildFilePicker(
                  label:
                      _coverFile != null
                          ? _coverFile!.path.split('/').last
                          : 'Choose cover image',
                  icon: Icons.image,
                  onTap: _pickCoverFile,
                  hasFile: _coverFile != null,
                ),
              ),
              const SizedBox(height: 32),

              // Upload Button
              ElevatedButton(
                onPressed: widget.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7c3aed),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF7c3aed).withOpacity(0.4),
                ),
                child:
                    widget.isLoading
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Uploading...'),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_upload),
                            const SizedBox(width: 8),
                            const Text(
                              'Upload Track',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildFilePicker({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool hasFile,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2d3748),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasFile ? const Color(0xFF7c3aed) : Colors.transparent,
            width: hasFile ? 2 : 0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    hasFile ? const Color(0xFF7c3aed) : const Color(0xFF4a5568),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: hasFile ? Colors.white : Colors.grey[400],
                  fontSize: 14,
                  fontWeight: hasFile ? FontWeight.w500 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.folder_open, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
