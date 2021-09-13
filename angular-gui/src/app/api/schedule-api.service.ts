import { HttpClient } from '@angular/common/http'
import { Injectable } from '@angular/core'
import { Observable } from 'rxjs'
import { ScheduleEntryBrief, Station, StationId } from './models'
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

  public getSchedule (params: GetScheduleEntriesInput): Observable<ReadonlyArray<ScheduleEntryBrief>> {
    return this.http.get<ReadonlyArray<ScheduleEntryBrief>>(createUrl(`schedule`))
  }

}