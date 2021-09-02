import { Component, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import { ScheduleApiService, ScheduleEntryBrief } from '../api'

@Component({
  selector: 'app-result-page',
  templateUrl: './result-page.component.html',
  styleUrls: ['./result-page.component.scss'],
})
export class ResultPageComponent implements OnInit {

  public entries: ReadonlyArray<ScheduleEntryBrief> | null = null

  constructor (
    private readonly route: ActivatedRoute,
    private readonly api: ScheduleApiService,
  ) {
  }

  ngOnInit (): void {
    const params = this.route.snapshot.queryParamMap
    const from = params.get('from')!
    const to = params.get('to')!
    const departureDateTime = params.get('t')!
    this.api.getSchedule({ from, to, departureDateTime })
      .then((entries) => {

      })
  }

}
