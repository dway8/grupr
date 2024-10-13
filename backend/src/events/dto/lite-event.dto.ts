import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsOptional } from 'class-validator';

export class LiteEventDto {
  @ApiProperty({ description: 'Unique identifier for the event' })
  @IsNumber()
  id: number;

  @ApiProperty({ description: 'Name of the event' })
  @IsString()
  name: string;

  @ApiProperty({ description: 'Latitude of the event location' })
  @IsNumber()
  latitude: number;

  @ApiProperty({ description: 'Longitude of the event location' })
  @IsNumber()
  longitude: number;

  @ApiProperty({ description: 'URL of the event image' })
  @IsOptional()
  @IsString()
  imageUrl?: string;
}
