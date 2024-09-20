import { PrismaClient } from '@prisma/client';
import { faker } from '@faker-js/faker';

const prisma = new PrismaClient();

async function main() {
  // Create 5 profiles
  await prisma.profile.createMany({
    data: Array.from({ length: 5 }).map(() => ({
      firstName: faker.person.firstName(),
      dateOfBirth: faker.date.past({ years: 20 }),
      city: faker.location.city(),
      country: faker.location.country(),
      latitude: faker.location.latitude(),
      longitude: faker.location.longitude(),
      userId: faker.string.uuid(),
    })),
  });

  // Create events for 4 profiles
  for (let i = 0; i < 4; i++) {
    const profile = await prisma.profile.findFirst({
      skip: i,
      take: 1,
    });

    const eventsCount = faker.number.int({ min: 1, max: 3 });

    for (let j = 0; j < eventsCount; j++) {
      await prisma.event.create({
        data: {
          name: faker.lorem.sentence(),
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

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
