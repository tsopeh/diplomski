import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core'
import { FormControl } from '@angular/forms'
import { Station, StationId } from '../../api'

@Component({
  selector: 'station-select',
  templateUrl: './station-select.component.html',
  styleUrls: ['./station-select.component.scss'],
})
export class StationSelectComponent implements OnInit {

  @Input() public stations: ReadonlyArray<Station> = []
  @Input() public control: FormControl | null = null

  @Output() public readonly selectedStationChange = new EventEmitter<StationId>()

  public constructor () {
  }

  public ngOnInit (): void {
  }

  public trackBy (index: number, station: Station): string {
    return station.id
  }

}
