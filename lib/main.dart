import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const ViralBoosterApp());

// ---------------------------------------------------------------------------
// Données
// ---------------------------------------------------------------------------

const Map<String, List<String>> niches = {
  'Mode': ['mode', 'ootd', 'style', 'outfit', 'tendance', 'fashion'],
  'Fitness': ['fitness', 'sport', 'musculation', 'motivation', 'workout', 'santé'],
  'Cuisine': ['cuisine', 'recette', 'foodie', 'facile', 'gourmand', 'maison'],
  'Business': ['business', 'entrepreneur', 'argent', 'marketing', 'succès', 'startup'],
  'Voyage': ['voyage', 'travel', 'vacances', 'aventure', 'destination', 'bonsplans'],
  'Tech': ['tech', 'ia', 'gadget', 'appli', 'innovation', 'astucestech'],
  'Beauté': ['beauté', 'makeup', 'skincare', 'routine', 'soin', 'glow'],
  'Humour': ['humour', 'drole', 'meme', 'blague', 'rire', 'comedie'],
};

const List<String> generalTags = [
  'viral', 'pourtoi', 'fyp', 'reels', 'explore', 'trending', 'astuces', 'conseils',
];

const List<String> hooks = [
  'Personne ne te dit ça sur le contenu en {n}…',
  '3 erreurs que tout le monde fait en {n}',
  "Ce que j'aurais aimé savoir avant de me lancer en {n}",
  'Arrête de faire ça si tu veux progresser en {n}',
  "J'ai testé {n} pendant 30 jours, voici le résultat",
  'Le secret que les pros de {n} gardent pour eux',
  'Tu fais tout à l\'envers en {n}, voici pourquoi',
  'Une astuce {n} qui change tout en 10 secondes',
  'POV : tu découvres enfin la vraie méthode en {n}',
  '5 idées de contenu {n} à poster cette semaine',
];

const List<String> ctas = [
  'Enregistre ce post pour plus tard 📌',
  'Partage à un ami qui a besoin de voir ça 🔁',
  'Dis-moi en commentaire ce que tu en penses 👇',
  'Abonne-toi pour ne pas rater la suite 🔔',
];

final Random rnd = Random();

void copyText(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Copié dans le presse-papiers ✅')),
  );
}

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------

class ViralBoosterApp extends StatelessWidget {
  const ViralBoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viral Booster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
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
  int index = 0;

  final List<Widget> pages = const [
    IdeasPage(),
    HashtagsPage(),
    CaptionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Viral Booster'),
        centerTitle: true,
      ),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.lightbulb_outline), label: 'Idées'),
          NavigationDestination(icon: Icon(Icons.tag), label: 'Hashtags'),
          NavigationDestination(icon: Icon(Icons.edit_note), label: 'Légende'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget partagé : choix de la niche
// ---------------------------------------------------------------------------

class NicheChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const NicheChips({super.key, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: niches.keys
          .map((n) => ChoiceChip(
                label: Text(n),
                selected: n == selected,
                onSelected: (_) => onSelected(n),
              ))
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Onglet 1 : idées d'accroches
// ---------------------------------------------------------------------------

class IdeasPage extends StatefulWidget {
  const IdeasPage({super.key});

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  String niche = 'Mode';
  List<String> ideas = [];

  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() {
    final list = List<String>.of(hooks)..shuffle();
    ideas = list
        .take(5)
        .map((h) => h.replaceAll('{n}', niche.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Choisis ta niche', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        NicheChips(
          selected: niche,
          onSelected: (n) => setState(() {
            niche = n;
            generate();
          }),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => setState(generate),
          icon: const Icon(Icons.refresh),
          label: const Text('Nouvelles idées'),
        ),
        const SizedBox(height: 12),
        ...ideas.map(
          (idea) => Card(
            child: ListTile(
              title: Text(idea),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => copyText(context, idea),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Onglet 2 : hashtags
// ---------------------------------------------------------------------------

class HashtagsPage extends StatefulWidget {
  const HashtagsPage({super.key});

  @override
  State<HashtagsPage> createState() => _HashtagsPageState();
}

class _HashtagsPageState extends State<HashtagsPage> {
  String niche = 'Mode';
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() {
    final own = List<String>.of(niches[niche]!)..shuffle();
    final general = List<String>.of(generalTags)..shuffle();
    tags = [...own.take(5), ...general.take(4)]..shuffle();
  }

  String get asText => tags.map((t) => '#$t').join(' ');

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Choisis ta niche', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        NicheChips(
          selected: niche,
          onSelected: (n) => setState(() {
            niche = n;
            generate();
          }),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => setState(generate),
          icon: const Icon(Icons.shuffle),
          label: const Text('Mélanger les hashtags'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((t) => Chip(label: Text('#$t'))).toList(),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => copyText(context, asText),
          icon: const Icon(Icons.copy),
          label: const Text('Tout copier'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Onglet 3 : générateur de légende
// ---------------------------------------------------------------------------

class CaptionPage extends StatefulWidget {
  const CaptionPage({super.key});

  @override
  State<CaptionPage> createState() => _CaptionPageState();
}

class _CaptionPageState extends State<CaptionPage> {
  final TextEditingController controller = TextEditingController();
  String caption = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void generate() {
    final topic = controller.text.trim();
    if (topic.isEmpty) return;

    final captionHooks = [
      'Tu ne devineras jamais ce que $topic peut changer pour toi 👀',
      'Voici pourquoi tout le monde parle de $topic 🔥',
      "Ce que personne ne t'a dit sur $topic…",
      '$topic : la méthode simple que je voudrais avoir connue plus tôt',
    ];

    final tag = topic.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    final hook = captionHooks[rnd.nextInt(captionHooks.length)];
    final cta = ctas[rnd.nextInt(ctas.length)];

    setState(() {
      caption = '$hook\n\n'
          '3 choses à retenir :\n'
          '1️⃣ …\n'
          '2️⃣ …\n'
          '3️⃣ …\n\n'
          '$cta\n\n'
          '#$tag #viral #pourtoi #astuces';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Sujet de ton post',
            hintText: 'ex : routine du matin',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => generate(),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: generate,
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Générer la légende'),
        ),
        const SizedBox(height: 16),
        if (caption.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(caption),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => copyText(context, caption),
            icon: const Icon(Icons.copy),
            label: const Text('Copier la légende'),
          ),
        ],
      ],
    );
  }
}
