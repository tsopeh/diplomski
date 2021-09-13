import { Oak } from "../../deps.ts";
import { ScheduleApi } from "./api.ts";
import { ScheduleId } from "./model.ts";

const scheduleApi = new ScheduleApi();

const scheduleRouter = new Oak.Router();

scheduleRouter
  .get("/", async (ctx, next) => {
    await next();
    ctx.response.body = await scheduleApi.getAllBrief();
  })
  .get("/:id", async (ctx, next) => {
    await next();
    console.log();
    const scheduleId = ctx.params.id as ScheduleId;
    ctx.response.body = await scheduleApi.getFull(scheduleId);
  });

export { scheduleRouter };
