import { Component, OnInit } from '@angular/core'
import { FormBuilder, Validators } from '@angular/forms'
import { ActivatedRoute, Router } from '@angular/router'
import { Subject } from 'rxjs'
import { takeUntil } from 'rxjs/operators'
import { ScheduleApiService, Station, StationId } from '../api'
import { createStorageKey, LocalStorageService } from '../local-storage.service'

export interface SearchStorageModel {
  from: StationId | null
  to: StationId | null
  departureDateTime: string | null
}

const SEARCH_MODEL_STORAGE_KEY =
  createStorageKey('SEARCH_MODEL_STORAGE_KEY')

const validateModel =
  (raw: SearchStorageModel | undefined): raw is SearchStorageModel => {
    return raw !== undefined
      && raw.to !== undefined
      && raw.from !== undefined
      && raw.departureDateTime !== undefined
  }

@Component({
  selector: 'schedule-page',
  templateUrl: './search-page.component.html',
  styleUrls: ['./search-page.component.scss'],
})
export class SearchPageComponent implements OnInit {

  public allStations: ReadonlyArray<Station> = []

  public searchForm = this.fb.group({
    from: [null, Validators.required],
    to: [null, Validators.required],
    departureDateTime: [null, Validators.required], // TODO: Validate future only
  })

  private readonly destroyed$ = new Subject<void>()

  public constructor (
    private readonly fb: FormBuilder,
    private readonly storage: LocalStorageService<SearchStorageModel>,
    private readonly api: ScheduleApiService,
    private readonly router: Router,
    private readonly route: ActivatedRoute,
  ) {
  }

  public ngOnInit (): void {
    this.api.getAllStations().then((stations) => {
      this.allStations = stations
      const { from, to, departureDateTime } = this.storage.get(
        SEARCH_MODEL_STORAGE_KEY,
        validateModel,
        () => ({
          from: null,
          to: null,
          departureDateTime: null,
        }),
      )

      this.searchForm.setValue({ from, to, departureDateTime })

      // Subscribe to changes after setting initial form value.
      this.searchForm.valueChanges
        .pipe(
          takeUntil(this.destroyed$),
        )
        .subscribe(({ from, to, departureDateTime }) => {
          this.storage.set(SEARCH_MODEL_STORAGE_KEY, {
            from,
            to,
            departureDateTime,
          })
        })

    })
  }

  public onSubmit (event: Event): void {
    const { to, from, departureDateTime } = this.searchForm.value
    this.router.navigate(['search'], {
      relativeTo: this.route.parent,
      queryParams: {
        from: from,
        to: to,
        t: departureDateTime,
      },
    })
  }

}
