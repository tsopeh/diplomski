import { Oak } from "../../deps.ts";
import { ScheduleApi } from "./api.ts";

const scheduleApi = new ScheduleApi();

const scheduleRouter = new Oak.Router();

scheduleRouter
  .get("/", async (ctx, next) => {
    await next();
    ctx.response.body = await scheduleApi.getAllBrief();
  })
  .get("/full", async (ctx, next) => {
    await next();
    ctx.response.body = await scheduleApi.getAllFull();
  });

export { scheduleRouter };
