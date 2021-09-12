import { Oak } from "./deps.ts";
import { Stations } from "./storage/index.ts";

const stationsApi = new Stations.Api();

const stationsRouter = new Oak.Router();

stationsRouter
  .get("/", async (ctx, next) => {
    await next();
    ctx.response.body = await stationsApi.getAll();
  })
  .get("/:id", async (ctx, next) => {
    await next();
    const id = ctx.params?.id;
    ctx.response.body = id != null ? await stationsApi.get(id) : null;
  });

const rootRouter = new Oak.Router()
  .get("/", (ctx) => {
    ctx.response.body = "Backend is up and running!";
  })
  .use("/stations", stationsRouter.routes(), stationsRouter.allowedMethods());

const app = new Oak.Application();
app.use((ctx, next) => {
  ctx.response.headers.set('Access-Control-Allow-Origin', '*')
  return next()
})
app.use(rootRouter.routes());
app.use(rootRouter.allowedMethods());

const hostname = "0.0.0.0";
const port = 8080;
console.log(`[${new Date()}]`);
console.log(`App is listening on ${hostname}:${port}`);
await app.listen({ hostname, port });

// Run this command in your terminal: `deno run --watch --allow-net ./src/index.ts`
