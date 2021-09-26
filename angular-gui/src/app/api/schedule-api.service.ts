import {HttpClient} from '@angular/common/http'
import {Injectable} from '@angular/core'
import {Observable} from 'rxjs'
import {ScheduleEntryBrief, ScheduleEntryFull, ScheduleEntryId, Station, StationId,} from './models'
import {createGetUrl} from './server'

export interface GetScheduleEntriesInput {
  from: StationId
  to: StationId
  departureDateTime: string
}

@Injectable({providedIn: 'root'})
export class ScheduleApiService {

  public constructor(
    private readonly http: HttpClient,
  ) {
  }

  public getAllStations(): Observable<ReadonlyArray<Station>> {
    return this.http.get<ReadonlyArray<Station>>(createGetUrl(`stations`))
  }

  public getBriefSchedules(params: GetScheduleEntriesInput): Observable<ReadonlyArray<ScheduleEntryBrief>> {
    return this.http.get<ReadonlyArray<ScheduleEntryBrief>>(createGetUrl(`schedules`, 'brief', params.from, params.to, params.departureDateTime))
  }

  public getFullSchedule(id: ScheduleEntryId): Observable<ScheduleEntryFull> {
    return this.http.get<ScheduleEntryFull>(createGetUrl(`schedules/full/${id}`))
  }

}
