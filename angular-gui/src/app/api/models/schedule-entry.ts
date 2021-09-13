import { Station } from './station'
import { Train } from './train'

export type ScheduleEntryId = string & { __SCHEDULE_ENTRY_ID__: undefined }

export interface ScheduleEntryBrief {
  id: ScheduleEntryId
  train: Train
  latency: number
  ticketStartingPrice: number
  departure: Station & { dateTime: string }
  arrival: Station & { dateTime: string }
}

export interface ScheduleEntryFull {
  id: ScheduleEntryId;
  train: {
    id: number; // TODO: TrainId
    trainNumber: string; // TODO: number
    type: 'regional' | 'local';
  };
  latency: number;
  ticketStartingPrice: number;
  stations: Array<Station & {
    arrivalDateTime: string; // Date
    departureDateTime: string; // Date
  }>;
}