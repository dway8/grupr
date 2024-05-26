import { Test, TestingModule } from '@nestjs/testing';
import { ProfileService } from './profile.service';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProfileDto } from './dto/create-profile.dto';
import { PrismaClient, Profile } from '@prisma/client';

describe('ProfileService', () => {
  let service: ProfileService;
  let prismaService: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProfileService,
        {
          provide: PrismaService,
          useValue: new PrismaClient(), // Use PrismaClient for testing
        },
      ],
    }).compile();

    service = module.get<ProfileService>(ProfileService);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create a profile', async () => {
    const createProfileDto: CreateProfileDto = {
      firstName: 'John',
      dateOfBirth: '1990-01-01',
      city: 'New York',
      country: 'USA',
    };

    const mockProfile: Profile = {
      id: 1,
      firstName: 'John',
      dateOfBirth: new Date('1990-01-01'),
      city: 'New York',
      country: 'USA',
      userId: 1,
    };

    jest.spyOn(prismaService.profile, 'create').mockResolvedValue(mockProfile);

    const result = await service.createProfile(1, createProfileDto);

    expect(result).toEqual(mockProfile);
    expect(prismaService.profile.create).toHaveBeenCalledWith({
      data: {
        userId: 1,
        firstName: createProfileDto.firstName,
        dateOfBirth: new Date(createProfileDto.dateOfBirth),
        city: createProfileDto.city,
        country: createProfileDto.country,
      },
    });
  });
});
