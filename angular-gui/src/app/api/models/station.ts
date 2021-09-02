export type StationId = string & { __STATION_ID__: undefined }

export interface Station {
  name: string
  id: StationId
}