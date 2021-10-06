import { Injectable } from '@nestjs/common'
import { Location } from './location'

const MOCK_PLACES: Array<Location> = [
  {
    id: 'Niš',
    name: 'Niš',
  },
  {
    id: 'Beograd',
    name: 'Beograd',
  },
  {
    id: 'Novi Sad',
    name: 'Novi Sad',
  },
  {
    id: 'Velika Plana',
    name: 'Velika Plana',
  },
  {
    id: 'Subotica',
    name: 'Subotica',
  },
  {
    id: 'Kragujevac',
    name: 'Kragujevac',
  },
  {
    id: 'Kruševac',
    name: 'Kruševac',
  },
  {
    id: 'Požareac',
    name: 'Požarevac',
  },
]

@Injectable()
export class LocationsService {

  getAllLocations (): Array<Location> {
    return MOCK_PLACES
  }

  getSingle (id: string): Location | null {
    return this.getAllLocations().find(place => place.id == id) ?? null
  }

}
