import { Controller, Get, Param } from '@nestjs/common'
import { StationId } from '../stations/station'
import { ScheduleBrief, scheduleBriefMockData, ScheduleFull, scheduleFullMockData, ScheduleId } from './schedule'

@Controller('schedules')
export class SchedulesController {
  @Get('brief/:depId/:arrId/:depDateTimeString')
  getBrief (@Param() params: { depId: StationId, arrId: StationId, depDateTimeString: string }): Array<ScheduleBrief> {
    return Array.from({ length: 5 }).map(_ => scheduleBriefMockData)
  }

  @Get('full/:id')
  getSingleFull (@Param('id') id: ScheduleId): ScheduleFull {
    return scheduleFullMockData
  }
}
