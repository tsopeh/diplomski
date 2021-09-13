import { Oak } from "../../deps.ts";
import { StationsApi } from "./api.ts";
import { StationId } from "./model.ts";

const stationsApi = new StationsApi();

const stationsRouter = new Oak.Router();

stationsRouter
  .get("/", async (ctx, next) => {
    await next();
    const map = await stationsApi.getAll();
    ctx.response.body = Array.from(map.values());
  })
  .get("/:id", async (ctx, next) => {
    await next();
    const id = ctx.params?.id;
    if (id == null) {
      ctx.response.status = 402;
      ctx.response.body = { error: 402, msg: "Missing request param '/:id'." };
    } else {
      const found = await stationsApi.get(id as StationId);
      if (found == null) {
        ctx.response.status = 404;
        ctx.response.body = {
          error: 404,
          msg: `No station found with id = ${id}`,
        };
      } else {
        ctx.response.status = 200;
        ctx.response.body = found;
      }
    }
  });

export { stationsRouter };
