import { Station, StationId } from '../stations/station'
import * as DateFns from 'date-fns'

export type ScheduleId = string & { __SCHEDULE_ID__: undefined };

export interface ScheduleFull {
  id: ScheduleId;
  train: {
    id: number; // TODO: TrainId
    trainNumber: string; // TODO: number
    type: 'regional' | 'local';
  };
  latency: number;
  ticketStartingPrice: number;
  stations: Array<Station & {
    arrivalDateTime: string; // Date
    departureDateTime: string; // Date
  }>;
}

export interface ScheduleBrief {
  id: ScheduleId;
  train: {
    id: number; // TODO: TrainId
    trainNumber: string; // TODO: number
    type: 'regional' | 'local';
  };
  latency: number;
  ticketStartingPrice: number;
  departure: Station & { dateTime: string };
  arrival: Station & { dateTime: string };
}

// DATA

const raw = {
  'IDVOZA': 15,
  'KASNI': '',
  'BROJVOZA': '790',
  'DATUMDOLASKA': '',
  'SFZADNJALOK': '',
  'ZADNJALOKACIJA': 0,
  'VREME': '',
  'AKTIVANVOZ': 0,
  'ukvrvoznje': 265,
  'stigo': 0,
  'RANG': '6',
  'PONUDA': 'ABv',
  'stanicavoza': [
    {
      'NAZIV': 'NIŠ',
      'DOLAZAK': '06:40',
      'POLAZAK': '06:40',
      'RBSTANICE': 1,
      'NAZIV1': 'NIŠ',
      'Osenci': 1,
      'Sifra': 12551,
      'vremevoznje': 0,
    },
    {
      'NAZIV': 'ALEKSINAC',
      'DOLAZAK': '07:09',
      'POLAZAK': '07:10',
      'RBSTANICE': 2,
      'NAZIV1': 'ALEKSINAC',
      'Osenci': 1,
      'Sifra': 12510,
      'vremevoznje': 30,
    },
    {
      'NAZIV': 'KORMAN',
      'DOLAZAK': '07:19',
      'POLAZAK': '07:20',
      'RBSTANICE': 3,
      'NAZIV1': 'KORMAN',
      'Osenci': 1,
      'Sifra': 12507,
      'vremevoznje': 10,
    },
    {
      'NAZIV': 'BRALJINA',
      'DOLAZAK': '07:37',
      'POLAZAK': '07:38',
      'RBSTANICE': 4,
      'NAZIV1': 'BRALJINA',
      'Osenci': 1,
      'Sifra': 12502,
      'vremevoznje': 18,
    },
    {
      'NAZIV': 'STALAC',
      'DOLAZAK': '07:55',
      'POLAZAK': '07:56',
      'RBSTANICE': 5,
      'NAZIV1': 'STALAC',
      'Osenci': 1,
      'Sifra': 13352,
      'vremevoznje': 18,
    },
    {
      'NAZIV': 'CICEVAC',
      'DOLAZAK': '08:01',
      'POLAZAK': '08:02',
      'RBSTANICE': 6,
      'NAZIV1': 'CICEVAC',
      'Osenci': 1,
      'Sifra': 13313,
      'vremevoznje': 6,
    },
    {
      'NAZIV': 'PARACIN',
      'DOLAZAK': '08:16',
      'POLAZAK': '08:17',
      'RBSTANICE': 7,
      'NAZIV1': 'PARACIN',
      'Osenci': 1,
      'Sifra': 13310,
      'vremevoznje': 15,
    },
    {
      'NAZIV': 'CUPRIJA',
      'DOLAZAK': '08:23',
      'POLAZAK': '08:24',
      'RBSTANICE': 8,
      'NAZIV1': 'CUPRIJA',
      'Osenci': 1,
      'Sifra': 13351,
      'vremevoznje': 7,
    },
    {
      'NAZIV': 'JAGODINA',
      'DOLAZAK': '08:32',
      'POLAZAK': '08:33',
      'RBSTANICE': 9,
      'NAZIV1': 'JAGODINA',
      'Osenci': 1,
      'Sifra': 13350,
      'vremevoznje': 9,
    },
    {
      'NAZIV': 'LAPOVO',
      'DOLAZAK': '09:05',
      'POLAZAK': '09:07',
      'RBSTANICE': 10,
      'NAZIV1': 'LAPOVO',
      'Osenci': 1,
      'Sifra': 13450,
      'vremevoznje': 34,
    },
    {
      'NAZIV': 'LAPOVO VAROŠ',
      'DOLAZAK': '09:11',
      'POLAZAK': '09:11',
      'RBSTANICE': 11,
      'NAZIV1': 'LAPOVO VAROŠ',
      'Osenci': 1,
      'Sifra': 13405,
      'vremevoznje': 4,
    },
    {
      'NAZIV': 'MARKOVAC',
      'DOLAZAK': '09:17',
      'POLAZAK': '09:18',
      'RBSTANICE': 12,
      'NAZIV1': 'MARKOVAC',
      'Osenci': 1,
      'Sifra': 13404,
      'vremevoznje': 7,
    },
    {
      'NAZIV': 'VELIKA PLANA',
      'DOLAZAK': '09:31',
      'POLAZAK': '09:32',
      'RBSTANICE': 13,
      'NAZIV1': 'VELIKA PLANA',
      'Osenci': 1,
      'Sifra': 13401,
      'vremevoznje': 14,
    },
    {
      'NAZIV': 'PALANKA',
      'DOLAZAK': '09:43',
      'POLAZAK': '09:44',
      'RBSTANICE': 14,
      'NAZIV1': 'PALANKA',
      'Osenci': 0,
      'Sifra': 13706,
      'vremevoznje': 12,
    },
    {
      'NAZIV': 'MLADENOVAC',
      'DOLAZAK': '10:03',
      'POLAZAK': '10:04',
      'RBSTANICE': 15,
      'NAZIV1': 'MLADENOVAC',
      'Osenci': 0,
      'Sifra': 15460,
      'vremevoznje': 20,
    },
    {
      'NAZIV': 'RESNIK',
      'DOLAZAK': '10:51',
      'POLAZAK': '10:52',
      'RBSTANICE': 16,
      'NAZIV1': 'RESNIK',
      'Osenci': 0,
      'Sifra': 15501,
      'vremevoznje': 48,
    },
    {
      'NAZIV': 'RAKOVICA',
      'DOLAZAK': '10:57',
      'POLAZAK': '10:58',
      'RBSTANICE': 17,
      'NAZIV1': 'RAKOVICA',
      'Osenci': 0,
      'Sifra': 16103,
      'vremevoznje': 6,
    },
    {
      'NAZIV': 'BEOGRAD CENTAR',
      'DOLAZAK': '11:05',
      'POLAZAK': '11:05',
      'RBSTANICE': 18,
      'NAZIV1': 'BEOGRAD CENTAR',
      'Osenci': 0,
      'Sifra': 16052,
      'vremevoznje': 7,
    },
  ],
  'tarifskiuslovi': [
    {
      'Opis': 'PRVI RAZRED',
      'Opis_en': 'FIRST CLASS',
      'Cena_Ponude': 0,
      'PONUDA': '/Content/img/PrviRazred.jpg',
      'ID_Ponude_Vozsaob': '/Content/img/InterCity.jpg',
    },
    {
      'Opis': 'DRUGI RAZRED',
      'Opis_en': 'SECOND CLASS',
      'Cena_Ponude': 0,
      'PONUDA': '/Content/img/DrugiRazred.jpg',
      'ID_Ponude_Vozsaob': null,
    },
    {
      'Opis': 'DRUGI RAZRED',
      'Opis_en': 'SECOND CLASS',
      'Cena_Ponude': 0,
      'PONUDA': null,
      'ID_Ponude_Vozsaob': null,
    },
  ],
  'predjenaputanja': null,
  'putanja': '',
  'cena1': '930',
  'cena2': '640',
}

function createScheduleForDate (baseDate: Date = new Date()): ScheduleFull {
  return {
    id: '5100' as ScheduleId,
    train: {
      id: raw.IDVOZA,
      trainNumber: raw.BROJVOZA,
      type: 'regional',
    },
    latency: 1000 * 60 * 45,
    ticketStartingPrice: 800,
    stations: raw.stanicavoza.map((rawStation) => {
      const [arrivalHours, arrivalMinutes] = rawStation.DOLAZAK.split(':').map(
        (x) => parseFloat(x),
      )
      const [departueHours, departureMinutes] = rawStation.POLAZAK.split(':')
        .map(
          (x) => parseFloat(x),
        )
      const station: ScheduleFull['stations'][0] = {
        id: rawStation.Sifra.toString() as StationId,
        name: rawStation.NAZIV,
        arrivalDateTime: DateFns.set(baseDate, {
          hours: arrivalHours,
          minutes: arrivalMinutes,
        })
          .toISOString(),
        departureDateTime: DateFns.set(baseDate, {
          hours: departueHours,
          minutes: departureMinutes,
        })
          .toISOString(),
      }
      return station
    }),
  }
}

export const scheduleFullMockData: ScheduleFull = createScheduleForDate()

export const scheduleBriefMockData: ScheduleBrief = {
  id: scheduleFullMockData.id,
  train: scheduleFullMockData.train,
  latency: scheduleFullMockData.latency,
  ticketStartingPrice: scheduleFullMockData.ticketStartingPrice,
  departure: {
    id: scheduleFullMockData.stations[0].id,
    name: scheduleFullMockData.stations[0].name,
    dateTime: scheduleFullMockData.stations[0].departureDateTime,
  },
  arrival: {
    id: scheduleFullMockData.stations[scheduleFullMockData.stations.length - 1]
      .id,
    name:
    scheduleFullMockData.stations[scheduleFullMockData.stations.length - 1]
      .name,
    dateTime:
    scheduleFullMockData.stations[scheduleFullMockData.stations.length - 1]
      .arrivalDateTime,
  },
}
