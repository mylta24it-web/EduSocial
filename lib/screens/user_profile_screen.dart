import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post_model.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userAvatar;

  const UserProfileScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userAvatar,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _postService = PostService();
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.userAvatar),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thành viên EduSocial',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: const [
                          Text(
                            '0',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text('Theo dõi'),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            '0',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text('Người theo dõi'),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            '0',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text('Bài viết'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text(
                      'Theo dõi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() => _tabIndex = 0);
                      },
                      child: Text(
                        'Bài viết',
                        style: TextStyle(
                          color: _tabIndex == 0
                              ? Colors.blue.shade600
                              : Colors.grey,
                          fontWeight: _tabIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() => _tabIndex = 1);
                      },
                      child: Text(
                        'Yêu thích',
                        style: TextStyle(
                          color: _tabIndex == 1
                              ? Colors.blue.shade600
                              : Colors.grey,
                          fontWeight: _tabIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Posts
            StreamBuilder<List<Post>>(
              stream: _postService.getUserPosts(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Chưa có bài viết nào'),
                    ),
                  );
                }

                final posts = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return _buildPostPreview(post);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostPreview(Post post) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (post.imageUrl != null) ...
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                post.likes.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.chat_bubble_outline,
                color: Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                post.comments.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
