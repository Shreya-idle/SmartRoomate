import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/ai_service.dart';
import '../models/match_model.dart';

class ChatScreen extends StatefulWidget {
  final MatchModel match;

  const ChatScreen({super.key, required this.match});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AIService _aiService = AIService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  void _loadChatHistory() {
    // Mock chat history for the match
    _messages = [
      ChatMessage(
        id: '1',
        content: 'Hey, I saw your room listing! It looks great.',
        sender: 'user',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isAIResponse: false,
      ),
      ChatMessage(
        id: '2',
        content: 'Thanks! I’m glad you’re interested. Want to discuss details?',
        sender: 'match',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isAIResponse: true,
      ),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.match.user.name}'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isAIResponse ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isAIResponse ? Colors.grey[200] : AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isAIResponse) ...[
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    message.sender == 'match' ? widget.match.user.name : 'You',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
            ],
            Text(
              message.content,
              style: TextStyle(
                color: message.isAIResponse ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: message.isAIResponse ? Colors.grey : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              maxLines: null,
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  _sendMessage(text);
                }
              },
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _isLoading
                ? null
                : () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
            backgroundColor: AppTheme.primaryColor,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: 'user',
      timestamp: DateTime.now(),
      isAIResponse: false,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      // Simulate match's response using AIService
      final aiResponse = await _aiService.generateConversationResponse(content);

      final matchMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiResponse,
        sender: 'match',
        timestamp: DateTime.now(),
        isAIResponse: true,
      );

      setState(() {
        _messages.add(matchMessage);
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: ${e.toString()}')),
      );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String id;
  final String content;
  final String sender;
  final DateTime timestamp;
  final bool isAIResponse;

  ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.isAIResponse,
  });
}