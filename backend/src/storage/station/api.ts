import { stationsMockData } from "./data.ts";
import { Station, StationId } from "./model.ts";

export class StationsApi {
  async getAll(): Promise<Map<StationId, Station>> {
    return await new Promise((resolve) => {
      resolve(stationsMockData);
    });
  }

  async get(id: StationId): Promise<Station | null> {
    return await new Promise((resolve) => {
      resolve(stationsMockData.get(id) ?? null);
    });
  }
}
