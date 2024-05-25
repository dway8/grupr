import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { UserService } from '../user/user.service';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { User } from '@prisma/client';
import { NotFoundException, UnauthorizedException } from '@nestjs/common';

describe('AuthService', () => {
  let authService: AuthService;
  let userService: UserService;
  let jwtService: JwtService;
  let prismaService: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: UserService,
          useValue: {
            findByPhoneNumber: jest.fn(),
            create: jest.fn(),
          },
        },
        {
          provide: JwtService,
          useValue: {
            sign: jest.fn(() => 'token'),
          },
        },
        {
          provide: PrismaService,
          useValue: {
            signupRequest: {
              create: jest.fn(),
              findUnique: jest.fn(),
              delete: jest.fn(),
            },
            user: {
              update: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    authService = module.get<AuthService>(AuthService);
    userService = module.get<UserService>(UserService);
    jwtService = module.get<JwtService>(JwtService);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(authService).toBeDefined();
  });

  describe('generateVerificationCode', () => {
    it('should generate a 6-digit code', () => {
      const code = authService.generateVerificationCode();
      expect(code).toMatch(/^\d{6}$/);
    });
  });

  describe('requestSignup', () => {
    it('should create a signup request with the correct data', async () => {
      const phoneNumber = '1234567890';

      const res = await authService.requestSignup(phoneNumber);

      expect(prismaService.signupRequest.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          phoneNumber,
          verificationCode: expect.any(String),
          expiresAt: expect.any(Date),
        }),
      });
      expect(res).toEqual({ message: 'Verification code sent' });
    });
  });

  describe('validateUser', () => {
    it('should return user if found', async () => {
      const user: User = {
        id: 1,
        phoneNumber: '1234567890',
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      jest.spyOn(userService, 'findByPhoneNumber').mockResolvedValue(user);

      const result = await authService.validateUser(user.phoneNumber);

      expect(result).toEqual(user);
    });

    it('should return null if user not found', async () => {
      jest.spyOn(userService, 'findByPhoneNumber').mockResolvedValue(null);
      const result = await authService.validateUser('1234567890');
      expect(result).toBeNull();
    });
  });

  describe('login', () => {
    it('should return an access token', async () => {
      const user: User = {
        id: 1,
        phoneNumber: '1234567890',
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      const result = await authService.login(user);
      expect(result.access_token).toBe('token');
    });
  });

  describe('verifySignup', () => {
    it('should verify a signup request and create a user', async () => {
      const phoneNumber = '1234567890';
      const verificationCode = '123456';
      const signupRequest = {
        id: 1,
        phoneNumber,
        verificationCode,
        createdAt: new Date(),
        expiresAt: new Date(Date.now() + 15 * 60 * 1000),
      };
      jest
        .spyOn(prismaService.signupRequest, 'findUnique')
        .mockResolvedValue(signupRequest);
      const user: User = {
        id: 1,
        phoneNumber,
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      jest.spyOn(userService, 'create').mockResolvedValue(user);

      const result = await authService.verifySignup(
        phoneNumber,
        verificationCode,
      );
      expect(result.access_token).toBe('token');
    });

    it('should throw NotFoundException if signup request not found', async () => {
      jest
        .spyOn(prismaService.signupRequest, 'findUnique')
        .mockResolvedValue(null);
      await expect(
        authService.verifySignup('1234567890', '123456'),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw UnauthorizedException if verification code is invalid', async () => {
      const signupRequest = {
        id: 1,
        phoneNumber: '1234567890',
        verificationCode: '654321',
        createdAt: new Date(),
        expiresAt: new Date(Date.now() + 15 * 60 * 1000),
      };
      jest
        .spyOn(prismaService.signupRequest, 'findUnique')
        .mockResolvedValue(signupRequest);

      await expect(
        authService.verifySignup('1234567890', '123456'),
      ).rejects.toThrow(UnauthorizedException);
    });
  });
});
