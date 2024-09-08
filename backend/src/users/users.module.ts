import { Module } from '@nestjs/common';
import { UserService } from './users.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
