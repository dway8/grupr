import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProfileDto } from './dto/create-profile.dto';

@Injectable()
export class ProfileService {
  constructor(private prisma: PrismaService) {}

  async createProfile(userId: number, createProfileDto: CreateProfileDto) {
    return this.prisma.profile.create({
      data: {
        userId,
        firstName: createProfileDto.firstName,
        dateOfBirth: new Date(createProfileDto.dateOfBirth),
        city: createProfileDto.city,
        country: createProfileDto.country,
      },
    });
  }
}
