export type TrainId = string & { __TRAIN_ID__: undefined }

export enum TrainType {
  Local = 'Local',
  Regional = 'Regional',
}

export interface Train {
  id: TrainId
  trainNumber: number
  type: TrainType
}