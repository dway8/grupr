import {
  Controller,
  Get,
  Query,
  UseGuards,
  Post,
  Body,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { EventsService } from './events.service';
import { SearchEventsDto } from './dto/search-events.dto';
import { AuthGuard } from '@nestjs/passport';
import { LiteEventDto } from './dto/lite-event.dto';
import { EventDto } from './dto/event.dto';
import { CreateEventDto } from './dto/create-event.dto';

@ApiTags('events')
@Controller('events')
export class EventsController {
  constructor(private readonly eventsService: EventsService) {}

  @Get('')
  @ApiOperation({ summary: 'Search for events' })
  @ApiQuery({ name: 'lat', required: true, type: Number })
  @ApiQuery({ name: 'lon', required: true, type: Number })
  @ApiQuery({
    name: 'startDate',
    required: false,
    type: String,
    description:
      'Start date for filtering events (format: YYYY-MM-DD, e.g., "2023-04-20")',
  })
  @ApiQuery({
    name: 'endDate',
    required: false,
    type: String,
    description:
      'End date for filtering events (format: YYYY-MM-DD, e.g., "2023-04-21")',
  })
  @ApiResponse({
    status: 200,
    description: 'Returns a list of events matching the search criteria',
    type: [LiteEventDto],
  })
  @ApiBearerAuth()
  @UseGuards(AuthGuard('jwt'))
  async searchEvents(
    @Query() searchEventsDto: SearchEventsDto,
  ): Promise<LiteEventDto[]> {
    const events = await this.eventsService.searchEvents(searchEventsDto);
    console.log(events);
    return events;
  }

  @Post('')
  @ApiOperation({ summary: 'Create a new event' })
  @ApiResponse({
    status: 201,
    description: 'The event has been successfully created.',
    type: EventDto,
  })
  @ApiBearerAuth()
  @UseGuards(AuthGuard('jwt'))
  async createEvent(
    @Request() req,
    @Body() createEventDto: CreateEventDto,
  ): Promise<EventDto> {
    const event = await this.eventsService.createEvent(
      req.user.sub,
      createEventDto,
    );
    return event;
  }
}
