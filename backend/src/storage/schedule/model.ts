import { Station } from "../station/index.ts";
export type ScheduleId = string & { __SCHEDULE_ID__: undefined };

export interface ScheduleFull {
  id: ScheduleId;
  train: {
    id: number; // TODO: TrainId
    trainNumber: string; // TODO: number
    type: "regional" | "local";
  };
  latency: number;
  ticketStartingPrice: number;
  stations: Array<
    Station & {
      arrivalDateTime: string; // Date
      departureDateTime: string; // Date
    }
  >;
}

export interface ScheduleBrief {
  id: ScheduleId;
  train: {
    id: number; // TODO: TrainId
    trainNumber: string; // TODO: number
    type: "regional" | "local";
  };
  latency: number;
  ticketStartingPrice: number;
  departure: Station & { dateTime: string };
  arrival: Station & { dateTime: string };
}
