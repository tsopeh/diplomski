export const repeat = <TValue = unknown> (x: TValue, count: number): Array<TValue> => {
  if (count < 1) throw new Error(`The parameter "count" must be a non-zero positive integer.`)
  return Array.from({ length: count }).map(_ => x)
}