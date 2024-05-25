import {
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import { User } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private jwtService: JwtService,
    private prisma: PrismaService,
  ) {}

  generateVerificationCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString(); // Generate a 6-digit code
  }

  async requestSignup(phoneNumber: string) {
    const verificationCode = this.generateVerificationCode();
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes from now

    await this.prisma.signupRequest.create({
      data: {
        phoneNumber,
        verificationCode,
        expiresAt,
      },
    });

    // TODO: Send verification code via SMS
    return { message: 'Verification code sent' };
  }

  async validateUser(phoneNumber: string): Promise<any> {
    const user = await this.userService.findByPhoneNumber(phoneNumber);
    if (user) {
      const { ...result } = user;
      return result;
    }
    return null;
  }

  async login(user: User) {
    const payload = { phoneNumber: user.phoneNumber, sub: user.id };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }

  async verifySignup(phoneNumber: string, verificationCode: string) {
    const signupRequest = await this.prisma.signupRequest.findUnique({
      where: { phoneNumber },
    });

    if (!signupRequest) {
      throw new NotFoundException('Phone number not found');
    }

    if (signupRequest.verificationCode !== verificationCode) {
      throw new UnauthorizedException('Invalid verification code');
    }

    const user = await this.userService.create(phoneNumber);
    await this.prisma.signupRequest.delete({
      where: { phoneNumber },
    });
    return this.login(user);
  }
}
