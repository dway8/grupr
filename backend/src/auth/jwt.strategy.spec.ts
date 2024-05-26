import { Test, TestingModule } from '@nestjs/testing';
import { JwtStrategy } from './jwt.strategy';
import { ConfigService } from '@nestjs/config';
import { UserService } from '../user/user.service';
import { UnauthorizedException } from '@nestjs/common';

describe('JwtStrategy', () => {
  let jwtStrategy: JwtStrategy;
  let configService: ConfigService;
  let userService: UserService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        JwtStrategy,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key: string) => {
              if (key === 'JWT_SECRET') return 'test-secret';
            }),
          },
        },
        {
          provide: UserService,
          useValue: {
            findById: jest.fn(),
          },
        },
      ],
    }).compile();

    jwtStrategy = module.get<JwtStrategy>(JwtStrategy);
    configService = module.get<ConfigService>(ConfigService);
    userService = module.get<UserService>(UserService);
  });

  it('should be defined', () => {
    expect(jwtStrategy).toBeDefined();
  });

  describe('validate', () => {
    it('should validate and return the user based on JWT payload', async () => {
      const user = {
        id: 1,
        phoneNumber: '1234567890',
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      const payload = { sub: 1, phoneNumber: '1234567890' };

      jest.spyOn(userService, 'findById').mockResolvedValue(user);

      const result = await jwtStrategy.validate(payload);
      expect(result).toEqual({
        userId: payload.sub,
        phoneNumber: payload.phoneNumber,
      });
      expect(userService.findById).toHaveBeenCalledWith(payload.sub);
    });

    it('should throw an unauthorized exception if user is not found', async () => {
      const payload = { sub: 1, phoneNumber: '1234567890' };

      jest.spyOn(userService, 'findById').mockResolvedValue(null);

      await expect(jwtStrategy.validate(payload)).rejects.toThrow(
        UnauthorizedException,
      );
    });
  });
});
