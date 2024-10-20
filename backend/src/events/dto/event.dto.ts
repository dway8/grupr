import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsDate } from 'class-validator';

export class EventDto {
  @ApiProperty({ description: 'Unique identifier for the event' })
  @IsNumber()
  id: number;

  @ApiProperty({ description: 'Name of the event' })
  @IsString()
  name: string;

  @ApiProperty({ description: 'Location of the event' })
  @IsString()
  location: string;

  @ApiProperty({ description: 'Date of the event' })
  @IsDate()
  date: Date;

  @ApiProperty({ description: 'Description of the event' })
  @IsString()
  description: string;

  @ApiProperty({ description: 'Latitude of the event location' })
  @IsNumber()
  latitude: number;

  @ApiProperty({ description: 'Longitude of the event location' })
  @IsNumber()
  longitude: number;

  @ApiProperty({ description: 'URL of the event image' })
  @IsString()
  imageUrl?: string;
}
