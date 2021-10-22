import { HttpService } from '@nestjs/axios'
import { Controller, Get, NotFoundException, Param, Post, Req, UnauthorizedException } from '@nestjs/common'
import { Request } from 'express'
import { UsersService } from '../user/users.service'
import { Offer, Suggestion } from './ride'
import { RidesService } from './rides.service'

@Controller('rides')
export class RidesController {

  public constructor (
    private readonly http: HttpService,
    private readonly rideService: RidesService,
    private readonly usersService: UsersService,
  ) {}

  @Get('suggestions/:startLocationId/:finishLocationId/:departureDateTime')
  getSuggestions (): Array<Suggestion> {
    return this.rideService.getSuggestions()
  }

  @Get('offer/:id')
  getOffer (@Param('id') id: string, @Req() request: Request): Offer {
    if (this.usersService.isAuthorized(request.headers)) {
      const offer = this.rideService.getOffer(id)
      if (offer != null) {
        return offer
      } else {
        throw new NotFoundException()
      }
    } else {
      throw new UnauthorizedException()
    }
  }

  @Post('offer/:id')
  postOffer (@Param('id') id: string, @Req() request: Request): Offer {
    const userId = this.usersService.headersToAuthenticatedUserId(request.headers)
    if (userId != null) {
      const offer = this.rideService.toggleOffer(id, userId)
      if (offer != null) {
        return offer
      } else {
        throw new NotFoundException()
      }
    } else {
      throw new UnauthorizedException()
    }
  }

}
