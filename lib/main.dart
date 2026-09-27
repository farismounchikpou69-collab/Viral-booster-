import 'package:flutter/material.dart';

void main() {
  runApp(const ViralBoosterApp());
}

class ViralBoosterApp extends StatelessWidget {
  const ViralBoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viral Booster',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController topicController =
      TextEditingController();

  String title = '';
  String script = '';
  String hashtags = '';

  void generateContent() {
    final topic = topicController.text.trim();

    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entre un sujet.'),
        ),
      );
      return;
    }

    setState(() {
      title = '🔥 5 choses à savoir sur $topic';

      script = '''
🎬 SCRIPT

Tu savais que $topic possède des informations
que beaucoup de personnes ignorent ?

Voici 5 choses à découvrir.

1️⃣ Première information intéressante.

2️⃣ Deuxième information importante.

3️⃣ Un fait surprenant.

4️⃣ Une information utile.

5️⃣ Et voici le détail le plus étonnant !

Abonne-toi pour découvrir d'autres contenus.
''';

      hashtags =
          '#$topic #viral #tendance #information #actualite #fyp';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Viral Booster'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Crée du contenu pour obtenir de vraies vues',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: 'Entre ton sujet',
                hintText: 'Exemple : football au Cameroun',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: generateContent,
              child: const Text('GÉNÉRER'),
            ),

            const SizedBox(height: 25),

            if (title.isNotEmpty) ...[
              Card(
                child: ListTile(
                  title: const Text('🎯 TITRE'),
                  subtitle: Text(title),
                ),
              ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(script),
                ),
              ),

              Card(
                child: ListTile(
                  title: const Text('🏷️ HASHTAGS'),
                  subtitle: Text(hashtags),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
