import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ConflictResolutionScreen extends StatefulWidget {
  const ConflictResolutionScreen({super.key});

  @override
  _ConflictResolutionScreenState createState() => _ConflictResolutionScreenState();
}

class _ConflictResolutionScreenState extends State<ConflictResolutionScreen> {
  final AIService _aiService = AIService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ConflictMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConflictHistory();
  }

  void _loadConflictHistory() {
    _messages = [
      ConflictMessage(
        id: '1',
        content: 'My roommate is always leaving dishes in the sink.',
        sender: 'user',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isAIResponse: false,
      ),
      ConflictMessage(
        id: '2',
        content: 'I understand this is frustrating. Let me suggest a few approaches to address this constructively with your roommate.',
        sender: 'ai',
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
        title: Text('Conflict Resolution'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildConflictTypeSelection(),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildConflictTypeSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Common Issues',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildConflictChip('Cleanliness'),
              _buildConflictChip('Noise'),
              _buildConflictChip('Guests'),
              _buildConflictChip('Bills'),
              _buildConflictChip('Personal Space'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConflictChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _sendPredefinedMessage(label);
      },
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(color: AppTheme.primaryColor),
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

  Widget _buildMessageBubble(ConflictMessage message) {
    return Align(
      alignment: message.isAIResponse ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isAIResponse 
              ? Colors.grey[200] 
              : AppTheme.primaryColor,
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
                    Icons.psychology,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'AI Mediator',
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
                hintText: 'Describe the conflict...',
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

    final userMessage = ConflictMessage(
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      final aiResponse = await _aiService.getConflictResolutionAdvice(content);

      final aiMessage = ConflictMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiResponse,
        sender: 'ai',
        timestamp: DateTime.now(),
        isAIResponse: true,
      );

      setState(() {
        _messages.add(aiMessage);
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
        SnackBar(content: Text('Failed to get AI response: ${e.toString()}')),
      );
    }
  }

  void _sendPredefinedMessage(String conflictType) {
    final message = 'I need help with a $conflictType issue with my roommate.';
    _messageController.text = message;
    _sendMessage(message);
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

class ConflictMessage {
  final String id;
  final String content;
  final String sender;
  final DateTime timestamp;
  final bool isAIResponse;

  ConflictMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.isAIResponse,
  });
}

class AIService {
  // Add your existing methods and fields here

  Future<String> getConflictResolutionAdvice(String content) async {
    // TODO: Replace this mock implementation with your actual AI logic or API call.
    await Future.delayed(Duration(seconds: 1));
    return "Here is some advice for resolving the conflict: Try to communicate openly and respectfully with your roommate about the issue.";
  }
}