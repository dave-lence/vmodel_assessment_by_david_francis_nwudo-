const String deleteBlogMutation =
    """ mutation deleteBlogPost(\$blogId: String!) {
  deleteBlog(blogId: \$blogId) {
    success
  }
} """;
