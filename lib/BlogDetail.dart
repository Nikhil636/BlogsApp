import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'BlogList.dart';
import 'Model.dart';

class BlogDetail extends StatefulWidget {
  final Blog blog;

  BlogDetail({required this.blog});

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.blog.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.sizeOf(context).height;
    var likedBlogsProvider = Provider.of<LikedBlogsProvider>(context);
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.blog.title,
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.grey.withOpacity(0.2),
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
                if (isLiked) {
                  likedBlogsProvider.addLikedBlog(widget.blog);
                } else {
                  likedBlogsProvider.removeLikedBlog(widget.blog);
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: screenheight / 3,
              width: screenwidth,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: widget.blog.imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Container(
                width: screenwidth,
                padding: EdgeInsets.all(12),
                color: Colors.grey.withOpacity(0.2),
                child: Text(
                  widget.blog.title,
                  style: TextStyle(
                      color: Colors.white, fontSize: screenheight / 35),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                widget.blog.isLiked ? Icons.favorite : Icons.favorite_border,
                color: widget.blog.isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                likedBlogsProvider.addLikedBlog(widget.blog);
              },
            ),
          ],
        ),
      ),
    );
  }
}
