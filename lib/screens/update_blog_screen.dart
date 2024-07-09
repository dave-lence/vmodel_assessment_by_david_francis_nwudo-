import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vmodel_test/models/blog_model.dart';
import 'package:vmodel_test/mutations/update_blog.dart';
import 'package:vmodel_test/utils/loader.dart';

class UpdateBlogPostScreen extends StatefulWidget {
  final BlogPost blog;

  const UpdateBlogPostScreen({super.key, required this.blog});

  @override
  UpdateBlogPostScreenState createState() => UpdateBlogPostScreenState();
}

class UpdateBlogPostScreenState extends State<UpdateBlogPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subTitleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog.title);
    _subTitleController = TextEditingController(text: widget.blog.subTitle);
    _bodyController = TextEditingController(text: widget.blog.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Update Blog Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Mutation(
            options: MutationOptions(
              document: gql(updateBlogPostMutation),
              onCompleted: (dynamic resultData) {
                if (resultData['updateBlog']['success']) {
                  BlogPost updatedBlog =
                      BlogPost.fromJson(resultData['updateBlog']['blogPost']);

                  Navigator.pop(context, updatedBlog);
                }
              },
            ),
            builder: (RunMutation runMutation, QueryResult? result) {
              return Form(
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
                      decoration: const InputDecoration(labelText: 'SubTitle'),
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
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the body text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (result != null && result.isLoading)
                      const Center(child: DottedLoader()),
                    if (result != null && result.hasException)
                      Text('Error: ${result.exception.toString()}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.42),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 45),
                          backgroundColor: Colors.black),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          runMutation({
                            'blogId': widget.blog.id,
                            'title': _titleController.text,
                            'subTitle': _subTitleController.text,
                            'body': _bodyController.text,
                          });
                        }
                      },
                      child: const Text(
                        'Update Blog Post',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
