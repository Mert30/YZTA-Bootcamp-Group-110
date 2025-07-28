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

  Future<String> fetchGeminiSummary(Map<String, dynamic> ilac) async {
    final prompt = buildPrompt(ilac);
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? "Yanıt alınamadı.";
  }

  String buildPrompt(Map<String, dynamic> ilac) {
    return '''
Aşağıdaki ilaç bilgilerini dikkate alarak cevap oluştur:

• İlaç Adı: ${ilac['Product_Name'] ?? 'Bilinmiyor'}
• Etken Madde: ${ilac['Active_Ingredient'] ?? 'Bilinmiyor'}
• ATC Kodu: ${ilac['ATC_code'] ?? 'Bilinmiyor'}
• Kategori: ${ilac['Category_1'] ?? '-'} > ${ilac['Category_2'] ?? '-'} > ${ilac['Category_3'] ?? '-'} > ${ilac['Category_4'] ?? '-'} > ${ilac['Category_5'] ?? '-'}
• Açıklama: ${ilac['Description'] ?? 'Bilinmiyor'}

Aşağıdaki sorulara kısa, sade ve hastanın anlayabileceği şekilde tek tek numaralandırarak yanıt ver:

1. Bu ilaç nedir, ne amaçla kullanılır?
2. Bu ilaç nasıl kullanılır? (Kullanım talimatı)
3. Bu ilacın yan etkileri nelerdir?

Cevabı sana verilen ilaç bilgilerine göre oluştur. Lütfen yalnızca 1., 2., 3. şeklinde numaralandırılmış kısa yanıtlar döndür. Başlıklar ekleme.
''';
  }

  // Hastanın istediği soruyu alıp Gemini'den cevap alıyor
  Future<String> askCustomQuestion(
    Map<String, dynamic> ilac,
    String userQuestion,
  ) async {
    final ilacInfo =
        '''
İlaç Adı: ${ilac['Product_Name'] ?? 'Bilinmiyor'}
Etken Madde: ${ilac['Active_Ingredient'] ?? 'Bilinmiyor'}
ATC Kodu: ${ilac['ATC_code'] ?? 'Bilinmiyor'}
Kategori: ${ilac['Category_1'] ?? '-'} > ${ilac['Category_2'] ?? '-'} > ${ilac['Category_3'] ?? '-'} > ${ilac['Category_4'] ?? '-'} > ${ilac['Category_5'] ?? '-'}
Açıklama: ${ilac['Description'] ?? 'Bilinmiyor'}
''';

    final prompt =
        '''
Aşağıdaki ilaç bilgilerini göz önünde bulundurarak kullanıcının sorusuna sade, doğru ve anlaşılır şekilde yanıt ver. Eğer bilgi yetersizse bunu da belirt.

$ilacInfo

Kullanıcının sorusu: "$userQuestion"

Cevap:
''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ??
        "Sorunu anlayamadım ya da yeterli bilgiye ulaşamadım.";
  }
}
