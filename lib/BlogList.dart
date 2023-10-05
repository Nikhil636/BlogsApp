import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'BlogDetail.dart';
import 'LikedBlogs.dart';
import 'Model.dart';

class LikedBlogsProvider extends ChangeNotifier {
  List<Blog> _likedBlogs = [];

  List<Blog> get likedBlogs => _likedBlogs;

  void addLikedBlog(Blog blog) {
    if (!_likedBlogs.contains(blog)) {
      _likedBlogs.add(blog);
      notifyListeners();
    }
  }
  void removeLikedBlog(Blog blog) {
    _likedBlogs.remove(blog);
    notifyListeners();
  }
}

class BlogList extends StatefulWidget {
  const BlogList({Key? key}) : super(key: key);

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  late List<Blog> blogs = [];

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> blogList = jsonResponse['blogs'];
      setState(() {
        blogs = blogList.map((json) => Blog.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    var likedBlogsProvider =
        Provider.of<LikedBlogsProvider>(context, listen: false);
    double screenheight = MediaQuery.sizeOf(context).height;
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Subspace',
          style: TextStyle(fontSize: 30),
        ),
        elevation: 0,
        backgroundColor: Colors.grey.withOpacity(0.2),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LikedBlogs(),
                  ));
            },
          ),
        ],
      ),
      body: blogs == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetail(blog: blogs[index]),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Stack(children: [
                            Container(
                              height: screenheight / 3,
                              width: screenwidth,
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: blogs[index].imageUrl,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: IconButton(
                                icon: Icon(
                                  blogs[index].isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: blogs[index].isLiked
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    blogs[index].isLiked =
                                        !blogs[index].isLiked;
                                    if (blogs[index].isLiked) {
                                      likedBlogsProvider
                                          .addLikedBlog(blogs[index]);
                                    } else {
                                      likedBlogsProvider
                                          .removeLikedBlog(blogs[index]);
                                    }
                                  });
                                },
                              ),
                            )
                          ]),
                          Container(
                            padding: EdgeInsets.all(12),
                            height: MediaQuery.sizeOf(context).height / 8,
                            width: MediaQuery.sizeOf(context).width,
                            color: Colors.grey.withOpacity(0.2),
                            child: Text(
                              blogs[index].title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenheight / 35),
                            ),
                          )
                        ],
                      ),
                    ));
              },
            ),
    );
  }
}
