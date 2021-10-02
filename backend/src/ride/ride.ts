export interface Vehicle {
  name: string
  description: string
  avatar: string
}

export interface Ride {
  id: string
  driver: string
  vehicle: Vehicle
  numberOfSeats: number
  passengers: Array<string>
  departureDate: string
  arrivalDate: string
  startLocation: string
  finishLocation: string
  price: number
  smokingAllowed: boolean
  petsAllowed: boolean
  childrenAllowed: boolean
}

export interface Suggestion {
  id: string
  startLocationName: string
  finishLocationName: string
  /**
   * Iso string
   */
  departureDate: string
  /**
   * Iso string
   */
  arrivalDate: string
  /**
   * Formatted for the view
   */
  duration: string
  driverName: string
  driverAvatar: string
  vehicle: Vehicle
  price: string
  numberOfSeats: number
  numberOfFreeSeats: number
  smokingAllowed: boolean
  petsAllowed: boolean
  childrenAllowed: boolean
}

export interface Offer {
  id: string
  startLocationName: string
  finishLocationName: string
  departureDate: string
  arrivalDate: string
  duration: string
  price: string // formatted, ready for view
  driver: {
    id: string
    firstName: string
    lastName: string
    avatar: string
    phone: string
  }
  vehicle: Vehicle
  numberOfSeats: number
  passengers: Array<Passenger>
  smokingAllowed: boolean
  petsAllowed: boolean
  childrenAllowed: boolean
}

export interface Passenger {
  id: string
  firstName: string
  avatar: string
}