import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { EventsService } from 'src/events/events.service';

@Module({
  controllers: [UsersController],
  providers: [EventsService],
})
export class UsersModule {}
