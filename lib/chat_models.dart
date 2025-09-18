
class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    required this.unreadCount,
  });
}

class Message {
  final String sender;
  final String text;
  final String time;

  Message({
    required this.sender,
    required this.text,
    required this.time,
  });
}
