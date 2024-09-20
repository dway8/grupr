import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProfileDto } from './dto/create-profile.dto';

@Injectable()
export class ProfilesService {
  constructor(private prisma: PrismaService) {}

  async createProfile(createProfileDto: CreateProfileDto) {
    const dateOfBirth = new Date(createProfileDto.dateOfBirth);
    dateOfBirth.setUTCHours(0, 0, 0, 0);

    return this.prisma.profile.create({
      data: {
        userId: createProfileDto.userId,
        firstName: createProfileDto.firstName,
        dateOfBirth,
        city: createProfileDto.city,
        country: createProfileDto.country,
        latitude: createProfileDto.latitude,
        longitude: createProfileDto.longitude,
      },
    });
  }
}
