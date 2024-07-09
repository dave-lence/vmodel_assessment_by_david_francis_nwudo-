const String updateBlogPostMutation = """
  mutation updateBlogPost(\$blogId: String!, \$title: String!, \$subTitle: String!, \$body: String!) {
    updateBlog(blogId: \$blogId, title: \$title, subTitle: \$subTitle, body: \$body) {
      success
      blogPost {
        id
        title
        subTitle
        body
        dateCreated
      }
    }
  }
""";
