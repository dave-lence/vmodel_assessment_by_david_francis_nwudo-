import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vmodel_test/mutations/create_blog.dart';
import 'package:vmodel_test/mutations/fetch_blogs.dart';

class CreateBlogPostScreen extends StatefulWidget {
  const CreateBlogPostScreen({super.key});

  @override
  CreateBlogPostScreenState createState() => CreateBlogPostScreenState();
}

class CreateBlogPostScreenState extends State<CreateBlogPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subTitleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white, title: const Text('Create Blog Post')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _subTitleController,
                  decoration: const InputDecoration(labelText: 'Subtitle'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subtitle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(labelText: 'Body'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the body of the blog post';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Mutation(
        options: MutationOptions(
          document: gql(createBlogPostMutation),
          onCompleted: (dynamic resultData) {
            if (resultData != null && resultData['createBlog']['success']) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Blog post created successfully!')),
              );
              GraphQLProvider.of(context).value.query(QueryOptions(
                    document: gql(fetchAllBlogsQuery),
                  ));
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to create blog post')),
              );
            }
          },
        ),
        builder: (RunMutation runMutation, QueryResult? result) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size(MediaQuery.of(context).size.width, 45),
                    backgroundColor: Colors.black),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    runMutation({
                      'title': _titleController.text,
                      'subTitle': _subTitleController.text,
                      'body': _bodyController.text,
                    });
                  }
                },
                child: const Text(
                  'Create Blog Post',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
