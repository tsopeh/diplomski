import { Component, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import { Subject } from 'rxjs'
import { takeUntil } from 'rxjs/operators'
import { ScheduleApiService, ScheduleEntryFull, ScheduleEntryId } from '../api'

@Component({
  selector: 'app-schedule-page',
  templateUrl: './schedule-page.component.html',
  styleUrls: ['./schedule-page.component.scss'],
})
export class SchedulePageComponent implements OnInit, OnDestroy {

  private scheduleId: ScheduleEntryId
  public schedule: ScheduleEntryFull | null = null

  private readonly destroy$ = new Subject<void>()

  public constructor (
    private readonly api: ScheduleApiService,
    private readonly route: ActivatedRoute,
  ) {
    this.scheduleId = route.snapshot.params.id
  }

  public ngOnInit (): void {
    this.api.getFullSchedule(this.scheduleId)
      .pipe(
        takeUntil(this.destroy$),
      )
      .subscribe((scheduleEntry) => {
        this.schedule = scheduleEntry
      })
  }

  public ngOnDestroy (): void {
    this.destroy$.next()
    this.destroy$.complete()
  }

}
