import { HttpService } from '@nestjs/axios'
import { Controller, Get, Param } from '@nestjs/common'
import { Offer, Suggestion } from './ride'
import { RidesService } from './rides.service'

@Controller('rides')
export class RidesController {

  public constructor (
    private readonly http: HttpService,
    private readonly rideService: RidesService,
  ) {}

  @Get('offer/:id')
  offerRide (@Param('id') id: string): Offer | null {
    return this.rideService.getOffer(id)
  }

  @Get('suggestions/:startLocationId/:finishLocationId/:departureDateTime')
  getSuggestions (): Array<Suggestion> {
    return this.rideService.getSuggestions()
  }

}
