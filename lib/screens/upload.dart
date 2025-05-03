import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  String? selectedAlbum;
  String? coverPath;
  String? audioPath;

  List<String> albums = ['Álbum 1', 'Álbum 2', 'Single'];

  void pickCover() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        coverPath = result.files.single.path;
      });
    }
  }

  void pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        audioPath = result.files.single.path;
      });
    }
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      print('Canción: ${nameController.text}');
      print('Álbum: $selectedAlbum');
      print('Portada: $coverPath');
      print('Audio: $audioPath');
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF86CECB)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF86CECB)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF86CECB), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _styledButton(
    String text,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF86CECB) : Colors.white,
        foregroundColor: isPrimary ? Colors.white : const Color(0xFF86CECB),
        side: isPrimary ? null : const BorderSide(color: Color(0xFF86CECB)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isPrimary ? 2 : 0,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Upload your Track"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF86CECB),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: _inputDecoration("Nombre de la canción"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedAlbum,
                decoration: _inputDecoration("Selecciona un álbum"),
                items:
                    albums
                        .map(
                          (album) => DropdownMenuItem(
                            value: album,
                            child: Text(album),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAlbum = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Selecciona un álbum' : null,
              ),
              const SizedBox(height: 20),
              _styledButton(
                coverPath == null
                    ? "Seleccionar portada"
                    : "Portada seleccionada ",
                pickCover,
              ),
              const SizedBox(height: 12),
              _styledButton(
                audioPath == null ? "Seleccionar audio" : "Audio seleccionado ",
                pickAudio,
              ),
              const SizedBox(height: 32),
              _styledButton("Subir canción", submit, isPrimary: true),
            ],
          ),
        ),
      ),
    );
  }
}
