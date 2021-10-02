import { Injectable } from '@nestjs/common'
import { v4 as uuid } from 'uuid'
import { Gender, User } from './user'

const TOKENS: Map<string, string> = new Map<string, string>() // token | userId

const MOCK_USERS: Array<User> = [
  {
    id: 'first user',
    password: 'pass',
    firstName: 'John',
    lastName: 'Doe',
    gender: Gender.Male,
    dateOfBirth: new Date().toISOString(),
    email: 'john@example.com',
    phone: '12345678',
    driver: [],
    passenger: [],
    avatar: 'default-user-avatar',
  },
  {
    id: 'second user',
    password: 'pass',
    firstName: 'Petar',
    lastName: 'Ratep',
    gender: Gender.Male,
    dateOfBirth: new Date().toISOString(),
    email: 'peter@example.com',
    phone: '87654321',
    driver: [],
    passenger: ['first ride'],
    avatar: 'default-user-avatar',
  },
  {
    id: 'third user',
    password: 'pass',
    firstName: 'Jovan',
    lastName: 'Navoj',
    gender: Gender.Male,
    dateOfBirth: new Date().toISOString(),
    email: 'jovan@example.com',
    phone: '87654321',
    driver: ['first ride'],
    passenger: [],
    avatar: 'default-user-avatar',
  },
  {
    id: 'fourth user',
    password: 'pass',
    firstName: 'Marija',
    lastName: 'Ajiram',
    gender: Gender.Male,
    dateOfBirth: new Date().toISOString(),
    email: 'marija@example.com',
    phone: '87654321',
    driver: ['second ride'],
    passenger: [],
    avatar: 'default-user-avatar',
  },
  {
    id: 'fifth user',
    password: 'pass',
    firstName: 'Bodžan',
    lastName: 'Nadžob',
    gender: Gender.Male,
    dateOfBirth: new Date().toISOString(),
    email: 'bodžan@example.com',
    phone: '87654321',
    driver: [],
    passenger: ['first ride'],
    avatar: 'default-user-avatar',
  },
]

@Injectable()
export class UsersService {

  public getAllUsers (): Array<User> {
    return MOCK_USERS
  }

  public getToken (userId: string): { token: string } {
    const token = uuid()
    TOKENS.set(token, userId)
    return { token: token }
  }

  public storeUser (newUser: User): void {
    MOCK_USERS.push(newUser)
  }

  public getUserById (id: string): User | null {
    return this.getAllUsers().find(u => u.id == id) ?? null
  }

}

