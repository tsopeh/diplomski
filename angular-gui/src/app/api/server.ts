const protocol: string = 'http'
const hostname: string = 'localhost'
const port: number = 8080

export function createUrl (pathname: string): string {
  const url = new URL(`${protocol}://${hostname}:${port}`)
  url.pathname = pathname
  console.log(url.toString())
  return url.toString()
}