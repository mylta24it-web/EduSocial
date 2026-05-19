import 'package:flutter/material.dart';
import '../models/post_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    _initializePosts();
  }

  void _initializePosts() {
    posts = [
      Post(
        id: '1',
        author: PostUser(
          id: '1',
          name: 'Minh Anh',
          avatar: 'https://via.placeholder.com/150?text=MinhAnh',
          title: '2 giờ trước',
          group: 'Công đồng Tiếng Anh',
        ),
        content: 'Mẹo học tiếng Anh hiệu quả cho người bận rộn 📚',
        hashtags: ['#HocTap', '#EnglishTips'],
        imageUrl:
            'https://via.placeholder.com/400x250?text=English+Learning',
        likes: 124,
        comments: 18,
        createdAt: DateTime(2024, 5, 19, 14, 0),
      ),
      Post(
        id: '2',
        author: PostUser(
          id: '2',
          name: 'Hoàng Nam',
          avatar: 'https://via.placeholder.com/150?text=HoangNam',
          title: '5 giờ trước',
          group: 'Khoa Học May Tính',
        ),
        content:
            'Mới nghe sao về việc áp dụng AI vào quá trình việt code? Mình vừa tìm thấy một extension cực hữu ích giúp tăng năng suất đáng kể... 😊',
        hashtags: ['#Coding', '#DevLife'],
        imageUrl:
            'https://via.placeholder.com/400x250?text=AI+Programming',
        likes: 42,
        comments: 5,
        createdAt: DateTime(2024, 5, 19, 9, 0),
      ),
      Post(
        id: '3',
        author: PostUser(
          id: '3',
          name: 'Ban Quản Trị',
          avatar: 'https://via.placeholder.com/150?text=AdminTeam',
          title: 'Thông báo',
        ),
        content: 'Workshop: Kỹ năng quản lý thời gian',
        hashtags: [],
        imageUrl:
            'https://via.placeholder.com/400x250?text=Workshop',
        likes: 0,
        comments: 0,
        createdAt: DateTime(2024, 5, 19, 8, 0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EduSocial',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Bạn đang nghĩ gì thế?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildActionButton(
                    icon: Icons.image,
                    label: 'Hình ảnh',
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.video_library,
                    label: 'Video',
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.calendar_today,
                    label: 'Sự kiện',
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          ...posts.map((post) => _buildPostCard(post)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
  }) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _buildPostCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(post.author.avatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (post.author.group != null)
                        Text(
                          post.author.group!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      if (post.author.title != null)
                        Text(
                          post.author.title!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.hashtags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: post.hashtags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                if (post.hashtags.isNotEmpty)
                  const SizedBox(height: 8),
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (post.imageUrl != null) ...
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.likes.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.comments.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Chia sẻ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
