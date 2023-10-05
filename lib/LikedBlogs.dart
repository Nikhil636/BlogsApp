import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'BlogDetail.dart';
import 'BlogList.dart';
import 'Model.dart';

class LikedBlogs extends StatelessWidget {
  const LikedBlogs();

  @override
  Widget build(BuildContext context) {
    var likedBlogsProvider = Provider.of<LikedBlogsProvider>(context);
    List<Blog> likedBlogs = likedBlogsProvider.likedBlogs;
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Liked Blogs',
          style: TextStyle(fontSize: 25),
        ),
        elevation: 0,
        backgroundColor: Colors.grey.withOpacity(0.2),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 25),
        itemCount: likedBlogs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetail(blog: likedBlogs[index]),
                ),
              );
            },
            child:Container(
padding: EdgeInsets.all(5),
              height: screenwidth/5,
              child: Card(
                color: Colors.grey.withOpacity(0.2),
                child: ListTile(

                 title: Text(
                    likedBlogs[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      likedBlogsProvider.removeLikedBlog(likedBlogs[index]);
                    },
                  ),
                  leading: Container(
                    width: screenwidth / 5,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: likedBlogs[index].imageUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
