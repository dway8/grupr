import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { CreateUserDto } from '../user/dto/create-user.dto';
import { VerifyUserDto } from './dto/verify-user.dto';
import { PhoneNumberDto } from './dto/phone-number.dto';
import { UnauthorizedException } from '@nestjs/common';
import { User } from 'src/user/entities/user.entity';

describe('AuthController', () => {
  let authController: AuthController;
  let authService: AuthService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        {
          provide: AuthService,
          useValue: {
            requestSignup: jest.fn(),
            verifySignup: jest.fn(),
            validateUser: jest.fn(),
            login: jest.fn(),
          },
        },
      ],
    }).compile();

    authController = module.get<AuthController>(AuthController);
    authService = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(authController).toBeDefined();
  });

  describe('signup', () => {
    it('should call AuthService.requestSignup with correct phone number', async () => {
      const createUserDto: CreateUserDto = { phoneNumber: '1234567890' };
      await authController.signup(createUserDto);
      expect(authService.requestSignup).toHaveBeenCalledWith(
        createUserDto.phoneNumber,
      );
    });

    it('should return the result from AuthService.requestSignup', async () => {
      const createUserDto: CreateUserDto = { phoneNumber: '1234567890' };
      const result = { message: 'Verification code sent' };
      jest.spyOn(authService, 'requestSignup').mockResolvedValue(result);
      expect(await authController.signup(createUserDto)).toBe(result);
    });
  });

  describe('verify', () => {
    it('should call AuthService.verifySignup with correct phone number and verification code', async () => {
      const verifyUserDto: VerifyUserDto = {
        phoneNumber: '1234567890',
        verificationCode: '123456',
      };
      await authController.verify(verifyUserDto);
      expect(authService.verifySignup).toHaveBeenCalledWith(
        verifyUserDto.phoneNumber,
        verifyUserDto.verificationCode,
      );
    });

    it('should return the result from AuthService.verifySignup', async () => {
      const verifyUserDto: VerifyUserDto = {
        phoneNumber: '1234567890',
        verificationCode: '123456',
      };
      const result = { access_token: 'token' };
      jest.spyOn(authService, 'verifySignup').mockResolvedValue(result);
      expect(await authController.verify(verifyUserDto)).toBe(result);
    });
  });

  describe('login', () => {
    it('should call AuthService.validateUser with correct phone number', async () => {
      const phoneNumberDto: PhoneNumberDto = { phoneNumber: '1234567890' };

      jest.spyOn(authService, 'validateUser').mockImplementation(() => {
        throw new UnauthorizedException('Invalid phone number');
      });

      try {
        await authController.login(phoneNumberDto);
      } catch (error) {
        expect(authService.validateUser).toHaveBeenCalledWith(
          phoneNumberDto.phoneNumber,
        );
      }
    });

    it('should throw UnauthorizedException if user is not found', async () => {
      const phoneNumberDto: PhoneNumberDto = { phoneNumber: '1234567890' };
      jest.spyOn(authService, 'validateUser').mockResolvedValue(null);
      await expect(authController.login(phoneNumberDto)).rejects.toThrow(
        UnauthorizedException,
      );
    });

    it('should return the result from AuthService.login if user is valid', async () => {
      const phoneNumberDto: PhoneNumberDto = { phoneNumber: '1234567890' };
      const user = { phoneNumber: phoneNumberDto.phoneNumber } as User;
      const result = { access_token: 'token' };
      jest.spyOn(authService, 'validateUser').mockResolvedValue(user);
      jest.spyOn(authService, 'login').mockResolvedValue(result);
      expect(await authController.login(phoneNumberDto)).toBe(result);
    });
  });
});
