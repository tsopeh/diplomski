import { Controller, Get, Param } from '@nestjs/common'
import { Station, StationId, stationsMockData } from './station'

@Controller('stations')
export class StationsController {
  @Get()
  getAll (): Array<Station> {
    return Array.from(stationsMockData.values())
  }

  @Get(':id')
  getSingle (@Param('id') id: StationId): Station | null {
    return stationsMockData.get(id) ?? null
  }
}
