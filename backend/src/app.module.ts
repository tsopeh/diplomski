import { HttpModule } from '@nestjs/axios'
import { Module } from '@nestjs/common'
import { ServeStaticModule } from '@nestjs/serve-static'
import { join } from 'path'
import { AppController } from './app.controller'
import { AppService } from './app.service'
import { LocationsController } from './location/locations.controller'
import { LocationsService } from './location/locations.service'
import { RidesController } from './ride/rides.controller'
import { RidesService } from './ride/rides.service'
import { UsersController } from './user/users.controller'
import { UsersService } from './user/users.service'

@Module({
  imports: [
    HttpModule,
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public'),
    })],
  controllers: [
    AppController,
    LocationsController,
    UsersController,
    RidesController,
  ],
  providers: [
    AppService,
    LocationsService,
    UsersService,
    RidesService,
  ],
})
export class AppModule {}
