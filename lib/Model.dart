class Blog {
  final String title;
  final String imageUrl;
  bool isLiked;
  Blog({required this.title, required this.imageUrl,this.isLiked =false});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'],
      imageUrl: json['image_url'],
    );
  }
}
