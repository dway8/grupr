import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';

describe('AuthController (e2e)', () => {
  let app: INestApplication;
  let prismaService: PrismaService;
  let jwtService: JwtService;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    prismaService = app.get<PrismaService>(PrismaService);
    jwtService = app.get<JwtService>(JwtService);
    await prismaService.$connect();
    await app.init();
  });

  afterAll(async () => {
    await prismaService.$disconnect();
    await app.close();
  });

  beforeEach(async () => {
    await prismaService.signupRequest.deleteMany({});
    await prismaService.user.deleteMany({});
  });

  it('/auth/signup (POST)', async () => {
    const response = await request(app.getHttpServer())
      .post('/auth/signup')
      .send({ phoneNumber: '1234567890' })
      .expect(201);

    expect(response.body).toEqual({ message: 'Verification code sent' });

    const signupRequest = await prismaService.signupRequest.findUnique({
      where: { phoneNumber: '1234567890' },
    });
    expect(signupRequest).toBeDefined();
    expect(signupRequest.phoneNumber).toBe('1234567890');
  });

  it('/auth/verify (POST)', async () => {
    // First, create a signup request
    await prismaService.signupRequest.create({
      data: {
        phoneNumber: '1234567890',
        verificationCode: '123456',
        expiresAt: new Date(Date.now() + 15 * 60 * 1000), // Expires in 15 minutes
      },
    });

    const response = await request(app.getHttpServer())
      .post('/auth/verify')
      .send({ phoneNumber: '1234567890', verificationCode: '123456' })
      .expect(201);

    expect(response.body).toHaveProperty('access_token');

    // Verify that the signup request is deleted from the database
    const signupRequest = await prismaService.signupRequest.findUnique({
      where: { phoneNumber: '1234567890' },
    });
    expect(signupRequest).toBeNull();

    // Verify that the user is created in the database
    const user = await prismaService.user.findUnique({
      where: { phoneNumber: '1234567890' },
    });
    expect(user).toBeDefined();
    expect(user.phoneNumber).toBe('1234567890');
  });

  it('/auth/login (POST)', async () => {
    // First, create and verify a signup request to ensure the user exists
    await prismaService.signupRequest.create({
      data: {
        phoneNumber: '1234567890',
        verificationCode: '123456',
        expiresAt: new Date(Date.now() + 15 * 60 * 1000), // Expires in 15 minutes
      },
    });

    await request(app.getHttpServer())
      .post('/auth/verify')
      .send({ phoneNumber: '1234567890', verificationCode: '123456' })
      .expect(201);

    // Now, log in with the verified phone number
    const response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ phoneNumber: '1234567890' })
      .expect(201);

    expect(response.body).toHaveProperty('access_token');

    // Verify that the access token is valid by checking its payload
    const decodedToken = jwtService.decode(response.body.access_token);
    expect(decodedToken).toHaveProperty('phoneNumber', '1234567890');
  });
});
