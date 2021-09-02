# Requirements & Notes

## UI

- Mobile first

### Search

- Select **from** station
- Select **to** station
- Select **date and time**. Departure or togethoer with arrival time.
- Show search **schedule** button

### Search results

#### Brief

- General important notices related to the selected route.
- List of available trains. Where each entry must contain:
  - train number
  - is it direct  
  - departure and arrival time (length) and current latency
  - train type with available classes
  - starting price
  - important notice related to this specific entry
  - ability to pin.

#### Full

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
