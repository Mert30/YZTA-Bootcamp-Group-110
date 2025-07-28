import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;

  GeminiService(this.apiKey);

  late final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
  );

  late final ChatSession _chat;
  
  void startChatSession() {
    _chat = _model.startChat();
  }

  Future<Map<String, dynamic>> loadIlacMap() async {
    final jsonString = await rootBundle.loadString('assets/ilac.json');
    final List<dynamic> fullJson = json.decode(jsonString);
    final data = fullJson[2]['data'] as List<dynamic>;

    return {
      for (var item in data)
        if (item['barcode'] != null) item['barcode'].toString(): item,
    };
  }

  Map<String, String> parseGeminiResponse(String response) {
    final lines = response.split('\n');
    final parsed = <String, String>{
      'descriptionAI': '',
      'usageAI': '',
      'sideEffectsAI': '',
    };

    for (var line in lines) {
      if (line.startsWith("1.")) {
        parsed['descriptionAI'] = line.substring(2).trim();
      } else if (line.startsWith("2.")) {
        parsed['usageAI'] = line.substring(2).trim();
      } else if (line.startsWith("3.")) {
        parsed['sideEffectsAI'] = line.substring(2).trim();
      }
    }

    return parsed;
  }

  String buildPrompt(Map<String, dynamic> ilac) {
    return '''
Aşağıdaki ilaç bilgilerini dikkate alarak cevap oluştur:

• İlaç Adı: ${ilac['Product_Name']}
• Etken Madde: ${ilac['Active_Ingredient']}
• ATC Kodu: ${ilac['ATC_code']}
• Kategori: ${ilac['Category_1']} > ${ilac['Category_2']} > ${ilac['Category_3']} > ${ilac['Category_4']} > ${ilac['Category_5']}
• Açıklama: ${ilac['Description']}

Aşağıdaki sorulara kısa, sade ve hastanın anlayabileceği şekilde tek tek numaralandırarak yanıt ver:

1. Bu ilaç nedir, ne amaçla kullanılır?
2. Bu ilaç nasıl kullanılır? (Kullanım talimatı)
3. Bu ilacın yan etkileri nelerdir?

Cevabı sana verilen ilaç bilgilerine göre oluştur. Lütfen yalnızca 1., 2., 3. şeklinde numaralandırılmış kısa yanıtlar döndür. Başlıklar ekleme.
''';
  }

  Future<String> fetchGeminiSummary(Map<String, dynamic> ilac) async {
    final prompt = buildPrompt(ilac);
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? "Yanıt alınamadı.";
  }

  Future<String> askGeneralQuestion(String question) async {
    final ilacMap = await loadIlacMap();

    final foundIlac = ilacMap.entries.firstWhere(
      (entry) =>
          question.contains(entry.key) ||
          question.toLowerCase().contains(
              (entry.value['Product_Name'] ?? '').toString().toLowerCase()),
      orElse: () => const MapEntry('', null),
    );

    if (foundIlac.value != null) {
      final prompt = '''
  Kullanıcının sorusu: "$question"

  Aşağıda verilen ilaç bilgilerini kullanarak bu soruya hastanın anlayacağı sade bir dille, kısa ama açıklayıcı bir şekilde cevap ver.

  • İlaç Adı: ${foundIlac.value!['Product_Name']}
  • Etken Madde: ${foundIlac.value!['Active_Ingredient']}
  • Açıklama: ${foundIlac.value!['Description']}
  • Kategori: ${foundIlac.value!['Category_1']} > ${foundIlac.value!['Category_2']} > ${foundIlac.value!['Category_3']}

  Kısa cümlelerle, doğrudan ve anlaşılır cevap ver. Gereksiz tekrar veya akademik dil kullanma. Lütfen cevabında kalın, italik, yıldızlı veya diğer biçimlendirmeleri kullanma. Düz metin (plain text) olarak yanıtla.
  ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Yanıt alınamadı.";
    } else {
      // Eğer ilaç bulunamazsa, yine de Gemini'ye soruyu gönder
      final fallbackResponse =
          await _model.generateContent([Content.text(question)]);
      return fallbackResponse.text ?? "Sorunuzu anlayamadım. Lütfen tekrar deneyin.";
    }
  }


}