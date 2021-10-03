import { HttpService } from '@nestjs/axios'
import { Controller, Get, Param, Post } from '@nestjs/common'
import { v4 as uuid } from 'uuid'
import { LoginParams, PreviewUser, SignUpUser, User } from './user'
import { getDefaultUserAvatarPath, UsersService } from './users.service'

@Controller('user')
export class UsersController {

  public constructor (
    private readonly http: HttpService,
    private readonly usersService: UsersService,
  ) {}

  @Get(':id')
  offerRide (@Param('id') id: string): PreviewUser | null {
    return this.usersService.getPreviewUser(id)
  }

  @Post('signup')
  signUp (x: SignUpUser): string {
    // TODO: validation: unique email, pass length 4, has everything, 18+
    const id = uuid()
    const user: User = {
      id: id,
      password: x.password,
      firstName: x.firstName,
      lastName: x.lastName,
      gender: x.gender,
      dateOfBirth: x.dateOfBirth,
      email: x.email,
      phone: x.phone,
      driver: [],
      passenger: [],
      avatar: getDefaultUserAvatarPath(),
      accountCreationDate: new Date().toISOString(),
    }
    this.usersService.storeUser(user)
    return 'success'
  }

  @Post('login')
  login (x: LoginParams): { token: string } {
    // TODO: validation
    const userId = 'first user'
    return this.usersService.getToken(userId)
  }

}
