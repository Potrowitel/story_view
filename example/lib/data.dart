import 'package:flutter/material.dart';
import 'package:stories/stories.dart';

final cell = StoryCell(
    iconUrl:
        'http://services.myhalyk.kg/images/stories/dce23ea9-f32b-41a0-b694-c00ce6560187.png',
    watched: false,
    stories: [
      // Story(
      //   'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      //   meadiaType: MediaType.video,
      // ),

      Story(
        url:
            'http://services.myhalyk.kg/images/stories/b9c7e09c-e1bd-438b-8452-5616ab8b2888.png',
        actionButton: StoryActionButton(onTap: () => print('Test')),
        duration: const Duration(milliseconds: 6005),
        gradientStart: const Color(0xFF3660D2),
        gradientEnd: const Color(0xff008ac1),
        backType: 'GRADIENT',
      ),
      Story(
        url:
            'https://services.myhalyk.kg/images/stories/e403e94e-f633-4c45-9ba1-67efffa9fb5d.png',
        actionButton: StoryActionButton(onTap: () => print('Test')),
        duration: const Duration(milliseconds: 7006),
        gradientStart: const Color(0xFFF4C43C),
        gradientEnd: const Color(0xFF2AB67C),
        backType: 'GRADIENT',
      ),
      Story(
        url:
            'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
        duration: const Duration(milliseconds: 8007),
      ),
      Story(
        url: 'https://picsum.photos/250?image=9',
        actionButton: StoryActionButton(onTap: () => print('Test')),
        duration: const Duration(milliseconds: 9008),
      ),
      Story(
        url:
            'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
        actionButton: StoryActionButton(onTap: () => print('Test')),
        duration: const Duration(milliseconds: 10009),
      ),
      Story(
        url: 'https://picsum.photos/250?image=9',
        duration: const Duration(milliseconds: 11010),
      ),
      Story(
        url:
            'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
        actionButton: StoryActionButton(onTap: () => print('Test')),
        duration: const Duration(milliseconds: 12011),
      ),
    ]);
final cell1 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url: 'https://picsum.photos/250?image=9',
        meadiaType: MediaType.image,
      ),
      Story(
        url:
            'https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4',
        meadiaType: MediaType.video,
      ),
      Story(
        //'assets/images/image.jpg',
        url:
            'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
      ),
      Story(
        url:
            'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
      ),
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        meadiaType: MediaType.video,
        gradientStart: const Color(0xFF3660D2),
        gradientEnd: const Color(0xff008ac1),
      ),
    ]);

final cell5 = StoryCell(
    watched: false,
    iconUrl:
        'http://services.myhalyk.kg/images/stories/b3ae514c-8597-48c5-8a7b-6a4ef5b0acf1.png',
    stories: [
      Story(
        url:
            'http://testservices.myhalyk.kg/images/stories/b906b028-be98-4f8d-9134-de5c469113f4.png',
        duration: const Duration(milliseconds: 7006),
        gradientStart: const Color(0xFFF4C43C),
        gradientEnd: const Color(0xFF2AB67C),
        // meadiaType: MediaType.image,
        backType: 'GRADIENT',
      ),
    ]);
final cell6 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
        gradientStart: const Color(0xFF3660D2),
        gradientEnd: const Color(0xff008ac1),
      ),
    ]);
final cell7 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
        gradientStart: const Color(0xFF3660D2),
        gradientEnd: const Color(0xff008ac1),
      ),
    ]);
final cell8 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final cell9 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final cell10 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final cell11 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final cell12 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final cell13 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final cell14 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final cel15 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final cell16 = StoryCell(
    watched: false,
    iconUrl:
        'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
    stories: [
      Story(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        meadiaType: MediaType.video,
      ),
    ]);
final imageCell = StoryCell(
    iconUrl:
        'http://services.myhalyk.kg/images/stories/dce23ea9-f32b-41a0-b694-c00ce6560187.png',
    watched: false,
    stories: [
      Story(
        url:
            'http://services.myhalyk.kg/images/stories/b9c7e09c-e1bd-438b-8452-5616ab8b2888.png',
        actionButton: StoryActionButton(onTap: () => print('Test')),
        duration: const Duration(milliseconds: 6005),
        gradientStart: const Color(0xFF3660D2),
        gradientEnd: const Color(0xff008ac1),
        backType: 'GRADIENT',
      ),
    ]);
// final cell17 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell18 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell19 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell20 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell21 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell22 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell23 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell24 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell25 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell26 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell27 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell28 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell29 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell30 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell31 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell32 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell33 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell34 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
// final cell35 = StoryCell(
//     watched: false,
//     iconUrl:
//         'https://github.com/libgit2/libgit2sharp/raw/master/square-logo.png',
//     stories: [
//       Story(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
//         meadiaType: MediaType.video,
//       ),
//     ]);
