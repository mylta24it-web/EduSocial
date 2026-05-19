import 'package:flutter/material.dart';
import '../models/message_model.dart';
import 'chat_detail_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late List<Conversation> conversations;
  final TextEditingController _searchController = TextEditingController();
  late List<User> onlineUsers;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    onlineUsers = [
      User(
        id: '1',
        name: 'Hoàng',
        avatar:
            'https://via.placeholder.com/150?text=Hoang',
        status: 'Online',
        isOnline: true,
      ),
      User(
        id: '2',
        name: 'Linh Anh',
        avatar:
            'https://via.placeholder.com/150?text=Linhanh',
        status: 'Online',
        isOnline: true,
      ),
      User(
        id: '3',
        name: 'Minh Duy',
        avatar:
            'https://via.placeholder.com/150?text=Minhduy',
        status: 'Online',
        isOnline: true,
      ),
      User(
        id: '4',
        name: 'Thảo Chi',
        avatar:
            'https://via.placeholder.com/150?text=Thaochia',
        status: 'Online',
        isOnline: true,
      ),
      User(
        id: '5',
        name: 'Quốc',
        avatar:
            'https://via.placeholder.com/150?text=Quoc',
        status: 'Online',
        isOnline: true,
      ),
    ];

    final nguyen = User(
      id: '1',
      name: 'Nguyễn Thu Hà',
      avatar:
          'https://via.placeholder.com/150?text=NguyenThua',
      status: 'Đang hoạt động',
      isOnline: true,
    );

    conversations = [
      Conversation(
        id: '1',
        user: nguyen,
        lastMessage: 'Bài tập Toán hôm qua khó quá, c...',
        lastMessageTime: DateTime(2024, 5, 19, 14, 20),
        unreadCount: 2,
        messages: [],
      ),
      Conversation(
        id: '2',
        user: User(
          id: '2',
          name: 'Nhóm Dự Án Lịch Sử',
          avatar:
              'https://via.placeholder.com/150?text=Group',
          status: 'Nhóm Dự Án Lịch Sử',
          isOnline: false,
        ),
        lastMessage: 'Bạn: Tớ vừa gửi slide lên folder rồi ...',
        lastMessageTime: DateTime(2024, 5, 19, 10, 45),
        unreadCount: 0,
        messages: [],
      ),
      Conversation(
        id: '3',
        user: User(
          id: '3',
          name: 'Trần Minh Quân',
          avatar:
              'https://via.placeholder.com/150?text=TranMinhquan',
          status: 'Hôm qua',
          isOnline: false,
        ),
        lastMessage: 'Cảm ơn câu nhiều nhé! Hen gặp ở t...',
        lastMessageTime: DateTime(2024, 5, 18),
        unreadCount: 0,
        messages: [],
      ),
      Conversation(
        id: '4',
        user: User(
          id: '4',
          name: 'Lê Thủy Vy',
          avatar:
              'https://via.placeholder.com/150?text=LeThuy',
          status: 'Thứ 3',
          isOnline: false,
        ),
        lastMessage: 'Cập có tài liệu ôn thi môn Triết học ...',
        lastMessageTime: DateTime(2024, 5, 17),
        unreadCount: 0,
        messages: [],
      ),
      Conversation(
        id: '5',
        user: User(
          id: '5',
          name: 'CLB Nghiên Cứu Khoa Học',
          avatar:
              'https://via.placeholder.com/150?text=Club',
          status: 'Nhóm',
          isOnline: false,
        ),
        lastMessage: 'Thông báo: Buổi sinh hoạt tuần ...',
        lastMessageTime: DateTime(2024, 5, 16),
        unreadCount: 0,
        messages: [],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tin nhắn',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm bạn bè hoặc nhóm học tập...',
                  prefixIcon: const Icon(Icons.search),
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
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Text(
                'Đang hoạt động',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                itemCount: onlineUsers.length,
                itemBuilder: (context, index) {
                  final user = onlineUsers[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(user.avatar),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 70,
                          child: Text(
                            user.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Text(
                'Trò chuyện',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _buildConversationTile(context, conversation);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationTile(
    BuildContext context,
    Conversation conversation,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatDetailScreen(user: conversation.user),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(conversation.user.avatar),
                ),
                if (conversation.unreadCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        conversation.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(conversation.lastMessageTime),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
                if (conversation.unreadCount > 0)
                  const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      final days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
      return days[dateTime.weekday % 7];
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
