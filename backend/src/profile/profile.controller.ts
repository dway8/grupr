import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { ProfileService } from './profile.service';
import { CreateProfileDto } from './dto/create-profile.dto';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';

@ApiTags('profile')
@Controller('profile')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @ApiBearerAuth()
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: 'Create user profile' })
  @ApiResponse({
    status: 201,
    description: 'The profile has been successfully created.',
  })
  @ApiResponse({ status: 403, description: 'Forbidden.' })
  @Post('create')
  async createProfile(
    @Request() req,
    @Body() createProfileDto: CreateProfileDto,
  ) {
    const userId = req.user.userId;
    return this.profileService.createProfile(userId, createProfileDto);
  }
}
