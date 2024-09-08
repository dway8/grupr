import { PrismaClient } from '@prisma/client';
import { faker } from '@faker-js/faker';

const prisma = new PrismaClient();

async function main() {
  // Create 5 users with profiles
  const users = [];
  for (let i = 0; i < 5; i++) {
    const user = await prisma.user.create({
      data: {
        phoneNumber: faker.phone.number(),
        profile: {
          create: {
            firstName: faker.person.firstName(),
            dateOfBirth: faker.date.past({ years: 30 }),
            city: faker.location.city(),
            country: faker.location.country(),
            latitude: faker.location.latitude(),
            longitude: faker.location.longitude(),
          },
        },
      },
    });
    users.push(user);
  }

  // Create 10 events
  for (let i = 0; i < 10; i++) {
    await prisma.event.create({
      data: {
        name: faker.word.words(3),
        location: faker.location.streetAddress(),
        latitude: faker.location.latitude(),
        longitude: faker.location.longitude(),
        date: faker.date.future(),
        description: faker.lorem.paragraph(),
        imageUrl: faker.image.url(),
        spotifyPlaylistUrl: faker.datatype.boolean()
          ? faker.internet.url()
          : null,
        userId: users[Math.floor(Math.random() * users.length)].id,
      },
    });
  }

  console.log('Seed data created successfully');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
