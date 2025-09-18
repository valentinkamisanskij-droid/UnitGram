import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:allconnect/chat_models.dart';

// A model for individual messages
class Message {
  final String text;
  final String time;
  final bool isSentByMe;

  Message({
    required this.text,
    required this.time,
    required this.isSentByMe,
  });
}

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  // Dummy list of messages
  final List<Message> _messages = [
    Message(text: 'Hey! How have you been?', time: '10:40', isSentByMe: false),
    Message(text: 'I\'ve been great, thanks! Just finishing up some work. You?', time: '10:41', isSentByMe: true),
    Message(text: 'Same here. Just wanted to check in.', time: '10:41', isSentByMe: false),
    Message(text: 'Cool! We should catch up sometime next week.', time: '10:42', isSentByMe: false),
    Message(text: 'Definitely! Sounds like a plan. I\'ll text you.', time: '10:43', isSentByMe: true),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendPressed() {
    final text = _textController.text;
    if (text.isEmpty) {
      return;
    }

    final message = Message(
      text: text,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      isSentByMe: true,
    );

    setState(() {
      _messages.add(message);
    });

    _textController.clear();

    // Scroll to the bottom of the list after a short delay
    Future.delayed(const Duration(milliseconds: 50), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.avatarUrl),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.name,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                ),
                Text(
                  'online',
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: (Theme.of(context).appBarTheme.foregroundColor ?? Colors.white).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index], context);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  // Builds a single message bubble
  Widget _buildMessage(Message message, BuildContext context) {
    final align = message.isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final color = message.isSentByMe
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5);
    final textColor = Theme.of(context).colorScheme.onSurface;

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: message.isSentByMe ? const Radius.circular(20) : Radius.zero,
          bottomRight: message.isSentByMe ? Radius.zero : const Radius.circular(20),
        ),
      ),
      child: Text(
        message.text,
        style: GoogleFonts.lato(fontSize: 16, color: textColor),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: align,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: Column(
              crossAxisAlignment: message.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                bubble,
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    message.time,
                    style: GoogleFonts.lato(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the text input field at the bottom
  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 3,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (value) => _handleSendPressed(),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.sentiment_satisfied_alt_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              mini: true,
              onPressed: _handleSendPressed,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
