import { HttpClient } from '@angular/common/http'
import { Injectable } from '@angular/core'
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
        departureDateTime: new Date().toISOString(),
        arrivalDateTime: new Date().toISOString(),
        latency: null,
        notice: null,
        state: ScheduleEntryState.Planned,
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