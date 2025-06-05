import 'package:flutter/material.dart';
import 'package:jammies_app/widgets/posts/post_form.dart';
import 'package:jammies_app/widgets/posts/post_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Scaffold(
        appBar: AppBar(title: Text('Inicio')),
        body: PostList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showPostForm(context),
          backgroundColor: const Color(0xFF86CECB),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}

void _showPostForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: PostForm(),
      );
    },
  );
}
