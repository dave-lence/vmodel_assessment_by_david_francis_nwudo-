// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vmodel_test/models/blog_model.dart';
import 'package:vmodel_test/mutations/delete_blog.dart';
import 'package:vmodel_test/mutations/fetch_blogs.dart';
import 'package:vmodel_test/screens/blog_details_screen.dart';
import 'package:vmodel_test/screens/create_blog_screen.dart';
import 'package:vmodel_test/utils/loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> deleteBlogPost(String blogId, RunMutation runMutation) async {
    try {
      await runMutation({
        'blogId': blogId,
      });
      Navigator.pop(context, true); // Return to previous screen
    } catch (error) {
      AlertDialog(
        title: const Text('Error'),
        content: Text(error.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Okay'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Blog Posts'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(fetchAllBlogsQuery),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const Center(child: DottedLoader());
          }

          if (result.hasException) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${result.exception.toString()}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      refetch!();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          List<dynamic> allBlogPosts = result.data!['allBlogPosts'];
          List<BlogPost> blogPosts =
              allBlogPosts.map((json) => BlogPost.fromJson(json)).toList();
          if (blogPosts.isEmpty) {
            return const Center(child: Text('No blog posts found.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              refetch!();
            },
            child: ListView.builder(
              itemCount: blogPosts.length,
              itemBuilder: (context, index) {
                final blogPost = blogPosts[index];

                return Dismissible(
                  key: Key(blogPost.id),
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text(
                              'Are you sure you want to delete this item?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (DismissDirection direction) async {
                    // Perform the delete operation
                    MutationOptions options = MutationOptions(
                      document: gql(deleteBlogMutation),
                      variables: {'blogId': blogPost.id},
                      onCompleted: (dynamic resultData) {
                        if (resultData['deleteBlog']['success']) {
                          // Update UI by refetching data
                          refetch!();
                        }
                      },
                      onError: (OperationException? error) {
                        if (error != null) {
                          AlertDialog(
                            title: const Text('Error'),
                            content: Text('${error.graphqlErrors}'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Okay'),
                              ),
                            ],
                          );
                        }
                      },
                    );

                    // Run the mutation
                    await GraphQLProvider.of(context).value.mutate(options);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Blog post deleted successfully!')),
                    );
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/download.jpeg',
                        height: 120,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      blogPost.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(blogPost.subTitle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetailScreen(
                            blog: blogPost,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(50)),
        child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateBlogPostScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
    );
  }
}
