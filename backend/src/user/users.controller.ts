import { HttpService } from '@nestjs/axios'
import { Body, Controller, Get, Param, Post, Req, UnauthorizedException } from '@nestjs/common'
import { Request } from 'express'
import { v4 as uuid } from 'uuid'
import { LoggedInUser, LoginParams, PreviewUser, RegisterParams, SignUpUser, User, userToLoggedInUser } from './user'
import { getDefaultUserAvatarPath, UsersService } from './users.service'

@Controller('user')
export class UsersController {

  public constructor (
    private readonly http: HttpService,
    private readonly usersService: UsersService,
  ) {}

  @Get('me')
  getMyInfo (@Req() request: Request): LoggedInUser {
    const userId = this.usersService.headersToAuthenticatedUserId(request.headers)
    if (userId != null) {
      return userToLoggedInUser(this.usersService.getUserById(userId)!)
    } else {
      throw new UnauthorizedException()
    }
  }

  @Get(':id')
  getPreviewUser (@Param('id') id: string): PreviewUser | null {
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
  login (@Body() body: LoginParams): { token: string } {
    const user = this.usersService.getAllUsers().find(u => u.email == body.email && u.password == body.password)
    if (user == null) {
      throw new UnauthorizedException()
    } else {
      return this.usersService.getToken(user.id)
    }
  }

  @Post('register')
  register (@Body() body: RegisterParams): { token: string } {
    const user: User = {
      ...body,
      id: uuid(),
      avatar: getDefaultUserAvatarPath(),
      passenger: [],
      driver: [],
      accountCreationDate: new Date().toISOString(),
    }
    this.usersService.storeUser(user)
    return this.usersService.getToken(user.id)
  }

}
