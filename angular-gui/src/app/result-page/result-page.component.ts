import { Component, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import differenceInMilliseconds from 'date-fns/differenceInMilliseconds'
import intervalToDuration from 'date-fns/intervalToDuration'
import { forkJoin, Subject } from 'rxjs'
import { takeUntil } from 'rxjs/operators'
import {
  ScheduleApiService,
  ScheduleEntryBrief,
  Station,
  StationId,
} from '../api'

@Component({
  selector: 'app-result-page',
  templateUrl: './result-page.component.html',
  styleUrls: ['./result-page.component.scss'],
})
export class ResultPageComponent implements OnInit, OnDestroy {

  private stations: ReadonlyArray<Station> | null = null

  public departureStationId: StationId = '' as StationId
  public arrivalStationId: StationId = '' as StationId
  public departureDateTime: Date = new Date()

  public entries: ReadonlyArray<ScheduleEntryBrief> | null = null

  private destroyed$ = new Subject<void>()

  constructor (
    private readonly route: ActivatedRoute,
    private readonly api: ScheduleApiService,
  ) {
  }

  ngOnInit (): void {
    const params = this.route.snapshot.queryParamMap
    this.departureStationId = params.get('from')! as StationId
    this.arrivalStationId = params.get('to')! as StationId
    this.departureDateTime = new Date(params.get('t')!)

    forkJoin([
      this.api.getAllStations(),
      this.api.getBriefSchedules({
        from: this.departureStationId,
        to: this.arrivalStationId,
        departureDateTime: this.departureDateTime.toISOString(),
      }),
    ]).pipe(
      takeUntil(this.destroyed$),
    ).subscribe(([stations, entries]) => {
      this.stations = stations
      this.entries = entries
    })
  }

  public ngOnDestroy (): void {
    this.destroyed$.next()
    this.destroyed$.complete()
  }

  public getStationName (id: StationId): string {
    return this.stations?.find(station => station.id == id)?.name ?? 'N/A'
  }

  public getLength (entry: ScheduleEntryBrief): string {
    const diff = differenceInMilliseconds(
      new Date(entry.arrival.dateTime),
      new Date(entry.departure.dateTime),
    )
    return formatDurationAsHoursAndMinutes(diff)
  }

  public getLatency (latencyMs: number): string {
    return formatDurationAsHoursAndMinutes(latencyMs)
  }

}

function formatDurationAsHoursAndMinutes (durationMs: number): string {
  const { hours = 0, minutes = 0 } = intervalToDuration({
    start: 0,
    end: durationMs,
  })
  const hoursPrefix = hours < 10 ? '0' : ''
  const minutesPrefix = minutes < 10 ? '0' : ''
  return `${hoursPrefix}${hours}:${minutesPrefix}${minutes}`
}
