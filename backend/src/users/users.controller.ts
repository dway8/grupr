import { Controller, Request, Get, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { EventsService } from 'src/events/events.service';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
} from '@nestjs/swagger';
import { LiteEventDto } from 'src/events/dto/lite-event.dto';

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly eventsService: EventsService) {}

  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get events created by the logged-in user' })
  @ApiResponse({
    status: 200,
    description: 'Returns a list of events created by the logged-in user',
    type: [LiteEventDto],
  })
  @Get('me/events')
  async getUserEvents(@Request() req) {
    const userId = req.user.sub;
    return this.eventsService.getEventsByUserId(userId);
  }
}
