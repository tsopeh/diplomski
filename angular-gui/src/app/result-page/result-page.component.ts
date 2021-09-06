import { Component, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import { ScheduleApiService, ScheduleEntryBrief, StationId } from '../api'
import { SearchModel } from '../search-page/search-page.component'

@Component({
  selector: 'app-result-page',
  templateUrl: './result-page.component.html',
  styleUrls: ['./result-page.component.scss'],
})
export class ResultPageComponent implements OnInit {

  public headerInfo!: SearchModel
  public entries: ReadonlyArray<ScheduleEntryBrief> | null = null

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

    this.api.getSchedule({ from, to, departureDateTime })
      .then((entries) => {
        this.entries = entries
      })

    this.headerInfo = { from, to, departureDateTime }
  }

}
