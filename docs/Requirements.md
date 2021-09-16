# Requirements & Notes

## UI

- Mobile first

### Search

- Select **from** station
- Select **to** station
- Select **date and time**. Departure or together with arrival time.
- Show search **schedule** button

### Search results

- General important notices related to the selected route.
- List of available trains. Where each entry must contain:
  - train number
  - departure and arrival time (length) and current latency
  - train type with available classes
  - starting price
  - important notice related to this specific entry
  - ability to pin.

#### Schedule entry

### Pinned

### Recent searches

## Notes

- Development pain points:
  - Form with validation
  - Table to preview data
  - Parsing query parameters
  - Animations

- use guards on result page and redirect to 'root' if params are not complete
- refactor: improve search form types
- posix time vs. iso standard time format

- lepa gradacija vezana za type safety u angular formama i elm-u. Podjemo od js-a, dodnjemo do angulara tj. typescripta ali je resenje previse generalno te je sve tipizirano sa any. Elm tih problema nema jer pere ruke od js-a.
- elm napinje da radi sa datumima
- Prednost pisanja html-a i stilova u elmu je to sto je sve lokalizovano u jednom fajlu/ jeziku. Ukoliko napisem biblioteku za select, nema potrebe da prosledjujem i default css fajl uz nju.
