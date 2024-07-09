const String fetchAllBlogsQuery = """
    query fetchAllBlogs {
      allBlogPosts {
        id
        title
        subTitle
        body
        dateCreated
      }
    }
  """;