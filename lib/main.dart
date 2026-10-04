import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/chat_screen.dart'; // Certifique-se de que este caminho aponta para a sua tela de chat

Future<void> main() async {
  // Garante que a ligação aos widgets está pronta antes de carregar o dotenv
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega as variáveis de ambiente do ficheiro .env
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PixelForge Support',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, // Mantém o tema escuro do survival horror
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(), // O nome da classe da sua tela principal
    );
  }
}