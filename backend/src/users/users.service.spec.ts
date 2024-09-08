import { Test, TestingModule } from '@nestjs/testing';
import { UserService } from './users.service';
import { PrismaService } from '../prisma/prisma.service';
import { User } from '@prisma/client';

describe('UserService', () => {
  let userService: UserService;
  let prismaService: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: PrismaService,
          useValue: {
            user: {
              findUnique: jest.fn(),
              create: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    userService = module.get<UserService>(UserService);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(userService).toBeDefined();
  });

  describe('findByPhoneNumber', () => {
    it('should find a user by phone number', async () => {
      const phoneNumber = '1234567890';
      const user: User = {
        id: 1,
        phoneNumber,
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(user);
      const result = await userService.findByPhoneNumber(phoneNumber);
      expect(result).toEqual(user);
    });

    it('should return null if user not found', async () => {
      jest.spyOn(prismaService.user, 'findUnique').mockResolvedValue(null);
      const result = await userService.findByPhoneNumber('1234567890');
      expect(result).toBeNull();
    });
  });

  describe('create', () => {
    it('should create a user with correct data', async () => {
      const phoneNumber = '1234567890';
      const user: User = {
        id: 1,
        phoneNumber,
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      jest.spyOn(prismaService.user, 'create').mockResolvedValue(user);
      const result = await userService.create(phoneNumber);
      expect(result).toEqual(user);
    });
  });
});
