import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty } from 'class-validator';

export class PhoneNumberDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  phoneNumber: string;
}
