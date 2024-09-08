import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { EventsService } from './events.service';
import { SearchEventsDto } from './dto/search-events.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('events')
@Controller('events')
export class EventsController {
  constructor(private readonly eventsService: EventsService) {}

  @Get('search')
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
  })
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  searchEvents(@Query() searchEventsDto: SearchEventsDto) {
    return this.eventsService.searchEvents(searchEventsDto);
  }
}
