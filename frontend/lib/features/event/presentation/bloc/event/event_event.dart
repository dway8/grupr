abstract class EventEvent {
  const EventEvent();
}

class FetchEvent extends EventEvent {
  final int eventId;

  const FetchEvent(this.eventId);
}
