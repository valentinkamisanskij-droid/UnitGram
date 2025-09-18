import 'dart:ui';

import 'package:flutter/material.dart';
import '../chat_models.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    // Simulate loading initial messages
    _messages.addAll([
      Message(
          sender: 'other', text: 'Я скоро буду дома. Купи, пожалуйста, хлеб.', time: '18:32'),
      Message(sender: 'me', text: 'Хорошо, куплю', time: '18:33'),
      Message(sender: 'other', text: 'Спасибо! ❤️', time: '18:33'),
    ]);
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(Message(sender: 'me', text: _controller.text, time: '18:35'));
        _controller.clear();
      });
      // Simulate receiving a reply
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(
              Message(sender: 'other', text: 'Поняла, жду', time: '18:36'));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.chat.avatarUrl),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chat.name, style: theme.textTheme.titleLarge),
                Text('был(а) недавно', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              reverse: false, // To show latest messages at the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.sender == 'me';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageComposer(theme),
        ],
      ),
    );
  }

  Widget _buildMessageComposer(ThemeData theme) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: theme.appBarTheme.backgroundColor?.withOpacity(0.8),
            border: const Border(top: BorderSide(color: Colors.black26, width: 0.5)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Сообщение',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 28),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
