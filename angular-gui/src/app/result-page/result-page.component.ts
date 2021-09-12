import { Component, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import { forkJoin, Subject } from 'rxjs'
import { takeUntil } from 'rxjs/operators'
import { ScheduleApiService, ScheduleEntryBrief, StationId } from '../api'

@Component({
  selector: 'app-result-page',
  templateUrl: './result-page.component.html',
  styleUrls: ['./result-page.component.scss'],
})
export class ResultPageComponent implements OnInit, OnDestroy {

  public headerInfo: {
    from: string
    to: string
    departureDateTime: string
  } = {
    from: '',
    to: '',
    departureDateTime: '',
  }

  public entries: ReadonlyArray<ScheduleEntryBrief> | null = null

  private destroyed$ = new Subject<void>()

  constructor (
    private readonly route: ActivatedRoute,
    private readonly api: ScheduleApiService,
  ) {
  }

  ngOnInit (): void {
    const params = this.route.snapshot.queryParamMap
    const from = params.get('from')! as StationId
    const to = params.get('to')! as StationId
    const departureDateTime = params.get('t')!

    forkJoin([
      this.api.getAllStations(),
      this.api.getSchedule({ from, to, departureDateTime }),
    ]).pipe(
      takeUntil(this.destroyed$),
    ).subscribe(([stations, entries]) => {
      const fromStationName = stations.find(station => station.id == from)?.name ?? 'N/A'
      const toStationName = stations.find(station => station.id == to)?.name ?? 'N/A'
      this.headerInfo = {
        from: fromStationName,
        to: toStationName,
        departureDateTime,
      }
      this.entries = entries
    })
  }

  public ngOnDestroy (): void {
    this.destroyed$.next()
    this.destroyed$.complete()
  }

}
