import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SearchEventsDto } from './dto/search-events.dto';
import { LiteEventDto } from './dto/lite-event.dto';
import { CreateEventDto } from './dto/create-event.dto';
import { EventDto } from './dto/event.dto';

@Injectable()
export class EventsService {
  constructor(private prisma: PrismaService) {}

  async searchEvents(
    searchEventsDto: SearchEventsDto,
  ): Promise<LiteEventDto[]> {
    const { lat, lon, startDate, endDate } = searchEventsDto;

    const radius = 100000;

    return await this.prisma.event.findMany({
      where: {
        // latitude: { gte: lat - radius, lte: lat + radius },
        // longitude: { gte: lon - radius, lte: lon + radius },
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

  async getEventsByUserId(userId: string): Promise<LiteEventDto[]> {
    return await this.prisma.event.findMany({
      where: { userId },
      select: {
        id: true,
        name: true,
        date: true,
        latitude: true,
        longitude: true,
        imageUrl: true,
      },
      orderBy: {
        date: 'asc',
      },
    });
  }

  async createEvent(
    userId: string,
    createEventDto: CreateEventDto,
  ): Promise<EventDto> {
    const event = await this.prisma.event.create({
      data: {
        userId,
        name: createEventDto.name,
        location: createEventDto.location,
        date: new Date(createEventDto.date),
        description: createEventDto.description,
        latitude: createEventDto.latitude,
        longitude: createEventDto.longitude,
      },
    });

    return {
      id: event.id,
      name: event.name,
      location: event.location,
      date: event.date,
      description: event.description,
      latitude: event.latitude,
      longitude: event.longitude,
    };
  }
}
