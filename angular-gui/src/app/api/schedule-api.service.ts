import { HttpClient } from '@angular/common/http'
import { Injectable } from '@angular/core'
import { Observable } from 'rxjs'
import {
  ScheduleEntryBrief,
  ScheduleEntryFull,
  ScheduleEntryId,
  Station,
  StationId,
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

  public getBriefSchedules (params: GetScheduleEntriesInput): Observable<ReadonlyArray<ScheduleEntryBrief>> {
    return this.http.get<ReadonlyArray<ScheduleEntryBrief>>(createUrl(`schedule`))
  }

  public getFullSchedule (id: ScheduleEntryId): Observable<ScheduleEntryFull> {
    return this.http.get<ScheduleEntryFull>(createUrl(`schedule/${id}`))
  }

}