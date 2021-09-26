import { Module } from '@nestjs/common'
import { AppController } from './app.controller'
import { AppService } from './app.service'
import { StationsController } from './stations/stations.controller'
import { SchedulesController } from './schedules/schedules.controller'

@Module({
  imports: [],
  controllers: [AppController, StationsController, SchedulesController],
  providers: [AppService],
})
export class AppModule {}
