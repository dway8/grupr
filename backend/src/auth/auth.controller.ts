import { Controller, Post, Body, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiTags } from '@nestjs/swagger';
import { CreateUserDto } from '../user/dto/create-user.dto';
import { VerifyUserDto } from './dto/verify-user.dto';
import { PhoneNumberDto } from './dto/phone-number.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('signup')
  async signup(@Body() createUserDto: CreateUserDto) {
    return this.authService.requestSignup(createUserDto.phoneNumber);
  }

  @Post('verify')
  async verify(@Body() verifyUserDto: VerifyUserDto) {
    return this.authService.verifySignup(
      verifyUserDto.phoneNumber,
      verifyUserDto.verificationCode,
    );
  }

  @Post('login')
  async login(@Body() phoneNumberDto: PhoneNumberDto) {
    const user = await this.authService.validateUser(
      phoneNumberDto.phoneNumber,
    );
    if (!user) {
      throw new UnauthorizedException('Invalid phone number');
    }
    return this.authService.login(user);
  }
}
