import { ScheduleBrief, ScheduleFull, ScheduleId } from "./model.ts";
import { scheduleBriefMockData, scheduleFullMockData } from "./data.ts";

export class ScheduleApi {
  public getAllBrief(): Promise<Array<ScheduleBrief>> {
    return new Promise((resolve) => {
      resolve([scheduleBriefMockData]);
    });
  }

  public getAllFull(): Promise<Array<ScheduleFull>> {
    return new Promise((resolve) => {
      resolve([scheduleFullMockData]);
    });
  }
}
