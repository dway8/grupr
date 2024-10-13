import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SearchEventsDto } from './dto/search-events.dto';
import { LiteEventDto } from './dto/lite-event.dto';

@Injectable()
export class EventsService {
  constructor(private prisma: PrismaService) {}

  async searchEvents(
    searchEventsDto: SearchEventsDto,
  ): Promise<LiteEventDto[]> {
    const { lat, lon, startDate, endDate } = searchEventsDto;

    const radius = 0.1;

    return this.prisma.event.findMany({
      where: {
        latitude: { gte: lat - radius, lte: lat + radius },
        longitude: { gte: lon - radius, lte: lon + radius },
        ...(startDate && { date: { gte: new Date(startDate) } }),
        ...(endDate && { date: { lt: this.getNextDay(endDate) } }),
      },
      select: {
        id: true,
        name: true,
        latitude: true,
        longitude: true,
        date: true,
        imageUrl: true,
        location: true,
      },
      orderBy: {
        date: 'asc',
      },
    });
  }

  private getNextDay(date: Date): Date {
    date.setDate(date.getDate() + 1);
    return date;
  }
}
