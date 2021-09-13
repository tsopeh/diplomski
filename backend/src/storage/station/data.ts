import { Station, StationId } from "./model.ts";

const rawDataString =
  `[{ "name": "KELEBIJA", "id": "04137" }, { "name": "ERDUT", "id": "04232" }, { "name": "DALJ", "id": "04251" }, { "name": "BIJELO BRDO", "id": "04252" }, { "name": "SARVAŠ", "id": "04253" }, { "name": "OSIJEK LUKA", "id": "04254" }, { "name": "OSIJEK DONJI GRAD", "id": "04256" }, { "name": "OSIJEK OLT", "id": "04257" }, { "name": "OSIJEK", "id": "04258" }, { "name": "KISKUNHALAS", "id": "04910" }, { "name": "KISKOROS", "id": "04914" }, { "name": "KUNSZENTMIKLOS TASS", "id": "04920" }, { "name": "BUDAPEST KELETI PU.", "id": "04930" }, { "name": "BUDAPEST FERENCVAROS", "id": "04933" }, { "name": "KUČEVSKA TURIJA", "id": "07114" }, { "name": "LAPOVO RANŽ.STAJ.", "id": "09125" }, { "name": "KALOTINA ZAPAD", "id": "09442" }, { "name": "PESTERZSEBET mh.", "id": "10314" }, { "name": "DOLJEVAC", "id": "11001" }, { "name": "KOCANE", "id": "11002" }, { "name": "PUKOVAC", "id": "11003" }, { "name": "BRESTOVAC", "id": "11004" }, { "name": "LIPOVICA", "id": "11005" }, { "name": "PEČENJEVCE", "id": "11006" }, { "name": "ŽIVKOVO", "id": "11007" }, { "name": "PRIBOJ LESKOVAČKI", "id": "11009" }, { "name": "ĐORĐEVO", "id": "11010" }, { "name": "GRDELICA", "id": "11011" }, { "name": "PALOJSKA ROSULJA", "id": "11012" }, { "name": "PREDEJANE", "id": "11013" }, { "name": "DŽEP", "id": "11014" }, { "name": "MOMIN KAMEN", "id": "11015" }, { "name": "VLADIČIN HAN", "id": "11016" }, { "name": "SUVA MORAVA", "id": "11017" }, { "name": "LEPENIČKI MOST", "id": "11018" }, { "name": "PRIBOJ VRANJSKI", "id": "11019" }, { "name": "VRANJSKA BANJA", "id": "11020" }, { "name": "VRANJE", "id": "11021" }, { "name": "RISTOVAC", "id": "11023" }, { "name": "BUJANOVAC", "id": "11024" }, { "name": "PREŠEVO", "id": "11027" }, { "name": "STUBAL", "id": "11030" }, { "name": "LESKOVAC", "id": "11050" }, { "name": "ŠAJINOVAC", "id": "11101" }, { "name": "JASENICA", "id": "11102" }, { "name": "REČICA", "id": "11104" }, { "name": "PODINA", "id": "11105" }, { "name": "PROKUPLJE", "id": "11106" }, { "name": "LUKOMIR", "id": "11119" }, { "name": "TOPLIČKI BADNJEVAC", "id": "11121" }, { "name": "BABIN POTOK", "id": "11124" }, { "name": "ŽITORADJA CENTAR", "id": "11129" }, { "name": "LEŠAK", "id": "12001" }, { "name": "DREN", "id": "12002" }, { "name": "LEPOSAVIĆ", "id": "12003" }, { "name": "SOČANICA", "id": "12004" }, { "name": "IBARSKA SLATINA", "id": "12005" }, { "name": "BANJSKA", "id": "12006" }, { "name": "VALAČ", "id": "12007" }, { "name": "ZVEČAN", "id": "12008" }, { "name": "PLANDIŠTE", "id": "12019" }, { "name": "PRIDVORICA", "id": "12021" }, { "name": "KOSOVSKA MITROVICA SEVER", "id": "12022" }, { "name": "MATARUŠKA BANJA", "id": "12101" }, { "name": "PROGORELICA", "id": "12102" }, { "name": "BOGUTOVAČKA BANJA", "id": "12103" }, { "name": "POLUMIR", "id": "12105" }, { "name": "UŠĆE", "id": "12106" }, { "name": "JOŠANIČKA BANJA", "id": "12107" }, { "name": "PISKANJA", "id": "12108" }, { "name": "BRVENIK", "id": "12109" }, { "name": "RVATI", "id": "12110" }, { "name": "RAŠKA", "id": "12111" }, { "name": "KAZNOVIĆI", "id": "12112" }, { "name": "RUDNICA", "id": "12113" }, { "name": "JERINA STAJ", "id": "12114" }, { "name": "LOZNO", "id": "12115" }, { "name": "PUSTO POLJE", "id": "12116" }, { "name": "DONJE JARINJE", "id": "12117" }, { "name": "MRZENICA", "id": "12201" }, { "name": "DEDINA", "id": "12203" }, { "name": "KRUŠEVAC", "id": "12204" }, { "name": "KOŠEVI", "id": "12205" }, { "name": "STOPANJA", "id": "12207" }, { "name": "POCEKOVINA", "id": "12208" }, { "name": "TRSTENIK", "id": "12210" }, { "name": "VRNJAČKA BANJA", "id": "12211" }, { "name": "LIPOVA STA", "id": "12212" }, { "name": "PODUNAVCI", "id": "12213" }, { "name": "VRBA STAJ", "id": "12214" }, { "name": "RATINA", "id": "12215" }, { "name": "TOMINAC STA", "id": "12216" }, { "name": "ČITLUK", "id": "12218" }, { "name": "GRAD STALAĆ STA", "id": "12219" }, { "name": "MEĐUROVO", "id": "12301" }, { "name": "BELOTINCE", "id": "12302" }, { "name": "MALOŠIŠTE", "id": "12303" }, { "name": "ČAPLJINAC", "id": "12304" }, { "name": "PALILULSKA RAMPA", "id": "12401" }, { "name": "ĆELE KULA", "id": "12402" }, { "name": "NIŠKA BANJA", "id": "12404" }, { "name": "PROSEK", "id": "12405" }, { "name": "SIĆEVO", "id": "12406" }, { "name": "OSTROVICA", "id": "12407" }, { "name": "RADOV DOL", "id": "12409" }, { "name": "DOLAC", "id": "12410" }, { "name": "CRVENA REKA", "id": "12411" }, { "name": "BELANOVAC", "id": "12412" }, { "name": "BELA PALANKA", "id": "12413" }, { "name": "CRKVICA", "id": "12414" }, { "name": "ĆIFLIK", "id": "12415" }, { "name": "SINJAC", "id": "12416" }, { "name": "ĐURĐEVO POLJE", "id": "12417" }, { "name": "STANIČENJE", "id": "12418" }, { "name": "PIROT", "id": "12420" }, { "name": "BOŽURAT", "id": "12421" }, { "name": "VELIKI JOVANOVAC", "id": "12422" }, { "name": "SUKOVO", "id": "12423" }, { "name": "ČINIGLAVCI", "id": "12424" }, { "name": "SREĆKOVAC", "id": "12425" }, { "name": "CRVENI BREG", "id": "12426" }, { "name": "CRVENČEVO", "id": "12427" }, { "name": "DIMITROVGRAD", "id": "12499" }, { "name": "BRALJINA", "id": "12502" }, { "name": "STARO TRUBAREVO", "id": "12503" }, { "name": "ĐUNIS", "id": "12504" }, { "name": "VITKOVAC STAJ.", "id": "12505" }, { "name": "DONJI LJUBEŠ", "id": "12506" }, { "name": "KORMAN", "id": "12507" }, { "name": "TRNJANI", "id": "12508" }, { "name": "ADROVAC", "id": "12509" }, { "name": "ALEKSINAC", "id": "12510" }, { "name": "LUŽANE", "id": "12511" }, { "name": "TEŠICA", "id": "12512" }, { "name": "GREJAČ", "id": "12513" }, { "name": "SUPOVAČKI MOST", "id": "12514" }, { "name": "MEZGRAJA", "id": "12515" }, { "name": "TRUPALE", "id": "12516" }, { "name": "CEROVO RAŽANJ", "id": "12517" }, { "name": "VRTIŠTE", "id": "12518" }, { "name": "GORNJI LJUBEŠ", "id": "12519" }, { "name": "NOZRINA", "id": "12520" }, { "name": "CRVENI KRST", "id": "12550" }, { "name": "NIŠ", "id": "12551" }, { "name": "ADRANI", "id": "13001" }, { "name": "MRSAĆ", "id": "13002" }, { "name": "SAMAILA", "id": "13003" }, { "name": "GORIČANI", "id": "13004" }, { "name": "MRSINCI", "id": "13005" }, { "name": "ZABLAĆE", "id": "13006" }, { "name": "PRIJEVOR", "id": "13007" }, { "name": "OVČAR BANJA", "id": "13008" }, { "name": "DRAGAČEVO", "id": "13009" }, { "name": "TRBUŠANI", "id": "13010" }, { "name": "BORAČKO", "id": "13011" }, { "name": "BALUGA", "id": "13012" }, { "name": "JELEN DO", "id": "13013" }, { "name": "KUKIĆI", "id": "13014" }, { "name": "GUGALJ STA", "id": "13015" }, { "name": "ČAČAK", "id": "13060" }, { "name": "BATOČINA", "id": "13201" }, { "name": "GRADAC", "id": "13202" }, { "name": "BADNJEVAC", "id": "13203" }, { "name": "RESNIK KRAGUJEVAČKI", "id": "13204" }, { "name": "MILATOVAC", "id": "13205" }, { "name": "JOVANOVAC", "id": "13207" }, { "name": "ZAVOD", "id": "13209" }, { "name": "GROŠNICA", "id": "13210" }, { "name": "DRAGOBRAĆA", "id": "13211" }, { "name": "KNIĆ", "id": "13213" }, { "name": "GRUŽA", "id": "13214" }, { "name": "GUBEREVAC", "id": "13215" }, { "name": "VITKOVAC", "id": "13216" }, { "name": "MILAVČIĆI", "id": "13217" }, { "name": "VITANOVAC", "id": "13218" }, { "name": "ŠUMARICE", "id": "13219" }, { "name": "SIRČA", "id": "13220" }, { "name": "TOMIĆA BRDO", "id": "13221" }, { "name": "KRAGUJEVAC", "id": "13250" }, { "name": "KRALJEVO", "id": "13251" }, { "name": "BRZAN", "id": "13301" }, { "name": "MILOŠEVO", "id": "13302" }, { "name": "BAGRDAN", "id": "13303" }, { "name": "LANIŠTE", "id": "13304" }, { "name": "BUKOVČE", "id": "13305" }, { "name": "GILJE", "id": "13307" }, { "name": "PARAĆIN", "id": "13310" }, { "name": "SIKIRICA-RATARI", "id": "13311" }, { "name": "DRENOVAC", "id": "13312" }, { "name": "ĆIĆEVAC", "id": "13313" }, { "name": "LUČINA", "id": "13314" }, { "name": "JAGODINA", "id": "13350" }, { "name": "ĆUPRIJA", "id": "13351" }, { "name": "STALAĆ", "id": "13352" }, { "name": "VELIKA PLANA", "id": "13401" }, { "name": "STARO SELO", "id": "13402" }, { "name": "NOVO SELO", "id": "13403" }, { "name": "MARKOVAC", "id": "13404" }, { "name": "LAPOVO VAROŠ", "id": "13405" }, { "name": "LAPOVO", "id": "13450" }, { "name": "OSIPAONICA STAJ.", "id": "13501" }, { "name": "SKOBALJ", "id": "13502" }, { "name": "OSIPAONICA", "id": "13503" }, { "name": "LOZOVIK-SARAORCI", "id": "13504" }, { "name": "MILOŠEVAC", "id": "13505" }, { "name": "KRNJEVO-TRNOVČE", "id": "13506" }, { "name": "VELIKO ORAŠJE", "id": "13507" }, { "name": "LUGAVČINA", "id": "13508" }, { "name": "RALJA SMEDEREVSKA", "id": "13509" }, { "name": "SARAORCI", "id": "13510" }, { "name": "MALA KRSNA", "id": "13551" }, { "name": "GODOMIN", "id": "13602" }, { "name": "RADINAC", "id": "13603" }, { "name": "VRANOVO", "id": "13604" }, { "name": "SMEDEREVO", "id": "13670" }, { "name": "KOVAČEVAC", "id": "13701" }, { "name": "RABROVAC", "id": "13702" }, { "name": "KUSADAK", "id": "13703" }, { "name": "RATARE", "id": "13704" }, { "name": "GLIBOVAC", "id": "13705" }, { "name": "PALANKA", "id": "13706" }, { "name": "MALA PLANA", "id": "13707" }, { "name": "MATEJEVAC", "id": "14001" }, { "name": "PANTELEJ", "id": "14003" }, { "name": "JASENOVIK", "id": "14004" }, { "name": "GRAMADA", "id": "14005" }, { "name": "HADŽIĆEVO", "id": "14006" }, { "name": "SVRLJIG", "id": "14007" }, { "name": "NIŠEVAC", "id": "14008" }, { "name": "PALILULA", "id": "14009" }, { "name": "SVRLJIŠKI MILJKOVAC", "id": "14010" }, { "name": "PODVIS", "id": "14011" }, { "name": "RGOŠTE", "id": "14012" }, { "name": "KNJAŽEVAC", "id": "14013" }, { "name": "GORNJE ZUNIĆE", "id": "14014" }, { "name": "DONJE ZUNIĆE", "id": "14015" }, { "name": "MINIĆEVO", "id": "14016" }, { "name": "SELAČKA REKA", "id": "14017" }, { "name": "MALI IZVOR", "id": "14018" }, { "name": "VRATARNICA", "id": "14019" }, { "name": "GRLJAN", "id": "14021" }, { "name": "TIMOK", "id": "14022" }, { "name": "SV MILJKOVAC STAJ", "id": "14024" }, { "name": "ZAJEČAR", "id": "14060" }, { "name": "TRNAVAC", "id": "14101" }, { "name": "ČOKONJAR", "id": "14102" }, { "name": "SOKOLOVICA", "id": "14103" }, { "name": "TABAKOVAC", "id": "14104" }, { "name": "TABAKOVAČKA REKA", "id": "14105" }, { "name": "BRUSNIK", "id": "14106" }, { "name": "TAMNIĆ", "id": "14107" }, { "name": "CRNOMASNICA", "id": "14108" }, { "name": "RAJAC", "id": "14109" }, { "name": "ROGLJEVO", "id": "14110" }, { "name": "VELJKOVO", "id": "14111" }, { "name": "KOBIŠNICA", "id": "14113" }, { "name": "NEGOTIN", "id": "14114" }, { "name": "PRAHOVO", "id": "14115" }, { "name": "PRAHOVO PRISTANIŠTE", "id": "14170" }, { "name": "VRAŽOGRNAC", "id": "14301" }, { "name": "RGOTINA", "id": "14302" }, { "name": "ZAGRAĐE", "id": "14303" }, { "name": "BORSKA SLATINA", "id": "14304" }, { "name": "BOR TERETNA", "id": "14305" }, { "name": "BOR", "id": "14350" }, { "name": "MAJDANPEK", "id": "14401" }, { "name": "LESKOVO", "id": "14402" }, { "name": "JASIKOVO", "id": "14403" }, { "name": "VLAOLE", "id": "14404" }, { "name": "CEROVO", "id": "14405" }, { "name": "KRIVELJSKI POTOK", "id": "14406" }, { "name": "MALI KRIVELJ", "id": "14407" }, { "name": "GORNJANE", "id": "14408" }, { "name": "KRIVELJSKI MOST", "id": "14409" }, { "name": "DEBELI LUG", "id": "14410" }, { "name": "VLAOLE SELO", "id": "14411" }, { "name": "ŠUŠULAJKA", "id": "14412" }, { "name": "BREZONIK", "id": "14413" }, { "name": "SOPOT POŽAREVAČKI", "id": "14502" }, { "name": "STIG", "id": "14505" }, { "name": "MAJILOVAC", "id": "14506" }, { "name": "ČEŠLJEVA BARA", "id": "14509" }, { "name": "RABROVO-KLENJE", "id": "14510" }, { "name": "MUSTAPIĆ", "id": "14511" }, { "name": "ZVIŽD", "id": "14512" }, { "name": "KAONA", "id": "14514" }, { "name": "KUČEVO", "id": "14515" }, { "name": "VOLUJA", "id": "14518" }, { "name": "BRODICA", "id": "14519" }, { "name": "NERESNICA", "id": "14523" }, { "name": "POŽAREVAC", "id": "14550" }, { "name": "LJUBIČEVSKI MOST", "id": "14551" }, { "name": "LASTRA", "id": "15102" }, { "name": "SAMARI", "id": "15103" }, { "name": "DRENOVAČKI KIK", "id": "15104" }, { "name": "RAŽANA", "id": "15105" }, { "name": "KOSJERIĆ", "id": "15106" }, { "name": "KALENIĆ", "id": "15107" }, { "name": "SEVOJNO", "id": "15108" }, { "name": "TUBIĆI", "id": "15109" }, { "name": "UZIĆI", "id": "15110" }, { "name": "RASNA", "id": "15111" }, { "name": "LESKOVICE", "id": "15112" }, { "name": "GLUMAC", "id": "15113" }, { "name": "ZLAKUSA", "id": "15114" }, { "name": "OTANJ", "id": "15116" }, { "name": "RAČA", "id": "15118" }, { "name": "POŽEGA", "id": "15150" }, { "name": "UŽICE TERETNA", "id": "15151" }, { "name": "UŽICE", "id": "15153" }, { "name": "BELA REKA", "id": "15201" }, { "name": "BARAJEVO", "id": "15203" }, { "name": "BARAJEVO CENTAR", "id": "15204" }, { "name": "VELIKI BORAK", "id": "15205" }, { "name": "LESKOVAC KOLUBARSKI", "id": "15206" }, { "name": "STEPOJEVAC", "id": "15207" }, { "name": "LAZAREVAC", "id": "15209" }, { "name": "SLOVAC", "id": "15211" }, { "name": "MLAĐEVO", "id": "15212" }, { "name": "DIVCI", "id": "15213" }, { "name": "IVERAK", "id": "15215" }, { "name": "VREOCI", "id": "15250" }, { "name": "VALJEVO", "id": "15251" }, { "name": "LAJKOVAC", "id": "15260" }, { "name": "RIPANJ", "id": "15402" }, { "name": "KLENJE", "id": "15403" }, { "name": "RALJA", "id": "15405" }, { "name": "SOPOT KOSMAJSKI", "id": "15406" }, { "name": "VLAŠKO POLJE", "id": "15407" }, { "name": "RIPANJ KOLONIJA", "id": "15408" }, { "name": "MLADENOVAC", "id": "15460" }, { "name": "RESNIK", "id": "15501" }, { "name": "BELI POTOK", "id": "15603" }, { "name": "VRČIN", "id": "15605" }, { "name": "KASAPOVAC", "id": "15606" }, { "name": "LIPE", "id": "15607" }, { "name": "MALA IVANČA", "id": "15608" }, { "name": "MALI POŽAREVAC", "id": "15609" }, { "name": "UMČARI", "id": "15611" }, { "name": "KOLARI", "id": "15614" }, { "name": "STAPARI", "id": "15701" }, { "name": "SUŠICA", "id": "15702" }, { "name": "BRANEŠCI", "id": "15703" }, { "name": "ZLATIBOR", "id": "15704" }, { "name": "RIBNICA ZLATIBORSKA", "id": "15705" }, { "name": "JABLANICA", "id": "15706" }, { "name": "ŠTRPCI", "id": "15707" }, { "name": "PRIBOJ", "id": "15708" }, { "name": "PRIBOJSKA BANJA", "id": "15709" }, { "name": "BISTRICA NA LIMU", "id": "15710" }, { "name": "PRIJEPOLJE", "id": "15711" }, { "name": "PRIJEPOLJE TERETNA", "id": "15712" }, { "name": "BRODAREVO", "id": "15714" }, { "name": "VRBNICA", "id": "15715" }, { "name": "RISTANOVIĆA POLJE", "id": "15716" }, { "name": "TRIPKOVA", "id": "15717" }, { "name": "DŽUROVO", "id": "15718" }, { "name": "POLJICE", "id": "15722" }, { "name": "ZEMUNSKO POLJE", "id": "16001" }, { "name": "ZEMUN", "id": "16002" }, { "name": "NOVI BEOGRAD", "id": "16003" }, { "name": "SEBEŠ", "id": "16006" }, { "name": "OVČA", "id": "16007" }, { "name": "TOŠIN BUNAR", "id": "16012" }, { "name": "PANČEVAČKI MOST", "id": "16013" }, { "name": "KRNJAČA", "id": "16015" }, { "name": "KRNJAČA MOST STA", "id": "16016" }, { "name": "BEOGRAD CENTAR", "id": "16052" }, { "name": "KARAĐORĐEV PARK", "id": "16053" }, { "name": "VUKOV SPOMENIK", "id": "16054" }, { "name": "KIJEVO", "id": "16101" }, { "name": "KNEZEVAC", "id": "16102" }, { "name": "RAKOVICA", "id": "16103" }, { "name": "TOPČIDER", "id": "16104" }, { "name": "BATAJNICA", "id": "16204" }, { "name": "BOSZTOR", "id": "16212" }, { "name": "SZABADSZALLAS", "id": "16220" }, { "name": "FULOPSZALLAS", "id": "16238" }, { "name": "SOLTSZENTIMRE mh.", "id": "16246" }, { "name": "CSENGOD", "id": "16253" }, { "name": "SOLTVADKERT", "id": "16287" }, { "name": "PIRTOI SZOLOK mh.", "id": "16295" }, { "name": "ŠTITAR", "id": "16301" }, { "name": "DUBLJE MAČVANSKO", "id": "16302" }, { "name": "PETLOVAČA", "id": "16303" }, { "name": "PIRTO", "id": "16303" }, { "name": "RIBARI STAJ", "id": "16304" }, { "name": "PRNJAVOR MAČVANSKI", "id": "16305" }, { "name": "PODRINJ NOVO SELO", "id": "16306" }, { "name": "LEŠNICA", "id": "16307" }, { "name": "JADARSKA STRAŽA", "id": "16308" }, { "name": "LIPNICA STAJ", "id": "16309" }, { "name": "LOZNICA", "id": "16310" }, { "name": "LOZNICA FABRIKA", "id": "16311" }, { "name": "KOVILJAČA", "id": "16312" }, { "name": "GORNJA KOVILJAČA STAJ", "id": "16313" }, { "name": "BRASINA", "id": "16314" }, { "name": "DONJA BORINA STAJ", "id": "16315" }, { "name": "RADALJ STAJ", "id": "16316" }, { "name": "ZVORNIK", "id": "16317" }, { "name": "BALOTASZALLAS", "id": "16329" }, { "name": "KISSZALLAS", "id": "16337" }, { "name": "TOMPA mh.", "id": "16345" }, { "name": "ŠABAC", "id": "16350" }, { "name": "NOVA PAZOVA", "id": "16501" }, { "name": "STARA PAZOVA", "id": "16503" }, { "name": "GOLUBINCI", "id": "16505" }, { "name": "PUTINCI", "id": "16506" }, { "name": "KRALJEVCI STAJ", "id": "16507" }, { "name": "VOGANJ", "id": "16508" }, { "name": "SREMSKA MITROVICA", "id": "16509" }, { "name": "MARTINCI", "id": "16511" }, { "name": "KUKUJEVCI-ERDEVIK", "id": "16513" }, { "name": "ŠID", "id": "16516" }, { "name": "RUMA", "id": "16550" }, { "name": "BUĐANOVCI", "id": "16601" }, { "name": "NIKINCI", "id": "16602" }, { "name": "PLATIĆEVO", "id": "16603" }, { "name": "KLENAK", "id": "16604" }, { "name": "NOVI SAD", "id": "16808" }, { "name": "PANČEVO VAROŠ", "id": "21001" }, { "name": "BANATSKO NOVO SELO", "id": "21002" }, { "name": "VLADIMIROVAC", "id": "21003" }, { "name": "ALIBUNAR", "id": "21004" }, { "name": "BANATSKI KARLOVAC", "id": "21005" }, { "name": "NIKOLINCI", "id": "21006" }, { "name": "ULJMA", "id": "21007" }, { "name": "VLAJKOVAC", "id": "21008" }, { "name": "VRŠAC", "id": "21009" }, { "name": "PANČEVO GLAVNA", "id": "22001" }, { "name": "ELEMIR", "id": "22503" }, { "name": "MELENCI", "id": "22504" }, { "name": "KUMANE", "id": "22505" }, { "name": "NOVI BEČEJ", "id": "22506" }, { "name": "BANAT.MILOŠEVO POLJE", "id": "22508" }, { "name": "BANATSKO MILOŠEVO", "id": "22509" }, { "name": "ZRENJANIN", "id": "22550" }, { "name": "BOČAR", "id": "22601" }, { "name": "PADEJ", "id": "22603" }, { "name": "OSTOJIĆEVO", "id": "22604" }, { "name": "ČOKA", "id": "22605" }, { "name": "KIKINDA", "id": "22850" }, { "name": "KISAČ", "id": "23302" }, { "name": "STEPANOVIĆEVO", "id": "23303" }, { "name": "ZMAJEVO", "id": "23304" }, { "name": "VRBAS", "id": "23306" }, { "name": "LOVĆENAC", "id": "23401" }, { "name": "MALI IĐOŠ STAJ.", "id": "23402" }, { "name": "MALI IĐOŠ POLJE", "id": "23403" }, { "name": "BAČKA TOPOLA", "id": "23404" }, { "name": "ŽEDNIK", "id": "23407" }, { "name": "ALEKSANDROVO PREDGRAĐE", "id": "23410" }, { "name": "SUBOTICA", "id": "23450" }, { "name": "SENTA", "id": "23801" }, { "name": "GORNJI BREG", "id": "23802" }, { "name": "BOGARAŠ", "id": "23803" }, { "name": "DOLINE", "id": "23804" }, { "name": "OROM", "id": "23805" }, { "name": "GABRIĆ", "id": "23806" }, { "name": "BIKOVO", "id": "23807" }, { "name": "GAJDOBRA", "id": "24001" }, { "name": "FUTOG", "id": "24003" }, { "name": "PETROVAC-GLOŽAN", "id": "24004" }, { "name": "BAČKI MAGLIĆ", "id": "24005" }, { "name": "KULA", "id": "24202" }, { "name": "CRVENKA", "id": "24203" }, { "name": "SIVAC", "id": "24204" }, { "name": "KLJAJIĆEVO", "id": "24206" }, { "name": "ČONOPLJA", "id": "24207" }, { "name": "SVETOZAR MILETIĆ", "id": "24401" }, { "name": "ALEKSA ŠANTIĆ", "id": "24403" }, { "name": "BAJMOK", "id": "24404" }, { "name": "SKENDEROVO", "id": "24405" }, { "name": "TAVANKUT", "id": "24406" }, { "name": "LJUTOVO", "id": "24407" }, { "name": "ŠEBEŠIĆ", "id": "24408" }, { "name": "SUBOTICA PREDGRAĐE", "id": "24409" }, { "name": "PARAGE", "id": "25001" }, { "name": "RATKOVO", "id": "25002" }, { "name": "ODŽACI", "id": "25003" }, { "name": "ODŽACI KALVARIJA", "id": "25401" }, { "name": "KARAVUKOVO", "id": "25402" }, { "name": "BOGOJEVO SELO", "id": "25403" }, { "name": "BOGOJEVO", "id": "25470" }, { "name": "SONTA", "id": "25501" }, { "name": "PRIGREVICA", "id": "25502" }, { "name": "BUKOVAČKI SALAŠI", "id": "25503" }, { "name": "SOMBOR", "id": "25550" }, { "name": "PODGORICA", "id": "31001" }, { "name": "SUTOMORE", "id": "31008" }, { "name": "BAR", "id": "31080" }, { "name": "BIJELO POLJE", "id": "31302" }, { "name": "MOJKOVAC", "id": "31305" }, { "name": "KOLAŠIN", "id": "31307" }, { "name": "TABDI mh.", "id": "44958" }, { "name": "TOVARNIK", "id": "71001" }]`;

const rawDataArray = JSON.parse(rawDataString) as ReadonlyArray<Station>;

export const stationsMockData = rawDataArray.reduce(
  (map, curr) => {
    map.set(curr.id, curr);
    return map;
  },
  new Map<StationId, Station>(),
);