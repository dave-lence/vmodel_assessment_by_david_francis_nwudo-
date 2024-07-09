import 'package:flutter/material.dart';
import 'package:vmodel_test/models/blog_model.dart';
import 'package:vmodel_test/screens/update_blog_screen.dart';

class BlogDetailScreen extends StatefulWidget {
  final BlogPost blog;

  BlogDetailScreen({required this.blog});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  late BlogPost lateBlog;

  @override
  void initState() {
    super.initState();
    lateBlog = widget.blog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/download.jpeg',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                lateBlog.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                lateBlog.subTitle,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline),
              ),
              const SizedBox(height: 16),
              Text(
                lateBlog.body,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'Date Created: ${lateBlog.dateCreated}',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fixedSize: Size(MediaQuery.of(context).size.width, 45),
                  backgroundColor: Colors.black),
              onPressed: () async {
                final updatedBlog = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateBlogPostScreen(blog: widget.blog)));

                if (updatedBlog != null) {
                  setState(() {
                    lateBlog = updatedBlog;
                  });
                }
              },
              child: const Text(
                'Edit blog',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
        ),
      ),
    );
  }
}
