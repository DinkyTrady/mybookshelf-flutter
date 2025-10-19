import 'package:web_flut/models/language.dart';
import 'package:web_flut/models/genre.dart';
import 'package:web_flut/models/users/author.dart';
import 'package:web_flut/models/books/novel.dart';

import 'package:web_flut/models/books/comic.dart';
import 'package:web_flut/models/books/book_type.dart';

final defaultLanguages = [
  Language(id: '1', name: 'Indonesian', code: 'id'),
  Language(id: '2', name: 'English', code: 'en'),
  Language(id: '3', name: 'Japanese', code: 'ja'),
  Language(id: '4', name: 'Korean', code: 'ko'),
  Language(id: '5', name: 'Chinese', code: 'cn')
];

final defaultGenres = [
  Genre(id: '1', name: 'Fiction'),
  Genre(id: '2', name: 'Sci-Fi'),
  Genre(id: '3', name: 'Fantasy'),
  Genre(id: '4', name: 'Romance'),
  Genre(id: '5', name: 'Mystery'),
  Genre(id: '6', name: 'Slice of Life'),
  Genre(id: '7', name: 'Action'),
  Genre(id: '8', name: 'Adventure'),
  Genre(id: '9', name: 'Comedy'),
  Genre(id: '10', name: 'Drama'),
  Genre(id: '11', name: 'Sports'),
];

final defaultAuthors = [
  Author(
    id: '1',
    firstName: 'Kiyohiko',
    lastName: 'Azuma',
    biography: 'Japanese manga artist, best known for his works "Azumanga Daioh" and "Yotsuba to!".',
    dateOfBirth: DateTime(1968, 5, 27),
  ),
  Author(
    id: '2',
    firstName: 'Saka',
    lastName: 'Mikami',
    biography: 'Manga author and illustrator, primarily known for the series "Kaoru Hana wa Rin to Saku".',
    dateOfBirth: DateTime(1990), // Placeholder
  ),
  Author(
    id: '3',
    firstName: 'Moon',
    lastName: 'Baekkyung',
    biography: '',
    dateOfBirth: DateTime(1980),
  ),
  Author(
    id: '4',
    firstName: 'Hyunsoo',
    lastName: 'Kim',
    biography: '',
    dateOfBirth: DateTime(1980),
  ),
  Author(
    id: '5',
    firstName: 'Haruichi',
    lastName: 'Furudate',
    biography:
        '''Furudate was a former volleyball player during Junior High School, gaining
  the position of middle blocker. Furudate lived in the Iwate Prefecture until
  graduation and moved to Miyagi Prefecture after.''',
    dateOfBirth: DateTime(1983, 3, 7),
  ),
  Author(
    id: '6',
    firstName: 'Brownie',
    biography: '',
    dateOfBirth: DateTime(1993, 11, 10),
  ),
  Author(
    id: '7',
    firstName: 'Watari',
    lastName: 'Wataru',
    biography: '',
    dateOfBirth: DateTime(1987, 1, 24),
  ),
  Author(
    id: '8',
    firstName: 'Ai Qianshui de Wuzei',
    biography:
        'He is from Emeishan City, Sichuan Province. He graduated from College of Computer Science of Sichuan University in 2007. He became a freelance writer in 2013.',
    dateOfBirth: DateTime(1990),
  ),
  Author(
    id: '9',
    firstName: 'ONE',
    lastName: '',
    biography: 'Japanese webcomic artist, best known for creating the series "One-Punch Man" and "Mob Psycho 100".',
    dateOfBirth: DateTime(1986, 10, 29),
  ),
  Author(
    id: '10',
    firstName: 'Yusuke',
    lastName: 'Murata',
    biography: 'Japanese manga artist and animator, known for illustrating "Eyeshield 21" and "One-Punch Man".',
    dateOfBirth: DateTime(1978, 7, 4),
  ),
    Author(
    id: '11',
    firstName: 'Takehiko',
    lastName: 'Inoue',
    biography: 'A renowned Japanese manga artist. Known for Slam Dunk and Vagabond.',
    dateOfBirth: DateTime(1967, 1, 12),
  ),
    Author(
    id: '12',
    firstName: 'Makoto',
    lastName: 'Yukimura',
    biography: 'Japanese manga artist known for Planetes and Vinland Saga.',
    dateOfBirth: DateTime(1976, 5, 8),
  ),
  Author(
    id: '13',
    firstName: 'Eiichiro',
    lastName: 'Oda',
    biography: 'Creator of the manga series One Piece. Inspired by Akira Toriyama\'s Dragon Ball.',
    dateOfBirth: DateTime(1975, 1, 1),
  ),
];

final defaultBooks = [
  // Yotsuba&!
  Comic(
    id: '1',
    title: 'Yotsuba to!',
    author: defaultAuthors[0], // Kiyohiko Azuma
    summary: 'Depicts the daily adventures of a young, energetic, and curious five-year-old girl named Yotsuba Koiwai.',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/2/266365l.jpg',
    type: BookType.manga,
    chapters: null, // Ongoing
    status: 'Ongoing',
    isReading: true,
    language: defaultLanguages[2], // Japanese
    genres: [defaultGenres[8], defaultGenres[5]], // Comedy, Slice of Life
  ),
  // Vagabond
  Comic(
    id: '2',
    title: 'Vagabond',
    author: defaultAuthors[10], // Takehiko Inoue
    summary: 'A fictionalized account of the life of Japanese swordsman Musashi Miyamoto.',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/2/260702l.jpg',
    type: BookType.manga,
    chapters: null, // On Hiatus
    status: 'On Hiatus',
    isFinished: false,
    language: defaultLanguages[2], // Japanese
    genres: [defaultGenres[6], defaultGenres[7], defaultGenres[9]], // Action, Adventure, Drama
  ),
  // One Piece
  Comic(
    id: '3',
    title: 'One Piece',
    author: defaultAuthors[12], // Eiichiro Oda
    summary: 'Follows Monkey D. Luffy on his quest to become the Pirate King.',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/2/253146.jpg',
    type: BookType.manga,
    chapters: null, // Ongoing
    status: 'Ongoing',
    isReading: true,
    language: defaultLanguages[2], // Japanese
    genres: [defaultGenres[6], defaultGenres[7], defaultGenres[2], defaultGenres[8]], // Action, Adventure, Fantasy, Comedy
  ),
  // Kaoru Hana wa Rin to Saku
  Comic(
    id: '4',
    title: 'Kaoru Hana wa Rin to Saku',
    author: defaultAuthors[1], // Saka Mikami
    summary: 'A surprising friendship blossoms between a delinquent boy and a cheerful girl from a prestigious academy.',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/5/256607l.jpg',
    type: BookType.manga,
    chapters: null, // Ongoing
    status: 'Ongoing',
    isFinished: false,
    language: defaultLanguages[2], // Japanese
    genres: [defaultGenres[3], defaultGenres[9]], // Romance, School
  ),
  // Vinland Saga
  Comic(
    id: '5',
    title: 'Vinland Saga',
    author: defaultAuthors[11], // Makoto Yukimura
    summary: 'A historical manga that follows the journey of Thorfinn, a young Icelandic boy who seeks revenge for his father\'s death.',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/2/309879l.jpg',
    type: BookType.manga,
    chapters: null, // Ongoing
    status: 'Ongoing',
    isReading: false,
    language: defaultLanguages[2], // Japanese
    genres: [defaultGenres[6], defaultGenres[7], defaultGenres[9]], // Action, Adventure, Drama
  ),
  // One Punch Man
  Comic(
    id: '6',
    title: 'One Punch Man',
    author: defaultAuthors[9], // ONE
    summary: 'Follows Saitama, a hero who can defeat any opponent with a single punch.',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/3/80661l.jpg',
    type: BookType.manga,
    chapters: null, // Ongoing
    status: 'Ongoing',
    isFinished: false,
    language: defaultLanguages[2], // Japanese
    genres: [defaultGenres[6], defaultGenres[1], defaultGenres[8], defaultGenres[9]], // Action, Sci-Fi, Comedy, Parody
  ),
  Comic(
    id: '7',
    title: 'The Great Estate Developer',
    author: defaultAuthors[2],
    summary: '''
      There is no bigger scum of the earth than Lloyd Frontera. He is the eldest son, yet all he does is drink and intimidate others, depleting what little is left of his family's wealth. The Fronteras' knight, Javier Asrahan, is destined to become a renowned swordmaster, and Lloyd's family will face pitiful deaths as their entire land falls to ruin under insurmountable debt.
      
      Though at some point Kim Suho was an average civil engineering student in Korea, he suddenly wakes up on a dirt road as none other than Lloyd, an ungrateful hooligan from the beginning of a book following Javier, the protagonist. While a sassy status window offers some clarity about his new identity, Suho is rather worried about his imminent downfall.
      
      To avoid becoming a beggar—and ultimately lead a sweet and comfortable life—Suho decides to fix Lloyd's scumbag image. With his engineering expertise and magical construction skills boost, Suho introduces modern innovations and city developments to this medieval-like world, drastically improving the people's quality of life—all for a nice sum of money.
    ''',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/5/274459l.jpg',
    type: BookType.manhwa,
    chapters: 210,
    isReading: true,
    currentChapter: 150,
    status: 'Finished',
    language: defaultLanguages[3],
    genres: [defaultGenres[8], defaultGenres[7], defaultGenres[2]],
  ),
  Comic(
    id: '8',
    title: 'Haikyuu!!',
    author: defaultAuthors[4],
    summary: '''
    The whistle blows. The ball is up. A dig. A set. A spike.
    
    Volleyball. A sport where two teams face off, separated by a formidable, wall-like net.
    
    The "Little Giant," standing at only 170 centimeters, overcomes the towering net and the wall of blockers. The awe-inspired Shouyou Hinata looks on at the ace's crow-like figure. Determined to reach great heights like the Little Giant, small-statured Hinata finally manages to form a team in his last year of junior high school, and enters his first volleyball tournament. However, his team is utterly defeated in their first game against the powerhouse school Kitagawa Daiichi, led by the genius, but oppressive setter dubbed the "King of the Court," Tobio Kageyama.
    
    Hinata enrolls into Karasuno High School seeking to take revenge against Kageyama in an official high school match and to follow in the Little Giant's footsteps—but his plans are ruined when he opens the gymnasium door to find Kageyama as one of his teammates.
    
    Now, Hinata must establish himself on the team and work alongside the problematic Kageyama to overcome his shortcomings and to fulfill his dream of making it to the top of the high school volleyball world.
  ''',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/2/258225l.jpg',
    type: BookType.manga,
    chapters: 407,
    status: 'Finished',
    isReading: false,
    isFinished: true,
    currentChapter: 407,
    language: defaultLanguages[2],
    genres: [defaultGenres[10]],
  ),
  Comic(
    id: '9',
    title: 'Nan Hao Shang Feng',
    author: defaultAuthors[5],
    summary: '''
      A comedy about two ordinary high school boys.
      
      Nan Hao Shang Feng is a web comic released on the author's Weibo account since January 12, 2019, and published in book format by Zhejiang Business University Publishing House (浙江工商大学出版社) since April 30, 2021. The series won Silver in the 14th Japan International Manga Award in 2020.
    ''',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/1/254654l.jpg',
    type: BookType.manhua,
    chapters: null,
    status: 'Ongoing',
    isReading: false,
    genres: [defaultGenres[8]],
  ),
    Novel(
    id: '10',
    title: 'Yahari Ore no Seishun Love Comedy wa Machigatteiru. (Oregairu)',
    author: defaultAuthors[6],
    summary: '''
      Hachiman Hikigaya, a student in Soubu High School, is a cynical loner due to his traumatic past experiences in his social life. This eventually led to him developing a set of "dead fish eyes" and a twisted personality similar to that of a petty criminal. Believing that the concept of youth is a lie made up by youngsters who face their failures in denial, he turns in an essay that criticizes this exact mentality of youths. Irritated by the submission, his homeroom teacher, Shizuka Hiratsuka, forces him to join the Volunteer Service Club—a club that assists students to solve their problems in life, hoping that helping other people would change his personality.
      
      However, Yukino Yukinoshita, the most beautiful girl in school, is surprisingly the sole member of the club and a loner, albeit colder and smarter than Hikigaya. Their club soon expands when Yui Yuigahama joins them after being helped with her plight, and they begin to accept more requests.
      
      With his status quo as a recluse, Hikigaya attempts to solve problems in his own way, but his methods may prove to be a double-edged sword.
    ''',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/1/316230l.jpg',
    pageCount: 168,
    isReading: false,
    language: defaultLanguages[2],
    genres: [defaultGenres[8], defaultGenres[3]],
    type: BookType.lightNovel,
  ),
  Novel(
    id: '11',
    title: 'Lord Of the Mysteries',
    author: defaultAuthors[7],
    summary: '''
      Through the storm of steam and machinery, who can achieve the extraordinary? In the mist of history and darkness, who whispers to me? When I woke up from the haze of mystery, I found myself in a world of guns, cannons, giant ships, airships, difference engines; potions, divination, curses, hanged men, and sealed artifacts. But the light still shines between it all, and the mystery is never more than two steps away. This is the legend of the Fool.

      Guimi Zhi Zhu began as a web novel on Qidian on April 1, 2018. The series was published in print in China from May 1, 2020, to August 1, 2023.
      
      The web novel version was published digitally in English as Lord of Mysteries by Webnovel. The volumes have been published by Yen Press under the Yen On imprint since July 29, 2025.
    ''',
    coverImageUrl: 'https://cdn.myanimelist.net/images/manga/1/287598l.jpg',
    pageCount: 366,
    isReading: false,
    language: defaultLanguages[4],
    genres: [defaultGenres[6], defaultGenres[2], defaultGenres[4]],
  ),
];
