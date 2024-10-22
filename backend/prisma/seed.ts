import { PrismaClient } from '@prisma/client';
import { faker } from '@faker-js/faker';

const prisma = new PrismaClient();
const TEST_AUTH0_USER_ID = process.env.TEST_AUTH0_USER_ID;

const eventsSeeds = [
  {
    name: 'Party at mine',
    description:
      'Come chill at my place for a relaxed house party. Drinks, music, good vibes, and maybe some dancing later!',
    startTime: 21,
  },
  {
    name: 'Hanging out at the pub',
    description:
      'Just grabbing a few pints at the local pub. No big plans, just catching up and hanging out.',
    startTime: 18,
  },
  {
    name: 'Weekend coffee meetup',
    description:
      'Meeting up for coffee this weekend. Low-key vibe, perfect for a chat and some caffeine!',
    startTime: 10,
  },
  {
    name: 'Brunch with friends',
    description:
      'Late morning brunch with pancakes, eggs, and everything in between. Come hungry!',
    startTime: 11,
  },
  {
    name: 'Movie night at the park',
    description:
      'Outdoor movie night at the park—bring a blanket, some snacks, and your favorite movie quotes.',
    startTime: 20,
  },
  {
    name: 'BBQ at the lake',
    description:
      'Grilling out by the lake this weekend. Bring something to throw on the grill and enjoy the chill by the water.',
    startTime: 14,
  },
  {
    name: 'Yoga in the garden',
    description:
      'Morning yoga session in the garden. Perfect way to start your day. No pressure—just stretch it out!',
    startTime: 8,
  },
  {
    name: 'Board game night',
    description:
      'Grab your favorite board games and let’s see who’s the real champ. It’s all fun until someone flips the board!',
    startTime: 19,
  },
  {
    name: 'Cocktails and chill',
    description:
      'Mixing up some cocktails and chilling at my place. Nothing fancy, just a fun evening with good drinks.',
    startTime: 20,
  },
  {
    name: 'Beach day hangout',
    description:
      'A day at the beach, soaking up the sun. We’ll bring the volleyball, you bring the sunscreen!',
    startTime: 12,
  },
  {
    name: 'Trivia night at the bar',
    description:
      'Let’s hit up the pub for trivia night! Bring your random facts and let’s see who’s the smartest.',
    startTime: 19,
  },
  {
    name: 'Cycling around the city',
    description:
      'Casual bike ride around the city. Great way to explore, get some fresh air, and maybe grab a snack after!',
    startTime: 16,
  },
  {
    name: 'Live music at the café',
    description:
      'There’s live music at the café tonight. Let’s grab some coffee and enjoy the tunes!',
    startTime: 18,
  },
  {
    name: 'Book club discussion',
    description:
      'Our monthly book club is on! Let’s chat about the latest read—no worries if you didn’t finish, it’s all good.',
    startTime: 17,
  },
  {
    name: 'Late-night karaoke',
    description:
      'Who’s up for some late-night karaoke? It’s all about having fun and hitting those high notes (or not)!',
    startTime: 22,
  },
  {
    name: 'Picnic at the park',
    description:
      'Pack up some snacks and join us for a laid-back picnic at the park. Sun, food, and good company.',
    startTime: 13,
  },
  {
    name: 'Pizza and gaming night',
    description:
      'Pizza and video games all night! Bring your controller and your appetite—it’s gonna be epic.',
    startTime: 19,
  },
  {
    name: 'Sunset hike meetup',
    description:
      'A chill sunset hike to take in some great views and get a little exercise. Don’t forget your water bottle!',
    startTime: 18,
  },
  {
    name: 'Paint and sip session',
    description:
      'Grab a drink and a paintbrush—it’s a casual paint and sip session. No art skills needed, just good times!',
    startTime: 15,
  },
  {
    name: 'Midweek dinner plans',
    description:
      'Breaking up the week with a chill dinner at my place. Let’s eat, chat, and maybe watch a show after.',
    startTime: 19,
  },
];

async function main() {
  await prisma.event.deleteMany();
  await prisma.profile.deleteMany();

  // Create 5 profiles
  const profilesData = Array.from({ length: 4 }).map(() =>
    createProfile({ userId: faker.string.uuid() }),
  );
  profilesData.push(createProfile({ userId: TEST_AUTH0_USER_ID }));
  await prisma.profile.createMany({
    data: profilesData,
  });

  // Create events for 4 profiles
  for (let i = 1; i < 5; i++) {
    const profile = await prisma.profile.findFirst({
      skip: i,
      take: 1,
    });

    const eventsCount = faker.number.int({ min: 1, max: 4 });

    for (let j = 0; j < eventsCount; j++) {
      const randomEvent =
        eventsSeeds[Math.floor(Math.random() * eventsSeeds.length)];
      const date = faker.date.future();
      date.setHours(randomEvent.startTime, 0, 0);
      await prisma.event.create({
        data: {
          name: randomEvent.name,
          description: randomEvent.description,
          location: faker.location.city(),
          latitude: faker.location.latitude(),
          longitude: faker.location.longitude(),
          date,
          userId: profile.userId,
        },
      });
    }
  }
}

function createProfile({ userId }) {
  return {
    userId,
    firstName: faker.person.firstName(),
    dateOfBirth: faker.date.past({ years: 20 }),
    city: faker.location.city(),
    country: faker.location.country(),
    latitude: faker.location.latitude(),
    longitude: faker.location.longitude(),
  };
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
