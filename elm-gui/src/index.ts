// @ts-ignore TODO: define custom `.d.ts` file
import { Elm } from './app/Main.elm'
import './styles/index.scss'

const LANGUAGE_KEY = 'LANGUAGE_KEY'
const TOKEN_KEY = 'TOKEN_KEY'
const SEARCH_FORM_KEY = 'SEARCH_FORM_KEY'

let flags: {
  token: string | null
  language: string | null
}

try {
  flags = {
    token: readToken(),
    language: readLanguage(),
  }
} catch (err) {
  flags = { token: null, language: null }
}

const app = Elm.Main.init({ flags: flags })

app.ports.persistLanguage.subscribe((language: string) => {
  try {
    localStorage.setItem(LANGUAGE_KEY, language)
  } catch (err) {
    console.error(`Could not persist the language.`)
    return
  }
  sendLanguageToElm()
})

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

function readToken (): string | null {
  return localStorage.getItem(TOKEN_KEY) ?? null
}

function readLanguage (): string | null {
  return localStorage.getItem(LANGUAGE_KEY) ?? null
}

function sendLanguageToElm () {
  app.ports.languageChanged.send(readLanguage())
}
