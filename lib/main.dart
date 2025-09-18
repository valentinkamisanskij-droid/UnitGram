'''
import 'package:flutter/material.dart';
import 'chat_models.dart';
import 'screens/chat_screen.dart';
import 'widgets/chat_list_item.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ChatsScreen(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final chat = Provider.of<ChatService>(context, listen: false).getChatById(id);
        // Ensure we pass a valid chat object, or handle the case where it might be null
        // For simplicity, we're assuming getChatById always returns a valid chat for the given id.
        // In a real app, you might want to show a not-found page.
        return ChatScreen(chat: chat);
      },
    ),
  ],
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Color(0xFF005FFF); // A vibrant blue

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.poppins(
          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: GoogleFonts.poppins(
          fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
      bodyMedium: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.white.withOpacity(0.8)),
      labelMedium: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    );

    final ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF001029),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF001F4D),
        elevation: 0,
        titleTextStyle: appTextTheme.titleLarge,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
        primary: primarySeedColor,
        onPrimary: Colors.white,
        surface: const Color(0xFF001F4D),
        onSurface: Colors.white,
        surfaceContainerHighest: const Color(0xFF001F4D),
      ),
      textTheme: appTextTheme,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => ChatService()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'UnitGram',
            theme: baseTheme,
            darkTheme: baseTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final chats = chatService.getChats();

    return Scaffold(
      appBar: AppBar(
        title: Text('Чаты', style: Theme.of(context).textTheme.displayLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.more_vert, size: 28),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: ChatListItem(
                    chat: chat,
                    onTap: () => context.go('/chat/${chat.id}'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatService {
  final List<Chat> _chats = [
    Chat(
      id: '1',
      name: 'Мама',
      lastMessage: 'Я скоро буду дома. Купи, пожалуйста, хлеб.',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      time: '18:32',
      unreadCount: 2,
    ),
    Chat(
      id: '2',
      name: 'Лиза',
      lastMessage: 'Привет! Как дела? Что нового?',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      time: '17:15',
      unreadCount: 0,
    ),
    Chat(
      id: '3',
      name: 'Работа',
      lastMessage: 'Коллеги, завтра совещание в 10:00.',
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
      time: '14:30',
      unreadCount: 5,
    ),
    Chat(
      id: '4',
      name: 'Лучший друг',
      lastMessage: 'Го в футбол вечером?',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      time: 'Вчера',
      unreadCount: 0,
    ),
    Chat(
      id: '5',
      name: 'Универ',
      lastMessage: 'Напоминаю о сдаче курсовой работы до конца недели.',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      time: 'Вчера',
      unreadCount: 1,
    ),
  ];

  List<Chat> getChats() => _chats;

  Chat getChatById(String id) {
    return _chats.firstWhere((chat) => chat.id == id);
  }
}
''