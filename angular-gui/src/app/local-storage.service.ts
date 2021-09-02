import { Injectable } from '@angular/core'

type StorageKey = string & { __STORAGE_KEY__: undefined }

export const createStorageKey = (key: string) => key as StorageKey

@Injectable({ providedIn: 'root' })
export class LocalStorageService<TValue extends object> {

  set (key: StorageKey, value: TValue): void {
    let raw: string | undefined = undefined
    try {
      raw = JSON.stringify(value)
    } catch (err) {
      console.error(err)
    }
    if (raw != null) {
      window.localStorage.setItem(key, raw)
    }
  }

  get (
    key: StorageKey,
    validate: (raw: TValue | undefined) => raw is TValue,
    fallback: () => TValue,
  ): TValue {
    const rawString = window.localStorage.getItem(key)
    if (rawString == null) {
      return fallback()
    }
    let raw: TValue | undefined = undefined
    try {
      raw = JSON.parse(rawString)
    } catch (err) {
      console.error(err)
    }
    if (validate(raw)) {
      return raw
    }
    return fallback()
  }

}
