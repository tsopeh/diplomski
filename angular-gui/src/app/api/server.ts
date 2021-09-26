const protocol: string = 'http'
const hostname: string = window.location.hostname
const port: number = 8080

export function createGetUrl(...params: ReadonlyArray<string>): string {
  const url = new URL(`${protocol}://${hostname}:${port}`)
  url.pathname = params.join('/')
  return url.toString()
}
