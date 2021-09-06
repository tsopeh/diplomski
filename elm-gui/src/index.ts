// @ts-ignore TODO: define custom `.d.ts` file
import {Elm} from './Main.elm'
import './styles.scss'

const TOKEN_KEY = 'TOKEN_KEY'

const readStorage = () => {
    return localStorage.getItem(TOKEN_KEY) ?? null
}

const app = Elm.Main.init({flags: readStorage()})

const onTokenChange = () => {
    app.ports.tokenChanged.send(readStorage());
}

app.ports.persistToken.subscribe((token: string | null) => {
    if (token == null) {
        localStorage.removeItem(TOKEN_KEY)
    } else {
        localStorage.setItem(TOKEN_KEY, token)
    }
    setTimeout(() => {
        onTokenChange()
    }, 0)
});

window.addEventListener("storage", function (event) {
    if (event.storageArea == localStorage && event.key == TOKEN_KEY) {
        onTokenChange();
    }
});
