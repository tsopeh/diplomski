// @ts-ignore TODO: define custom `.d.ts` file
import { Elm } from './app/Main.elm'
import './styles/index.scss'

// region intl-date

// Reference https://ellie-app.com/8yYbRQ3Hzrta1

function localizeDate (lang: string | null, year: string | null, month: string | null, day: string | null) {
  const dateTimeFormat = new Intl.DateTimeFormat(lang ?? 'eng-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
  // @ts-ignore
  return dateTimeFormat.format(new Date(year, month, day))
}

customElements.define('intl-date',
  class extends HTMLElement {
    // things required by Custom Elements
    constructor () { super() }

    connectedCallback () { this.setTextContent() }

    attributeChangedCallback () { this.setTextContent() }

    static get observedAttributes () { return ['lang', 'year', 'month', 'day'] }

    // Our function to set the textContent based on attributes.
    setTextContent () {
      const lang = this.getAttribute('lang') ?? null
      const year = this.getAttribute('year') ?? null
      const month = this.getAttribute('month') ?? null
      const day = this.getAttribute('day') ?? null

      this.textContent = localizeDate(lang, year, month, day)
    }
  },
)

// endregion intl-date

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

app.ports.persistToken.subscribe((token: string | null) => {
  console.log('persistToken', token)
  if (token == null) {
    localStorage.removeItem(TOKEN_KEY)
  } else {
    localStorage.setItem(TOKEN_KEY, token)
  }
  setTimeout(() => {
    sendTokenToElm()
  }, 0)
})

window.addEventListener('storage', function (event) {
  if (event.storageArea == localStorage && event.key == TOKEN_KEY) {
    sendTokenToElm()
  }
})

function readToken (): string | null {
  return localStorage.getItem(TOKEN_KEY) ?? null
}

const sendTokenToElm = () => {
  app.ports.tokenChanged.send(readToken())
}

function readLanguage (): string | null {
  return localStorage.getItem(LANGUAGE_KEY) ?? null
}

function sendLanguageToElm () {
  app.ports.languageChanged.send(readLanguage())
}
