import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProfileDto } from './dto/create-profile.dto';
import { ProfileResponseDto } from './dto/profile-response.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Injectable()
export class ProfilesService {
  constructor(private prisma: PrismaService) {}

  async createProfile(userId: string, createProfileDto: CreateProfileDto) {
    const dateOfBirth = new Date(createProfileDto.dateOfBirth);
    dateOfBirth.setUTCHours(0, 0, 0, 0);

    return await this.prisma.profile.create({
      data: {
        userId,
        firstName: createProfileDto.firstName,
        dateOfBirth,
        city: createProfileDto.city,
        country: createProfileDto.country,
        latitude: createProfileDto.latitude,
        longitude: createProfileDto.longitude,
      },
    });
  }

  async getProfile(userId: string): Promise<ProfileResponseDto | null> {
    return await this.prisma.profile.findUnique({
      where: { userId },
      select: {
        firstName: true,
        dateOfBirth: true,
        city: true,
        country: true,
        latitude: true,
        longitude: true,
      },
    });
  }

  async updateProfile(
    userId: string,
    updateProfileDto: UpdateProfileDto,
  ): Promise<ProfileResponseDto> {
    const dateOfBirth = new Date(updateProfileDto.dateOfBirth);
    dateOfBirth.setUTCHours(0, 0, 0, 0);

    const updatedProfile = await this.prisma.profile.update({
      where: { userId },
      data: {
        firstName: updateProfileDto.firstName,
        dateOfBirth,
        city: updateProfileDto.city,
        country: updateProfileDto.country,
        latitude: updateProfileDto.latitude,
        longitude: updateProfileDto.longitude,
      },
    });

    return updatedProfile as ProfileResponseDto;
  }
}
