import { HttpClient } from '@angular/common/http'
import { Injectable } from '@angular/core'
import addHours from 'date-fns/addHours'
import { Observable } from 'rxjs'
import { repeat } from '../utls'
import {
  ScheduleEntryBrief,
  ScheduleEntryId,
  ScheduleEntryState,
  Station,
  StationId,
  TrainId,
  TrainType,
} from './models'
import { createUrl } from './server'

export interface GetScheduleEntriesInput {
  from: StationId
  to: StationId
  departureDateTime: string
}

@Injectable({ providedIn: 'root' })
export class ScheduleApiService {

  public constructor (
    private readonly http: HttpClient,
  ) {
  }

  public getAllStations (): Observable<ReadonlyArray<Station>> {
    return this.http.get<ReadonlyArray<Station>>(createUrl(`stations`))
  }

  public getSchedule (params: GetScheduleEntriesInput): Promise<ReadonlyArray<ScheduleEntryBrief>> {
    return new Promise((resolve, reject) => {
      const entry: ScheduleEntryBrief = {
        id: 1 as any as ScheduleEntryId,
        departureStation: '12551' as StationId,
        arrivalStation: '16052' as StationId,
        departureDateTime: new Date().toISOString(),
        arrivalDateTime: addHours(new Date(), 3).toISOString(),
        latency: null,
        notice: null,
        state: ScheduleEntryState.Planned,
        startingPrice: 800,
        train: {
          id: 1 as any as TrainId,
          trainNumber: 1,
          type: TrainType.Regional,
        },
      }
      const data: ReadonlyArray<ScheduleEntryBrief> = repeat(entry, 5)
      resolve(data)
    })
  }

}