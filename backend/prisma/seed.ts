import { PrismaClient } from '@prisma/client';
import { faker } from '@faker-js/faker';

const prisma = new PrismaClient();
const TEST_AUTH0_USER_ID = process.env.TEST_AUTH0_USER_ID;

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
      await prisma.event.create({
        data: {
          name: faker.lorem.sentence({ min: 2, max: 5 }),
          location: faker.location.city(),
          latitude: faker.location.latitude(),
          longitude: faker.location.longitude(),
          date: faker.date.future(),
          description: faker.lorem.paragraph(),
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
