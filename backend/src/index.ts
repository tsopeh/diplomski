import { Oak } from "./deps.ts";
import { Stations, Schedule } from "./storage/index.ts";

const rootRouter = new Oak.Router()
  .get("/", (ctx) => {
    ctx.response.body = "Backend is up and running!";
  })
  .use(
    "/stations",
    Stations.stationsRouter.routes(),
    Stations.stationsRouter.allowedMethods(),
  )
  .use(
    "/schedule",
    Schedule.scheduleRouter.routes(),
    Schedule.scheduleRouter.allowedMethods(),
  );

const app = new Oak.Application();
app.use((ctx, next) => {
  ctx.response.headers.set("Access-Control-Allow-Origin", "*");
  return next();
});
app.use(rootRouter.routes());
app.use(rootRouter.allowedMethods());

const hostname = "0.0.0.0";
const port = 8080;
console.log(`[${new Date()}]`);
console.log(`App is listening on ${hostname}:${port}`);
await app.listen({ hostname, port });
