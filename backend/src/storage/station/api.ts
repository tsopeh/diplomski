import { data } from "./data.ts";
import { Model } from "./model.ts";

export class Api {
  async getAll(): Promise<ReadonlyArray<Model>> {
    return await new Promise((resolve) => {
      resolve(data);
    });
  }

  async get(id: string): Promise<Model | null> {
    return await new Promise((resolve) => {
      resolve(data.find((model) => model.id == id) ?? null);
    });
  }
}
