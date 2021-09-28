import { HttpService } from '@nestjs/axios'
import { Controller, Get, Param } from '@nestjs/common'
import { Location } from './location'
import { LocationsService } from './locations.service'

@Controller('locations')
export class LocationsController {

  public constructor (
    private readonly http: HttpService,
    private readonly locationsService: LocationsService,
  ) {}

  @Get()
  getAll (): Array<Location> {
    return this.locationsService.getAllLocations()
  }

  @Get(':id')
  getSingle (@Param('id') id: string): Location | null {
    return this.locationsService.getSingle(id)
  }

}
