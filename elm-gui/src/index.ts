// @ts-ignore TODO: define custom `.d.ts` file
import { Elm } from './Main.elm'
import './styles.scss'

const TOKEN_KEY = 'TOKEN_KEY'
const SEARCH_FORM_KEY = 'SEARCH_FORM_KEY'

let flags

try {
  flags = {
    token: localStorage.getItem(TOKEN_KEY),
    searchForm: JSON.parse(localStorage.getItem(SEARCH_FORM_KEY) ?? 'null'),
  }
} catch (err) {
  flags = {}
}

const app = Elm.Main.init({ flags })

app.ports.persistSearchForm.subscribe((formModel: any) => {
  try {
    localStorage.setItem(SEARCH_FORM_KEY, JSON.stringify(formModel))
  } catch (err) {
    console.error(`Could not serialize the form model.`)
  }
})

app.ports.requestSearchFormFromStorage.subscribe(() => {
  let formModel = null
  try {
    formModel = JSON.parse(localStorage.getItem(SEARCH_FORM_KEY)!)
  } catch (err) {
    console.error(`Could not de-serialize the form model.`)
  }
  app.ports.receiveSearchFormFromStorage.send(formModel)
})

// const onTokenChange = () => {
//   app.ports.tokenChanged.send(readStorage())
// }
//
// app.ports.persistToken.subscribe((token: string | null) => {
//   if (token == null) {
//     localStorage.removeItem(TOKEN_KEY)
//   } else {
//     localStorage.setItem(TOKEN_KEY, token)
//   }
//   setTimeout(() => {
//     onTokenChange()
//   }, 0)
// })
//
// window.addEventListener('storage', function (event) {
//   if (event.storageArea == localStorage && event.key == TOKEN_KEY) {
//     onTokenChange()
//   }
// })
