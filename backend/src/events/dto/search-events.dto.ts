import { IsNumber, IsOptional, IsDate } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

export class SearchEventsDto {
  @IsNumber()
  @Type(() => Number)
  @ApiProperty({ example: 40.7128 })
  lat: number;

  @IsNumber()
  @Type(() => Number)
  @ApiProperty({ example: -74.006 })
  lon: number;

  @IsOptional()
  @IsDate()
  @Type(() => Date)
  @ApiProperty({ required: false, example: '2023-04-20' })
  startDate?: Date;

  @IsOptional()
  @IsDate()
  @Type(() => Date)
  @ApiProperty({ required: false, example: '2023-04-21' })
  endDate?: Date;
}
