import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  // Puxa a chave do ficheiro oculto. O ?? '' evita erros caso a chave não seja encontrada.
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<String> sendMessage(String message) async {
    // Verificação extra de segurança para ajudar na depuração
    if (_apiKey.isEmpty) {
      debugPrint('ERRO: Chave de API não carregada do ficheiro .env');
      return 'Erro interno: Chave de comunicação em falta.';
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$_apiKey',
    );

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": message}
          ]
        }
      ]
    });

    for (int tentativa = 1; tentativa <= 3; tentativa++) {
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidate = data['candidates']?[0];
          final text = candidate?['content']?['parts']?[0]?['text'];
          return text ?? 'Desculpe, sinal perdido com o servidor da PixelForge.';
        } else if (response.statusCode == 503) {
          debugPrint('Tentativa $tentativa: Servidor sobrecarregado (503). A tentar novamente em breve...');
          await Future.delayed(const Duration(seconds: 2));
        } else {
          debugPrint('Erro HTTP ${response.statusCode}: ${response.body}');
          break; // Sai do loop se for um erro diferente de sobrecarga
        }
      } catch (e) {
        debugPrint('Exceção na tentativa $tentativa: $e');
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    return 'Servidor da IA temporariamente ocupado. Tente enviar a mensagem novamente em instantes.';
  }
}