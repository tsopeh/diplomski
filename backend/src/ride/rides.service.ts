import { Injectable } from '@nestjs/common'
import * as DateFns from 'date-fns'
import { LocationsService } from '../location/locations.service'
import { UsersService } from '../user/users.service'
import { Offer, Passenger, Ride, Suggestion } from './ride'

const MOCK_DEPARTURE_DATE = DateFns.addDays(new Date(), 1)

const MOCK_RIDES: Array<Ride> = [
  {
    id: 'first ride',
    driver: 'third user',
    vehicle: {
      name: 'Yugo',
      description: 'Red',
      avatar: getDefaultCarAvatar(),
    },
    numberOfSeats: 2,
    passengers: ['fifth user', 'second user'],
    departureDate: MOCK_DEPARTURE_DATE.toISOString(),
    arrivalDate: DateFns.addHours(MOCK_DEPARTURE_DATE, 3).toISOString(),
    startLocation: 'Niš',
    finishLocation: 'Beograd',
    price: 600,
    smokingAllowed: false,
    petsAllowed: false,
    childrenAllowed: true,
  },
  {
    id: 'second ride',
    driver: 'fourth user',
    vehicle: {
      name: 'Fiat',
      description: 'Red',
      avatar: getDefaultCarAvatar(),
    },
    numberOfSeats: 3,
    passengers: [],
    departureDate: MOCK_DEPARTURE_DATE.toISOString(),
    arrivalDate: DateFns.addHours(MOCK_DEPARTURE_DATE, 2).toISOString(),
    startLocation: 'Beograd',
    finishLocation: 'Novi Sad',
    price: 500,
    smokingAllowed: false,
    petsAllowed: true,
    childrenAllowed: false,
  },
]

@Injectable()
export class RidesService {

  public constructor (
    private readonly usersService: UsersService,
    private readonly locationsService: LocationsService,
  ) {}

  getRides (): Array<Ride> {
    return MOCK_RIDES
  }

  getRide (id: string): Ride | null {
    return this.getRides().find(r => r.id == id) ?? null
  }

  public getSuggestions (): Array<Suggestion> {
    const rides = this.getRides()
    return rides.map((ride): Suggestion => {

      const { firstName: driverName, avatar: driverAvatar } = this.usersService.getUserById(ride.driver)!
      return {
        id: ride.id,
        startLocationName: this.locationsService.getSingle(ride.startLocation)?.name ?? 'N/A',
        finishLocationName: this.locationsService.getSingle(ride.finishLocation)?.name ?? 'N/A',
        departureDate: ride.departureDate,
        arrivalDate: ride.arrivalDate,
        duration: getDuration(new Date(ride.departureDate), new Date(ride.arrivalDate)),
        driverName: driverName,
        driverAvatar: driverAvatar,
        vehicle: ride.vehicle,
        price: priceInRsd(ride.price),
        numberOfSeats: ride.numberOfSeats,
        numberOfFreeSeats: ride.numberOfSeats - ride.passengers.length,
        smokingAllowed: ride.smokingAllowed,
        petsAllowed: ride.petsAllowed,
        childrenAllowed: ride.childrenAllowed,
      }
    })
  }

  public getOffer (id: string): Offer | null {
    const ride = this.getRide(id)
    if (ride == null) return null
    const driver = this.usersService.getUserById(ride.driver)!
    const passengers = ride.passengers.map((passengerId): Passenger => {
      const user = this.usersService.getUserById(passengerId)!
      return {
        id: user.id,
        firstName: user.firstName,
        avatar: user.avatar,
      }
    })
    return {
      id: ride.id,
      startLocationName: this.locationsService.getSingle(ride.startLocation)?.name ?? 'N/A',
      finishLocationName: this.locationsService.getSingle(ride.finishLocation)?.name ?? 'N/A',
      departureDate: ride.departureDate,
      arrivalDate: ride.arrivalDate,
      duration: getDuration(new Date(ride.departureDate), new Date(ride.arrivalDate)),
      driver: {
        id: driver.id,
        firstName: driver.firstName,
        lastName: driver.lastName,
        avatar: driver.avatar,
        phone: driver.phone,
      },
      vehicle: ride.vehicle,
      numberOfSeats: ride.numberOfSeats,
      passengers: passengers,
      price: priceInRsd(ride.price),
      smokingAllowed: ride.smokingAllowed,
      petsAllowed: ride.petsAllowed,
      childrenAllowed: ride.childrenAllowed,
    }
  }
}

function getDuration (startDate: Date, endDate: Date): string {
  const duration = DateFns.intervalToDuration({
    start: new Date(startDate),
    end: new Date(endDate),
  })
  return `${(duration.hours ?? 0) < 10 ? '0' : ''}${duration.hours ?? 0}:${(duration.minutes ?? 0) < 10 ? '0' : ''}${duration.minutes ?? 0}`
}

function priceInRsd (price: number): string {
  return `din. ${price},00`
}

function getDefaultCarAvatar (): string {
  return 'avatars/car-128.png'
}