const String createBlogPostMutation = """
mutation createBlogPost(\$title: String!, \$subTitle: String!, \$body: String!) {
  createBlog(title: \$title, subTitle: \$subTitle, body: \$body) {
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
