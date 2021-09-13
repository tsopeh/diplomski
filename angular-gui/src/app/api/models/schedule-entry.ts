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
