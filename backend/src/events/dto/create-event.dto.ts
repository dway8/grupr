import { IsString, IsNotEmpty, IsNumber, IsDateString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateEventDto {
  @ApiProperty({
    description: 'Name of the event',
    example: 'Music Concert',
  })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({
    description: 'Location of the event',
    example: 'Central Park',
  })
  @IsString()
  @IsNotEmpty()
  location: string;

  @ApiProperty({
    description: 'Date of the event',
    example: '2023-04-20T18:00:00Z',
  })
  @IsDateString()
  @IsNotEmpty()
  date: string;

  @ApiProperty({
    description: 'Description of the event',
    example: 'An amazing music concert featuring various artists.',
  })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiProperty({
    description: 'Latitude of the event location',
    example: 40.7128,
  })
  @IsNumber()
  @IsNotEmpty()
  latitude: number;

  @ApiProperty({
    description: 'Longitude of the event location',
    example: -74.006,
  })
  @IsNumber()
  @IsNotEmpty()
  longitude: number;
}
