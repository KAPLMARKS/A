/// Data model and content for the chicken encyclopedia.

class EncyclopediaCategory {
  final String title;
  final String icon;
  final List<EncyclopediaEntry> entries;

  const EncyclopediaCategory({
    required this.title,
    required this.icon,
    required this.entries,
  });
}

class EncyclopediaEntry {
  final String name;
  final String emoji;
  final String subtitle;
  final String origin;
  final String description;
  final List<String> facts;
  final Map<String, String> stats;

  const EncyclopediaEntry({
    required this.name,
    required this.emoji,
    required this.subtitle,
    this.origin = '',
    required this.description,
    this.facts = const [],
    this.stats = const {},
  });
}

/// All encyclopedia content.
final List<EncyclopediaCategory> encyclopediaCategories = [
  // ── Chicken Breeds ──
  const EncyclopediaCategory(
    title: 'Breeds',
    icon: '🐔',
    entries: [
      EncyclopediaEntry(
        name: 'Leghorn',
        emoji: '🐔',
        subtitle: 'The Egg-Laying Queen',
        origin: 'Italy, port of Livorno',
        description:
            'The Leghorn is one of the most productive egg-laying breeds '
            'in the world. These elegant white hens were developed in Italy '
            'and have conquered farms worldwide thanks to their incredible '
            'ability to lay up to 300 eggs per year. They are active, '
            'energetic, and thrive on free range.',
        facts: [
          'Lay up to 300 white eggs per year',
          'Hens weigh only 1.5–2 kg (3–4.5 lbs)',
          'One of the oldest breeds — known since the 19th century',
          'Very feed-efficient relative to their egg output',
          'Foghorn Leghorn from cartoons is based on this breed',
        ],
        stats: {
          'Egg Production': '⭐⭐⭐⭐⭐',
          'Friendliness': '⭐⭐⭐',
          'Hardiness': '⭐⭐⭐⭐',
          'Size': '⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Brahma',
        emoji: '🐓',
        subtitle: 'The Gentle Giant',
        origin: 'USA (from Asian stock)',
        description:
            'The Brahma is a majestic giant breed with feathered feet. '
            'These calm and friendly birds are impressive in size — '
            'roosters can weigh up to 5.5 kg (12 lbs)! Despite their '
            'imposing appearance, Brahmas are very gentle and often '
            'become family favorites on homesteads.',
        facts: [
          'One of the largest chicken breeds in the world',
          'Feathered feet help protect them from cold',
          'Were gifted to Queen Victoria in 1852',
          'Very calm temperament — easy to tame',
          'Hens are devoted and broody mothers',
        ],
        stats: {
          'Egg Production': '⭐⭐⭐',
          'Friendliness': '⭐⭐⭐⭐⭐',
          'Hardiness': '⭐⭐⭐⭐⭐',
          'Size': '⭐⭐⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Silkie',
        emoji: '✨',
        subtitle: 'The Fluffy Cloud',
        origin: 'China',
        description:
            'The Silkie is one of the most unusual breeds in the world. '
            'Their feathers feel like soft silk or fur, and their skin '
            'and bones are blue-black! These small fluffy chickens are '
            'incredibly affectionate and often kept as pets. In Asia, '
            'their meat is considered a delicacy.',
        facts: [
          'Feathers feel like silk — they lack barbicels',
          'Skin, bones, and meat are blue-black',
          'Have 5 toes on each foot instead of 4',
          "Can't fly due to their unique feathers",
          'Marco Polo described them as "chickens with cat fur"',
        ],
        stats: {
          'Egg Production': '⭐⭐',
          'Friendliness': '⭐⭐⭐⭐⭐',
          'Hardiness': '⭐⭐⭐',
          'Size': '⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Orpington',
        emoji: '🐔',
        subtitle: 'The Fluffy Beauty',
        origin: 'England, County of Kent',
        description:
            'The Orpington is a classic English breed created by '
            'William Cook in 1886. These are large, fluffy birds '
            'with dense soft plumage. Orpingtons are calm, friendly, '
            'and perfect for family farms. They come in black, white, '
            'buff, and blue varieties.',
        facts: [
          'Bred for the cold English climate',
          'Buff Orpingtons are the most popular variety',
          'Lay well even during winter months',
          'Hens weigh around 3.5 kg (8 lbs)',
          'Very quiet — an excellent choice for suburbs',
        ],
        stats: {
          'Egg Production': '⭐⭐⭐⭐',
          'Friendliness': '⭐⭐⭐⭐⭐',
          'Hardiness': '⭐⭐⭐⭐',
          'Size': '⭐⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Plymouth Rock',
        emoji: '🐔',
        subtitle: 'The American Classic',
        origin: 'USA, Massachusetts',
        description:
            'The Plymouth Rock is a famous American breed developed '
            'in the 19th century. Easily recognized by its distinctive '
            'black-and-white barred feathers. This is a dual-purpose '
            'breed — both a good layer and excellent table bird. '
            'Plymouth Rocks are hardy, calm, and get along great with people.',
        facts: [
          'One of the first breeds developed in America',
          'The barred pattern is the most recognizable',
          'Lay about 200 brown eggs per year',
          'Were the primary breed in the US during WWII',
          'Can live 10–12 years with proper care',
        ],
        stats: {
          'Egg Production': '⭐⭐⭐⭐',
          'Friendliness': '⭐⭐⭐⭐',
          'Hardiness': '⭐⭐⭐⭐⭐',
          'Size': '⭐⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Araucana',
        emoji: '🥚',
        subtitle: 'The Colorful Egg Layer',
        origin: 'Chile, Araucana people',
        description:
            'The Araucana is a unique breed from South America that '
            'lays blue and greenish eggs! These chickens have amusing '
            'ear tufts and sometimes lack a tail entirely. The breed '
            'is ancient — indigenous people raised them long before '
            'Europeans arrived.',
        facts: [
          'The only breed with naturally blue eggs',
          'Some lack tail vertebrae entirely',
          'Ear feather tufts are called "peduncles"',
          'The shell is blue all the way through, not just outside',
          'Ancestors lived in the Andes thousands of years ago',
        ],
        stats: {
          'Egg Production': '⭐⭐⭐',
          'Friendliness': '⭐⭐⭐',
          'Hardiness': '⭐⭐⭐⭐',
          'Size': '⭐⭐⭐',
        },
      ),
    ],
  ),

  // ── Roosters ──
  const EncyclopediaCategory(
    title: 'Roosters',
    icon: '🐓',
    entries: [
      EncyclopediaEntry(
        name: 'The Rooster\'s Role',
        emoji: '🐓',
        subtitle: 'Leader of the Flock',
        description:
            'The rooster is the head of the chicken family and a true '
            'protector of his hens. He keeps order, warns of danger, '
            'and even finds food for his flock. Without a rooster, '
            'hens may feel less protected, though they still lay eggs '
            'without one.',
        facts: [
          'Roosters crow not just at dawn — up to 15 times a day',
          'Each rooster has a unique voice',
          'A rooster can recognize up to 100 different faces',
          'He finds food first and calls the hens over',
          'One rooster typically watches over 8–12 hens',
        ],
        stats: {
          'Loudness': '⭐⭐⭐⭐⭐',
          'Bravery': '⭐⭐⭐⭐⭐',
          'Caring': '⭐⭐⭐⭐',
          'Beauty': '⭐⭐⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Combs & Spurs',
        emoji: '👑',
        subtitle: 'Weapons & Ornaments',
        description:
            'A rooster\'s comb is not just decoration — it\'s an important '
            'organ! It helps regulate body temperature and indicates the '
            'bird\'s health. A bright red comb shows that the rooster is '
            'healthy and strong. Spurs on the legs are real weapons '
            'for defending the flock from predators.',
        facts: [
          'There are 8 main comb shapes',
          'The comb helps cool down in hot weather',
          'Spurs grow throughout life and can reach 5 cm (2 in)',
          'A pale comb is a sign of illness',
          'Hens have much smaller combs than roosters',
        ],
        stats: {
          'Comb Size': '⭐⭐⭐⭐⭐',
          'Spur Sharpness': '⭐⭐⭐⭐',
          'Color Brightness': '⭐⭐⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Crowing',
        emoji: '🌅',
        subtitle: 'The Morning Alarm Clock',
        description:
            'Crowing is the rooster\'s signature! Scientists discovered '
            'that roosters crow based on an internal biological clock, '
            'not just because of sunrise. The dominant rooster crows '
            'first, followed by others in pecking order. The volume '
            'can reach 130 decibels — as loud as a jet engine!',
        facts: [
          'Volume up to 130 dB — louder than a rock concert',
          "Roosters don't go deaf thanks to a special ear fold",
          'They crow in hierarchy — the boss goes first',
          'Their biological clock is more precise than any alarm',
          'The "sound" of crowing differs across languages',
        ],
        stats: {
          'Loudness': '⭐⭐⭐⭐⭐',
          'Precision': '⭐⭐⭐⭐⭐',
          'Melody': '⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Game Roosters',
        emoji: '🥊',
        subtitle: 'Warriors of Antiquity',
        origin: 'Southeast Asia',
        description:
            'Game breeds are among the most ancient on the planet. '
            'Their ancestors were domesticated over 5,000 years ago. '
            'These are muscular, proud, and fearless birds with an '
            'upright posture. Cockfighting is now banned in many '
            'countries, but the breeds are preserved as ornamental birds.',
        facts: [
          'Domesticated over 5,000 years ago',
          'Cockfighting was popular in Ancient Rome',
          'Game breeds include Shamo, Asil, and Cornish',
          'Can weigh up to 6 kg (13 lbs)',
          'Today kept primarily as show birds',
        ],
        stats: {
          'Strength': '⭐⭐⭐⭐⭐',
          'Bravery': '⭐⭐⭐⭐⭐',
          'Friendliness': '⭐⭐',
          'Size': '⭐⭐⭐⭐',
        },
      ),
    ],
  ),

  // ── Chicks ──
  const EncyclopediaCategory(
    title: 'Chicks',
    icon: '🐥',
    entries: [
      EncyclopediaEntry(
        name: 'Birth of a Chick',
        emoji: '🥚',
        subtitle: 'From Egg to Fluffball',
        description:
            'A chick develops inside the egg for 21 days. During this '
            'time, a tiny cell grows into a fully formed baby bird. '
            'The broody hen turns each egg up to 50 times a day! '
            'Before hatching, the chick starts peeping right inside '
            'the shell, and the mother responds.',
        facts: [
          'Incubation lasts exactly 21 days',
          'The chick breaks the shell with an "egg tooth"',
          'Hatching takes 12–24 hours',
          'The mother talks to chicks before they are born',
          'A chick can peep 3 days before hatching',
        ],
        stats: {
          'Cuteness': '⭐⭐⭐⭐⭐',
          'Fragility': '⭐⭐⭐⭐⭐',
          'Growth Rate': '⭐⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'First Days of Life',
        emoji: '🐥',
        subtitle: 'A Tiny Puffball',
        description:
            'A newly hatched chick is covered in wet down that quickly '
            'dries and becomes fluffy. In the first hours, it memorizes '
            'its mother (or the first moving object it sees) — this is '
            'called imprinting. Within just a few hours, chicks are '
            'running, peeping, and pecking at food.',
        facts: [
          'Imprinting occurs within the first 24–48 hours',
          'Chicks are born with a 2-day nutrition reserve',
          'A newborn\'s body temperature is about 40\u00b0C (104\u00b0F)',
          'Down is replaced by feathers at 6–8 weeks',
          'Chicks recognize their mother\'s voice before hatching',
        ],
        stats: {
          'Cuteness': '⭐⭐⭐⭐⭐',
          'Activity': '⭐⭐⭐⭐',
          'Independence': '⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'How a Chick Grows',
        emoji: '🐣',
        subtitle: 'Becoming a Chicken',
        description:
            'A chick\'s growth is an amazing process! In the first week '
            'alone, its weight doubles. By 6–8 weeks, the down is '
            'replaced by real feathers. Around 5 months, a young hen '
            'begins laying her first eggs, and young roosters start '
            'trying to crow (quite hilariously at first!).',
        facts: [
          'Weight doubles in the first week of life',
          'Fully feathered by 8 weeks',
          'Gender can be determined at 6–8 weeks',
          'First egg comes at 18–24 weeks',
          'Young roosters "practice" crowing from 4 months',
        ],
        stats: {
          'Growth Rate': '⭐⭐⭐⭐⭐',
          'Appetite': '⭐⭐⭐⭐⭐',
          'Curiosity': '⭐⭐⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Chick Communication',
        emoji: '💬',
        subtitle: 'The Language of Birds',
        description:
            'Chicks begin communicating before they are even born! '
            'Chickens have about 30 different sounds for different '
            'situations. A mother hen teaches chicks to identify food '
            'and warns of danger from above or below with different '
            'calls. Chicks quickly learn to understand these signals.',
        facts: [
          'Chickens have about 30 distinct vocalizations',
          'There are separate alarm calls for aerial vs. ground predators',
          'Chicks respond to their mother\'s call from inside the egg',
          'A hen "purrs" while sitting on her eggs',
          'Content chickens make a quiet cooing sound',
        ],
        stats: {
          'Talkativeness': '⭐⭐⭐⭐⭐',
          'Comprehension': '⭐⭐⭐⭐',
          'Loudness': '⭐⭐⭐',
        },
      ),
      EncyclopediaEntry(
        name: 'Fun Facts',
        emoji: '🧠',
        subtitle: 'Smarter Than You Think!',
        description:
            'Chickens are surprisingly intelligent creatures! They can '
            'recognize over 100 faces, count, have a sense of time, '
            'and even dream. Hens can be cunning and deceive each '
            'other. Scientists have proven that chickens are capable '
            'of empathy — they worry about their chicks.',
        facts: [
          'Chickens can see more colors than humans',
          'They can count to at least 5',
          'They dream — they have a REM sleep phase',
          'The closest living relatives of Tyrannosaurus rex',
          'There are more chickens on Earth than any other bird',
        ],
        stats: {
          'Intelligence': '⭐⭐⭐⭐',
          'Memory': '⭐⭐⭐⭐',
          'Cunning': '⭐⭐⭐⭐⭐',
        },
      ),
    ],
  ),
];
