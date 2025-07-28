import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/data/service/gemini_service.dart';

class ChatbotState {
  final List<Map<String, String>> messages;

  ChatbotState({required this.messages});
}

class ChatbotCubit extends Cubit<ChatbotState> {
  final GeminiService geminiService;

  ChatbotCubit({required this.geminiService})
      : super(ChatbotState(messages: []));

  void sendMessage(String userMessage) async {
    // Kullanıcı mesajını ekle
    emit(ChatbotState(messages: [...state.messages, {'role': 'user', 'text': userMessage}]));

    // AI yanıtını al
    final aiResponse = await geminiService.askGeneralQuestion(userMessage);

    // Sadece AI yanıtını ekle (kullanıcı mesajı zaten eklendi)
    emit(ChatbotState(messages: [
      ...state.messages, // Bu zaten kullanıcı mesajını içeriyor
      {'role': 'ai', 'text': aiResponse},
    ]));
  }
}