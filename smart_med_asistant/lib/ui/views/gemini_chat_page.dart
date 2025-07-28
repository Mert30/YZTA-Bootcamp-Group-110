import 'package:flutter/material.dart';
import 'package:smart_med_assistant/data/service/gemini_service.dart';

class GeminiChatPage extends StatefulWidget {
  const GeminiChatPage({super.key});

  @override
  State<GeminiChatPage> createState() => _GeminiChatPageState();
}

class _GeminiChatPageState extends State<GeminiChatPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late GeminiService _geminiService;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(
      'YOUR_API_KEY', // <-- Gerçek API anahtarını buraya koy
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSendMessage() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': question});
      _controller.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _geminiService.askCustomQuestion({}, question);
      setState(() {
        _messages.add({'sender': 'gemini', 'text': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'gemini',
          'text': "Cevap alınamadı. Hata: $e",
        });
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    final bgColor = isUser ? Colors.teal.shade600 : Colors.grey.shade200;
    final textColor = isUser ? Colors.white : Colors.grey.shade900;

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(6),
      bottomRight: isUser
          ? const Radius.circular(6)
          : const Radius.circular(18),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          message['text'] ?? '',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.teal.shade200,
          ),
          const SizedBox(height: 20),
          Text(
            "Merhaba! Sorularını aşağıdan yazarak benden cevabını alabilirsin.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text(
          'MediMate AI Asistanı',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyChat()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) =>
                          _buildMessage(_messages[index]),
                    ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: CircularProgressIndicator(
                  color: Colors.teal,
                  strokeWidth: 3,
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Sorunuzu yazın...',
                        filled: true,
                        fillColor: Colors.teal.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _handleSendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: Colors.teal.shade600,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _handleSendMessage,
                      splashColor: Colors.teal.shade300,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
