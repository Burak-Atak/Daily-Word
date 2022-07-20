import 'package:ntp/ntp.dart';

void main() async {
  DateTime now = await NTP.now();
  print(now);
}

List<String> trainingWords = [
  'abaza',
  'abide',
  'abiye',
  'abone',
  'acaba',
  'acele',
  'acemi',
  'acılı',
  'acıma',
  'açgöz',
  'açlık',
  'açmak',
  'açmaz',
  'adale',
  'adana',
  'adeta',
  'adres',
  'adsız',
  'afaki',
  'afgan',
  'afyon',
  'agora',
  'ağlak',
  'ağmak',
  'ahali',
  'ahbap',
  'ahenk',
  'ahize',
  'ahkam',
  'ahlak',
  'ahlat',
  'ahmak',
  'ahşap',
  'ahval',
  'aidat',
  'ajans',
  'akaju',
  'akbaş',
  'akçıl',
  'akıcı',
  'akide',
  'akkor',
  'akkuş',
  'aklen',
  'aklık',
  'akmak',
  'akman',
  'akmaz',
  'akort',
  'akran',
  'akrep',
  'aksak',
  'aksam',
  'aksan',
  'akşam',
  'aktar',
  'aktaş',
  'aktif',
  'aktör',
  'alaca',
  'alaka',
  'alarm',
  'albay',
  'albüm',
  'alçak',
  'aleni',
  'alevi',
  'aleyh',
  'alıcı',
  'alize',
  'alkan',
  'alkış',
  'alkol',
  'allah',
  'allem',
  'allık',
  'almaç',
  'almak',
  'alman',
  'altın',
  'amade',
  'ambar',
  'amber',
  'amele',
  'amigo',
  'amper',
  'ampir',
  'ampul',
  'analı',
  'ancak',
  'andaç',
  'andıç',
  'anemi',
  'angut',
  'anime',
  'anket',
  'anlam',
  'anlık',
  'anmak',
  'anons',
  'anten',
  'antik',
  'antre',
  'anzak',
  'aplik',
  'aptal',
  'araba',
  'aracı',
  'aralı',
  'arama',
  'arazi',
  'ardıç',
  'arena',
  'argon',
  'arıcı',
  'arıza',
  'arife',
  'armut',
  'aroma',
  'arsız',
  'arşın',
  'arşiv',
  'artçı',
  'artık',
  'artış',
  'artma',
  'asabi',
  'ashap',
  'asılı',
  'asist',
  'asker',
  'aslan',
  'aslen',
  'asmak',
  'astar',
  'astım',
  'aşağı',
  'aşama',
  'aşevi',
  'aşıcı',
  'aşılı',
  'aşırı',
  'aşina',
  'aşkın',
  'aşlık',
  'aşmak',
  'aşure',
  'atama',
  'atari',
  'ataşe',
  'atıcı',
  'atlas',
  'atlet',
  'atmak',
  'avans',
  'avare',
  'avize',
  'avrat',
  'aydın',
  'aygır',
  'aygıt',
  'ayırt',
  'aylak',
  'aylık',
  'aynen',
  'ayraç',
  'ayran',
  'ayrık',
  'ayrım',
  'ayrıt',
  'ayvaz',
  'ayyaş',
  'azami',
  'azeri',
  'azgın',
  'azılı',
  'azize',
  'azlık',
  'azmak',
  'azman',
  'bacak',
  'badem',
  'bagaj',
  'baget',
  'bağcı',
  'bağır',
  'bağış',
  'bağlı',
  'bahar',
  'bahçe',
  'bahis',
  'bahri',
  'bakan',
  'bakım',
  'bakır',
  'bakış',
  'bakir',
  'bakla',
  'bakma',
  'balat',
  'baldo',
  'balet',
  'balık',
  'ballı',
  'balon',
  'balta',
  'balya',
  'bambu',
  'bamya',
  'banal',
  'bando',
  'banka',
  'banko',
  'banma',
  'banyo',
  'baraj',
  'baran',
  'baret',
  'barış',
  'bariz',
  'barok',
  'baron',
  'barut',
  'basak',
  'basen',
  'basık',
  'basım',
  'basın',
  'basış',
  'basit',
  'baskı',
  'basma',
  'basur',
  'başak',
  'başka',
  'başlı',
  'başta',
  'batak',
  'batar',
  'batık',
  'batıl',
  'batış',
  'batik',
  'batma',
  'bavul',
  'bayan',
  'bayat',
  'bayır',
  'bayma',
  'bazen',
  'bazik',
  'bebek',
  'bedel',
  'beden',
  'bedir',
  'bedük',
  'begüm',
  'beher',
  'bekar',
  'bekçi',
  'belde',
  'beleş',
  'belge',
  'belki',
  'belli',
  'bence',
  'benci',
  'bende',
  'benek',
  'bengi',
  'beniz',
  'benli',
  'berat',
  'beril',
  'besin',
  'beste',
  'beşer',
  'beşik',
  'beşiz',
  'beşli',
  'beter',
  'betim',
  'beton',
  'beyan',
  'beyaz',
  'beyin',
  'beyit',
  'bezci',
  'bezgi',
  'bezme',
  'bıçak',
  'bıçık',
  'bıçkı',
  'bıdık',
  'bıkma',
  'bıyık',
  'biber',
  'biblo',
  'biçem',
  'biçim',
  'biçki',
  'biçme',
  'bidon',
  'bilek',
  'bilet',
  'bilge',
  'bilgi',
  'bilim',
  'bilir',
  'biliş',
  'bilme',
  'bilye',
  'bindi',
  'binek',
  'biner',
  'biniş',
  'binme',
  'biraz',
  'birer',
  'birey',
  'birim',
  'birli',
  'birun',
  'bitap',
  'bitek',
  'bitik',
  'bitiş',
  'bitki',
  'bitli',
  'bizon',
  'bloke',
  'bobin',
  'bodur',
  'boğaz',
  'boğma',
  'boğuk',
  'boğum',
  'bohça',
  'bohem',
  'boklu',
  'bolca',
  'bomba',
  'bombe',
  'boran',
  'bordo',
  'borsa',
  'boyar',
  'boyca',
  'boylu',
  'boyna',
  'boyoz',
  'boyun',
  'boyut',
  'bozca',
  'bozma',
  'bozuk',
  'böbür',
  'böcek',
  'böğür',
  'bölen',
  'bölge',
  'bölme',
  'bölük',
  'bölüm',
  'bölüş',
  'börek',
  'böyle',
  'branş',
  'bravo',
  'bronş',
  'bronz',
  'bucak',
  'buçuk',
  'budak',
  'bugün',
  'buğra',
  'buhar',
  'buket',
  'bukle',
  'bulgu',
  'bulma',
  'buluş',
  'bulut',
  'bunak',
  'bunca',
  'bunma',
  'burak',
  'burcu',
  'burgu',
  'burma',
  'bursa',
  'buruk',
  'burun',
  'butik',
  'buton',
  'buzcu',
  'buzlu',
  'buzul',
  'bücür',
  'büken',
  'bükme',
  'bükük',
  'büküm',
  'bünye',
  'bütçe',
  'bütün',
  'büyük',
  'büzgü',
  'büzme',
  'cacık',
  'cadde',
  'cahil',
  'camız',
  'camia',
  'camlı',
  'camsı',
  'canan',
  'canlı',
  'casus',
  'cayma',
  'cazcı',
  'cazip',
  'cebir',
  'ceket',
  'celal',
  'celbe',
  'celil',
  'celse',
  'cemal',
  'cemil',
  'cemre',
  'cenap',
  'cenin',
  'cepçi',
  'cephe',
  'ceren',
  'ceset',
  'cesur',
  'cevap',
  'ceviz',
  'cezai',
  'cezbe',
  'cezir',
  'cezve',
  'cıbıl',
  'cılız',
  'cıvık',
  'cıvma',
  'cibre',
  'cicim',
  'cidar',
  'ciddi',
  'ciğer',
  'cihan',
  'cihat',
  'cilve',
  'cimri',
  'cinas',
  'cinci',
  'cinli',
  'cinsi',
  'cirit',
  'cisim',
  'civan',
  'civar',
  'cizye',
  'conta',
  'coşku',
  'coşma',
  'cukka',
  'cumba',
  'cunda',
  'cunta',
  'cübbe',
  'cücük',
  'cülus',
  'cümle',
  'cünüp',
  'cüret',
  'cürüm',
  'cüsse',
  'çabuk',
  'çadır',
  'çağla',
  'çağrı',
  'çakal',
  'çakıl',
  'çakır',
  'çakış',
  'çakma',
  'çakra',
  'çalar',
  'çalgı',
  'çalım',
  'çalış',
  'çalma',
  'çamur',
  'çanak',
  'çanta',
  'çapak',
  'çaplı',
  'çapul',
  'çaput',
  'çarık',
  'çarpı',
  'çarşı',
  'çatal',
  'çatık',
  'çatış',
  'çatma',
  'çavuş',
  'çaycı',
  'çayır',
  'çehre',
  'çekçe',
  'çeker',
  'çekiç',
  'çekik',
  'çekim',
  'çekiş',
  'çekme',
  'çelen',
  'çelik',
  'çello',
  'çelme',
  'çemen',
  'çeper',
  'çerez',
  'çeşit',
  'çeşme',
  'çeşni',
  'çetin',
  'çevik',
  'çevre',
  'çeyiz',
  'çıban',
  'çığır',
  'çıkar',
  'çıkık',
  'çıkın',
  'çıkış',
  'çıkma',
  'çıktı',
  'çınar',
  'çırak',
  'çırpı',
  'çıyan',
  'çiçek',
  'çifte',
  'çiğde',
  'çiğil',
  'çiğit',
  'çilek',
  'çilli',
  'çimen',
  'çimme',
  'çince',
  'çinko',
  'çinli',
  'çipil',
  'çiriş',
  'çiroz',
  'çitme',
  'çivit',
  'çizer',
  'çizge',
  'çizgi',
  'çizik',
  'çizim',
  'çizme',
  'çoban',
  'çocuk',
  'çoğul',
  'çokça',
  'çoklu',
  'çolak',
  'çomak',
  'çomar',
  'çorak',
  'çorap',
  'çorba',
  'çorlu',
  'çorum',
  'çökük',
  'çöküş',
  'çömez',
  'çöpçü',
  'çörek',
  'çözüm',
  'çözüş',
  'çubuk',
  'çukur',
  'çupra',
  'çuval',
  'çünkü',
  'çürük',
  'dadaş',
  'dağcı',
  'dahil',
  'daima',
  'daimi',
  'daire',
  'dakik',
  'dalak',
  'dalga',
  'dalış',
  'dallı',
  'dalma',
  'damak',
  'damar',
  'damat',
  'damga',
  'damla',
  'danış',
  'darbe',
  'davar',
  'davet',
  'davul',
  'dayak',
  'defin',
  'defne',
  'değer',
  'değin',
  'değme',
  'deist',
  'deizm',
  'dekan',
  'dekor',
  'delik',
  'delil',
  'delme',
  'delta',
  'demeç',
  'demet',
  'demin',
  'demir',
  'demli',
  'denek',
  'deney',
  'denge',
  'denim',
  'deniz',
  'denli',
  'denyo',
  'depar',
  'derbi',
  'dergi',
  'derin',
  'derme',
  'derun',
  'derya',
  'desen',
  'deste',
  'detay',
  'devam',
  'devim',
  'devir',
  'devre',
  'deyim',
  'deyiş',
  'dışkı',
  'dibek',
  'diğer',
  'dikeç',
  'diken',
  'dikey',
  'dikim',
  'dikiş',
  'dikit',
  'dikiz',
  'dikme',
  'dikte',
  'dilci',
  'dilek',
  'dilim',
  'dilli',
  'dinar',
  'dince',
  'dinci',
  'dingi',
  'dingo',
  'dinme',
  'direk',
  'diren',
  'disko',
  'dişçi',
  'dişil',
  'dişli',
  'ditme',
  'divan',
  'diyar',
  'diyet',
  'diyez',
  'diyot',
  'dizel',
  'dizge',
  'dizgi',
  'dizim',
  'dizin',
  'dobra',
  'dogma',
  'doğal',
  'doğan',
  'doğru',
  'doğum',
  'doğuş',
  'dokuz',
  'dolap',
  'dolar',
  'dolay',
  'dolgu',
  'dolma',
  'dolum',
  'doluş',
  'domuz',
  'donma',
  'donör',
  'donuk',
  'doruk',
  'dosya',
  'doyma',
  'doyum',
  'doyuş',
  'dozaj',
  'dozer',
  'dökme',
  'dökük',
  'döküm',
  'dönek',
  'dönel',
  'dönem',
  'döner',
  'döngü',
  'dönük',
  'dönüm',
  'dönüş',
  'dönüt',
  'döşek',
  'döviz',
  'dövme',
  'dövüş',
  'draje',
  'drama',
  'duacı',
  'duble',
  'dudak',
  'duman',
  'dumur',
  'durak',
  'durgu',
  'durma',
  'durum',
  'duruş',
  'duvak',
  'duvar',
  'duyar',
  'duygu',
  'duyma',
  'duyum',
  'duyuş',
  'dübel',
  'dübeş',
  'düden',
  'düdük',
  'düğme',
  'düğüm',
  'düğün',
  'dümen',
  'dünkü',
  'dünür',
  'dünya',
  'dürme',
  'dürtü',
  'dürüm',
  'dürzü',
  'düşçü',
  'düşes',
  'düşeş',
  'düşey',
  'düşkü',
  'düşme',
  'düşük',
  'düşün',
  'düşüş',
  'düvel',
  'düven',
  'düzce',
  'düzeç',
  'düzem',
  'düzen',
  'düzey',
  'ebedi',
  'ecdat',
  'edalı',
  'edebi',
  'efekt',
  'efkar',
  'eflak',
  'efsun',
  'egale',
  'eglog',
  'egzoz',
  'eğmek',
  'eğrim',
  'ehram',
  'ejder',
  'ekici',
  'ekili',
  'eklem',
  'ekler',
  'ekmek',
  'ekose',
  'ekran',
  'eksen',
  'eksik',
  'eksin',
  'eksiz',
  'eküri',
  'elbet',
  'elçim',
  'elden',
  'eleme',
  'elgin',
  'elips',
  'elmas',
  'elmek',
  'elvan',
  'elyaf',
  'elzem',
  'emare',
  'emaye',
  'emici',
  'emlak',
  'emmek',
  'emsal',
  'emzik',
  'enayi',
  'endam',
  'ender',
  'enfes',
  'engel',
  'engin',
  'enkaz',
  'enlem',
  'enöte',
  'ensar',
  'ensiz',
  'entel',
  'enzim',
  'epeyi',
  'epope',
  'erbaa',
  'erbap',
  'erbaş',
  'erdem',
  'ergen',
  'ergin',
  'erime',
  'erkan',
  'erkek',
  'erken',
  'erlik',
  'ermek',
  'ermiş',
  'eroin',
  'erzak',
  'esame',
  'esans',
  'esasi',
  'eskiz',
  'esmek',
  'esmer',
  'esnaf',
  'esnek',
  'espri',
  'esrar',
  'esrik',
  'essah',
  'esvap',
  'eşarp',
  'eşkal',
  'eşlik',
  'eşmek',
  'eşraf',
  'eşref',
  'eşsiz',
  'etçil',
  'etken',
  'etkin',
  'etmek',
  'etmen',
  'etnik',
  'etraf',
  'etsel',
  'etsiz',
  'evcil',
  'evgin',
  'evham',
  'eviye',
  'evlat',
  'evrak',
  'evren',
  'evrim',
  'evsiz',
  'evvel',
  'eylem',
  'eylül',
  'eyvah',
  'ezber',
  'ezeli',
  'ezici',
  'ezmek',
  'facia',
  'fahiş',
  'fahri',
  'fakat',
  'fakir',
  'falan',
  'falcı',
  'falez',
  'falso',
  'fanta',
  'fanus',
  'faraş',
  'fasıl',
  'faslı',
  'fatih',
  'fayda',
  'fazıl',
  'fazla',
  'fedai',
  'fehim',
  'felah',
  'felek',
  'fenci',
  'fener',
  'ferah',
  'ferdi',
  'fesat',
  'fesih',
  'fetih',
  'fetiş',
  'fetüs',
  'fetva',
  'fevri',
  'feyiz',
  'fıkıh',
  'fıkra',
  'fırça',
  'fırın',
  'fırka',
  'fıtık',
  'fiber',
  'fidan',
  'fidye',
  'figan',
  'figür',
  'fiili',
  'fikir',
  'filan',
  'filiz',
  'final',
  'fince',
  'firar',
  'firma',
  'fiske',
  'fisto',
  'fişek',
  'fitil',
  'fitne',
  'fitre',
  'fiyat',
  'fizik',
  'flama',
  'flora',
  'flört',
  'fokus',
  'folyo',
  'forma',
  'forum',
  'fosil',
  'frank',
  'frenk',
  'fresk',
  'fuhuş',
  'fular',
  'fulya',
  'funda',
  'furya',
  'fünye',
  'gafil',
  'galip',
  'galon',
  'galoş',
  'gamet',
  'gamlı',
  'gamze',
  'garaj',
  'garip',
  'gavur',
  'gayda',
  'gayet',
  'gayrı',
  'gayri',
  'gazal',
  'gazap',
  'gazel',
  'gazlı',
  'gazoz',
  'geçer',
  'geçim',
  'geçiş',
  'geçit',
  'geçme',
  'gedik',
  'gelen',
  'gelin',
  'gelir',
  'geliş',
  'gelme',
  'genel',
  'geniş',
  'geniz',
  'genom',
  'geoit',
  'gerçi',
  'gereç',
  'gerek',
  'gergi',
  'germe',
  'getto',
  'geviş',
  'geyik',
  'geyşa',
  'gezme',
  'gıcık',
  'gıcır',
  'gıdık',
  'gıdım',
  'gıpta',
  'gırla',
  'gider',
  'gidiş',
  'gidon',
  'giray',
  'girdi',
  'giren',
  'giriş',
  'girme',
  'gitar',
  'gitme',
  'giyim',
  'giyiş',
  'giyme',
  'giysi',
  'gizem',
  'gizli',
  'glase',
  'gonca',
  'goril',
  'gotik',
  'göbek',
  'göçer',
  'göçük',
  'göğüs',
  'gökçe',
  'gölet',
  'gölge',
  'gömme',
  'gömük',
  'gömüt',
  'gönül',
  'gönye',
  'görev',
  'görgü',
  'görme',
  'görüş',
  'gövde',
  'gözcü',
  'gözde',
  'guatr',
  'guguk',
  'gurme',
  'gurur',
  'gusül',
  'gübre',
  'güçlü',
  'güdük',
  'güdüm',
  'güleç',
  'gülle',
  'güllü',
  'gülme',
  'gümüş',
  'günah',
  'günce',
  'günde',
  'güneş',
  'güney',
  'güpür',
  'güreş',
  'güruh',
  'güveç',
  'güven',
  'güzel',
  'haber',
  'habeş',
  'habip',
  'habis',
  'hacet',
  'hacim',
  'haciz',
  'hadım',
  'hadis',
  'hafız',
  'hafif',
  'hafta',
  'hakan',
  'hakem',
  'hakim',
  'hakir',
  'haklı',
  'halat',
  'halay',
  'halen',
  'halis',
  'halka',
  'hamak',
  'hamal',
  'hamam',
  'hamil',
  'hamle',
  'hamsi',
  'hamur',
  'hancı',
  'hande',
  'hanek',
  'hangi',
  'hanım',
  'hapis',
  'hapşu',
  'haraç',
  'haram',
  'harap',
  'harbi',
  'harem',
  'hariç',
  'hasar',
  'hasat',
  'haset',
  'hasım',
  'hasır',
  'haspa',
  'hasta',
  'haşat',
  'haşin',
  'hatay',
  'hatır',
  'hatip',
  'hatta',
  'hatun',
  'havai',
  'havan',
  'havuç',
  'havuz',
  'havva',
  'havza',
  'hayal',
  'hayat',
  'haybe',
  'hayda',
  'haydi',
  'hayıf',
  'hayır',
  'hazan',
  'hazar',
  'hazcı',
  'hazım',
  'hazır',
  'hazin',
  'hazne',
  'hedef',
  'hekim',
  'helak',
  'helal',
  'helva',
  'hemen',
  'henüz',
  'hepsi',
  'herif',
  'hesap',
  'heybe',
  'heyet',
  'hırbo',
  'hırka',
  'hırlı',
  'hısım',
  'hışım',
  'hışır',
  'hıyar',
  'hızır',
  'hızlı',
  'hızma',
  'hicap',
  'hiciv',
  'hilal',
  'hindi',
  'hindu',
  'hippi',
  'hisar',
  'hisse',
  'hitap',
  'hitit',
  'hodri',
  'hokey',
  'hokka',
  'horon',
  'horoz',
  'hoşaf',
  'hoşça',
  'hödük',
  'höyük',
  'hudut',
  'hukuk',
  'hulus',
  'hurda',
  'hurma',
  'hurra',
  'husus',
  'hutbe',
  'huylu',
  'huzur',
  'hücre',
  'hücum',
  'hüküm',
  'hülya',
  'hüner',
  'hüzme',
  'hüzün',
  'ibare',
  'iblis',
  'ibraz',
  'ibret',
  'ibrik',
  'icmal',
  'içeri',
  'içlik',
  'içmek',
  'içsel',
  'içten',
  'içyüz',
  'idame',
  'idare',
  'idari',
  'iddia',
  'ideal',
  'idman',
  'idrak',
  'idrar',
  'ifade',
  'iffet',
  'iflah',
  'iflas',
  'ifrit',
  'iftar',
  'ihale',
  'ihbar',
  'ihlal',
  'ihlas',
  'ihmal',
  'ihsan',
  'ihtar',
  'ikame',
  'ikbal',
  'ikici',
  'ikili',
  'iklim',
  'ikmal',
  'ikona',
  'ikram',
  'iksir',
  'ilahi',
  'ilave',
  'ileri',
  'ileti',
  'ilgeç',
  'ilham',
  'ilkel',
  'illet',
  'ilmek',
  'imalı',
  'imame',
  'imbat',
  'imdat',
  'imkan',
  'imleç',
  'imren',
  'imsak',
  'inanç',
  'incik',
  'incil',
  'incir',
  'infaz',
  'inkar',
  'inmek',
  'insaf',
  'insan',
  'iplik',
  'ipsiz',
  'iptal',
  'ipucu',
  'irade',
  'irfan',
  'irice',
  'irite',
  'irmik',
  'ironi',
  'isale',
  'ishal',
  'iskan',
  'iskoç',
  'islam',
  'ispat',
  'israf',
  'istek',
  'istif',
  'isyan',
  'işgal',
  'işkal',
  'işlek',
  'işlem',
  'işlev',
  'işsiz',
  'iştah',
  'işteş',
  'itaat',
  'ithaf',
  'ithal',
  'itham',
  'itici',
  'itina',
  'ivedi',
  'iyice',
  'izlek',
  'izlem',
  'izmir',
  'izmit',
  'iznik',
  'izole',
  'izzet',
  'iğdır',
  'ılgım',
  'ılıca',
  'ılıma',
  'ırgat',
  'ırkçı',
  'ırmak',
  'ıslah',
  'ıslak',
  'ıslık',
  'ısrar',
  'ıssız',
  'ışıma',
  'jakar',
  'japon',
  'jarse',
  'jeton',
  'jilet',
  'joker',
  'jokey',
  'jüpon',
  'kabak',
  'kaban',
  'kabız',
  'kabin',
  'kabir',
  'kablo',
  'kabuk',
  'kabus',
  'kabza',
  'kaçak',
  'kaçar',
  'kaçık',
  'kaçış',
  'kadar',
  'kadeh',
  'kader',
  'kadın',
  'kadim',
  'kadir',
  'kadro',
  'kafes',
  'kafir',
  'kağan',
  'kağıt',
  'kağnı',
  'kahır',
  'kahin',
  'kahpe',
  'kahve',
  'kahya',
  'kaide',
  'kakao',
  'kakma',
  'kakül',
  'kalan',
  'kalas',
  'kalay',
  'kalça',
  'kalem',
  'kalfa',
  'kalın',
  'kalıp',
  'kalış',
  'kalıt',
  'kalma',
  'kamçı',
  'kamış',
  'kamil',
  'kanal',
  'kanat',
  'kanca',
  'kanık',
  'kanıt',
  'kaniş',
  'kanka',
  'kanlı',
  'kanma',
  'kanun',
  'kapak',
  'kapan',
  'kapış',
  'kapiş',
  'kaplı',
  'kaput',
  'kapuz',
  'karar',
  'karga',
  'kargı',
  'kargo',
  'karın',
  'karış',
  'karlı',
  'karma',
  'karne',
  'karşı',
  'kasap',
  'kaset',
  'kasık',
  'kasım',
  'kasıt',
  'kasis',
  'kasko',
  'kaslı',
  'kasma',
  'kasti',
  'kaşar',
  'kaşık',
  'kaşif',
  'katar',
  'katık',
  'katır',
  'katil',
  'katip',
  'katkı',
  'katlı',
  'katma',
  'kavak',
  'kaval',
  'kavga',
  'kavim',
  'kavis',
  'kavuk',
  'kavun',
  'kayaç',
  'kayak',
  'kayan',
  'kaygı',
  'kayık',
  'kayın',
  'kayıp',
  'kayış',
  'kayıt',
  'kayme',
  'kazak',
  'kazan',
  'kazaz',
  'kazık',
  'kazma',
  'kebap',
  'keder',
  'kefal',
  'kefen',
  'kefil',
  'kefir',
  'kekik',
  'kelam',
  'kelek',
  'keleş',
  'kelle',
  'kemal',
  'keman',
  'kemer',
  'kemik',
  'kenar',
  'kendi',
  'kenef',
  'kenet',
  'kepçe',
  'kepek',
  'kerem',
  'kerim',
  'keriz',
  'kesat',
  'keser',
  'kesif',
  'kesik',
  'kesim',
  'kesin',
  'kesir',
  'kesiş',
  'kesit',
  'kesme',
  'keşif',
  'keşiş',
  'keşke',
  'keten',
  'ketum',
  'keyfi',
  'keyif',
  'kıble',
  'kıdem',
  'kılıç',
  'kılıf',
  'kılık',
  'kılış',
  'kıllı',
  'kımıl',
  'kınık',
  'kıran',
  'kırık',
  'kırma',
  'kısas',
  'kısık',
  'kısır',
  'kısıt',
  'kısmi',
  'kıssa',
  'kışın',
  'kışla',
  'kıtır',
  'kıvam',
  'kıyak',
  'kıyam',
  'kıyas',
  'kıyım',
  'kıyma',
  'kızak',
  'kızan',
  'kızıl',
  'kızış',
  'kızma',
  'kibar',
  'kibir',
  'kiler',
  'kilim',
  'kilis',
  'kilit',
  'killi',
  'kimse',
  'kimya',
  'kinci',
  'kinli',
  'kiraz',
  'kireç',
  'kiril',
  'kiriş',
  'kirli',
  'kirpi',
  'kirve',
  'kitap',
  'kitle',
  'klima',
  'klips',
  'klişe',
  'koala',
  'kobay',
  'kobra',
  'koçak',
  'koçan',
  'kodes',
  'koful',
  'koğuş',
  'kokma',
  'kokoş',
  'kokoz',
  'kolaj',
  'kolay',
  'kolej',
  'kollu',
  'kolye',
  'kombi',
  'komik',
  'komşu',
  'komut',
  'konak',
  'konik',
  'konma',
  'konuk',
  'konum',
  'konur',
  'konuş',
  'konut',
  'konya',
  'kopça',
  'kopma',
  'kopuk',
  'kopuz',
  'kopya',
  'korku',
  'korna',
  'korse',
  'koruk',
  'koşma',
  'koşuk',
  'koşul',
  'koşum',
  'kovan',
  'koyun',
  'köçek',
  'köfte',
  'köhne',
  'köken',
  'köklü',
  'kömbe',
  'kömür',
  'köpek',
  'köprü',
  'köpük',
  'körpe',
  'kösem',
  'kötek',
  'köylü',
  'kramp',
  'kredi',
  'krema',
  'kriko',
  'kroki',
  'kroşe',
  'kubbe',
  'kucak',
  'kuduz',
  'kukla',
  'kulaç',
  'kulak',
  'kulis',
  'kulüp',
  'kumar',
  'kumaş',
  'kumlu',
  'kumru',
  'kumul',
  'kupon',
  'kupür',
  'kurak',
  'kural',
  'kuram',
  'kurgu',
  'kurma',
  'kurul',
  'kurum',
  'kuruş',
  'kurye',
  'kusma',
  'kusur',
  'kuşak',
  'kuşçu',
  'kuşku',
  'kutlu',
  'kutup',
  'kuvöz',
  'kuytu',
  'kuzen',
  'kuzey',
  'kuzin',
  'kübik',
  'küçük',
  'küflü',
  'küfür',
  'külah',
  'külçe',
  'küllü',
  'külot',
  'kümes',
  'künye',
  'kürek',
  'kürsü',
  'küsme',
  'küspe',
  'kütle',
  'kütük',
  'küvet',
  'laçka',
  'lades',
  'ladin',
  'lagos',
  'lagün',
  'lağım',
  'lahit',
  'lakap',
  'lakin',
  'lamba',
  'lanet',
  'lanse',
  'larva',
  'latif',
  'latin',
  'lavaş',
  'lavuk',
  'layık',
  'lazca',
  'lazer',
  'lazım',
  'legal',
  'leğen',
  'lehçe',
  'lehim',
  'levha',
  'levye',
  'leydi',
  'leziz',
  'lıkır',
  'lider',
  'lifli',
  'likit',
  'likör',
  'liman',
  'limit',
  'limon',
  'lirik',
  'lisan',
  'liste',
  'litre',
  'lobut',
  'lodos',
  'lokal',
  'lokma',
  'lokum',
  'lonca',
  'lotus',
  'lüfer',
  'lügat',
  'lütuf',
  'mabat',
  'mabet',
  'macar',
  'macun',
  'madam',
  'madde',
  'maddi',
  'madem',
  'maden',
  'mafya',
  'magma',
  'mahal',
  'mahir',
  'mahur',
  'majör',
  'makam',
  'makas',
  'makat',
  'maket',
  'makro',
  'maksi',
  'makul',
  'malak',
  'malul',
  'malum',
  'mamul',
  'mamur',
  'mamut',
  'manas',
  'manav',
  'manda',
  'manga',
  'mango',
  'mantı',
  'manto',
  'mapus',
  'maral',
  'maraz',
  'marka',
  'marki',
  'martı',
  'marul',
  'maruz',
  'masaj',
  'masal',
  'maske',
  'masör',
  'masöz',
  'masum',
  'matah',
  'matem',
  'matiz',
  'maval',
  'maviş',
  'mayın',
  'mayıs',
  'mazot',
  'mazur',
  'mebus',
  'mecal',
  'mecaz',
  'mecra',
  'medet',
  'medya',
  'meğer',
  'mehdi',
  'mekik',
  'melek',
  'melez',
  'melul',
  'memur',
  'merak',
  'meret',
  'meriç',
  'mermi',
  'mesai',
  'mesaj',
  'mesih',
  'mesul',
  'meşru',
  'metal',
  'metin',
  'metre',
  'metro',
  'mevki',
  'mevzi',
  'mevzu',
  'meyil',
  'meyve',
  'mezar',
  'mezun',
  'mısır',
  'mısra',
  'midye',
  'mikro',
  'milat',
  'milim',
  'milli',
  'mimar',
  'mimik',
  'mimli',
  'minik',
  'minör',
  'miraç',
  'miras',
  'misal',
  'mitoz',
  'miyom',
  'miyop',
  'mizaç',
  'mizah',
  'mobil',
  'model',
  'modem',
  'modül',
  'moğol',
  'moloz',
  'monte',
  'moral',
  'moruk',
  'motel',
  'motif',
  'motor',
  'motto',
  'mösyö',
  'mucit',
  'muğla',
  'muhit',
  'mukus',
  'mumlu',
  'mumya',
  'murat',
  'muska',
  'muson',
  'muşta',
  'mutlu',
  'muzip',
  'mübah',
  'müdür',
  'müftü',
  'mühim',
  'mühür',
  'müjde',
  'mürit',
  'müzik',
  'nabız',
  'naçar',
  'nadas',
  'nadir',
  'nağme',
  'nahif',
  'nakış',
  'nakil',
  'nakit',
  'nalan',
  'namaz',
  'namlu',
  'namus',
  'nanay',
  'narin',
  'nasıl',
  'nasır',
  'nasip',
  'nazar',
  'nazım',
  'nazır',
  'nazik',
  'nazlı',
  'neden',
  'nefer',
  'nefes',
  'nefis',
  'nefti',
  'nehir',
  'nemli',
  'nesil',
  'nesim',
  'nesir',
  'nesne',
  'neşet',
  'nezih',
  'nezir',
  'nezle',
  'nicel',
  'nifak',
  'nihai',
  'nihan',
  'nikah',
  'nikel',
  'nimet',
  'ninni',
  'nisan',
  'nişan',
  'nitel',
  'niyet',
  'nizam',
  'nodül',
  'nohut',
  'nokta',
  'noter',
  'nöbet',
  'nöron',
  'nutuk',
  'nüans',
  'nüfus',
  'nüfuz',
  'nükte',
  'nüsha',
  'obruk',
  'ofans',
  'oğlak',
  'oğlan',
  'oksit',
  'oktav',
  'okuma',
  'olası',
  'olgun',
  'omlet',
  'oniks',
  'onluk',
  'opera',
  'optik',
  'orlon',
  'orman',
  'ortak',
  'ortam',
  'otacı',
  'otçul',
  'otizm',
  'otlak',
  'ovmak',
  'oyalı',
  'oymak',
  'oynak',
  'ozmoz',
  'öbürü',
  'ödeme',
  'ödlek',
  'ödünç',
  'öğlen',
  'öksüz',
  'ölçek',
  'ölçer',
  'ölçme',
  'ölçüm',
  'ölçüt',
  'ölmek',
  'öncül',
  'önder',
  'öneri',
  'önlem',
  'önlük',
  'öpmek',
  'ördek',
  'örgün',
  'örgüt',
  'örmek',
  'örnek',
  'öteki',
  'ötürü',
  'övmek',
  'övünç',
  'özden',
  'özdeş',
  'özenç',
  'özerk',
  'özgül',
  'özgün',
  'özgür',
  'özlem',
  'özlük',
  'öznel',
  'pabuç',
  'paçoz',
  'pagan',
  'paket',
  'palet',
  'palto',
  'pampa',
  'pamuk',
  'panda',
  'panel',
  'panik',
  'papaz',
  'papel',
  'paraf',
  'parça',
  'parka',
  'parke',
  'parsa',
  'parti',
  'pasaj',
  'pasak',
  'pasif',
  'paslı',
  'pasör',
  'pasta',
  'patak',
  'paten',
  'patik',
  'payda',
  'payet',
  'pazar',
  'pedal',
  'peder',
  'pekçe',
  'pelin',
  'pelte',
  'pelüş',
  'pembe',
  'pençe',
  'pense',
  'penye',
  'perde',
  'perma',
  'peron',
  'peruk',
  'perva',
  'peşin',
  'petek',
  'pıhtı',
  'pınar',
  'pırtı',
  'pigme',
  'pikap',
  'pilav',
  'piliç',
  'pilli',
  'pilot',
  'pinti',
  'pipet',
  'pişti',
  'piton',
  'piyaz',
  'piyes',
  'piyon',
  'pizza',
  'plaka',
  'plase',
  'plato',
  'plaza',
  'poker',
  'polar',
  'polat',
  'polen',
  'polim',
  'pomak',
  'pompa',
  'ponza',
  'popçu',
  'posta',
  'poşet',
  'prens',
  'prese',
  'proje',
  'prova',
  'pudra',
  'pullu',
  'punto',
  'pusat',
  'puset',
  'puslu',
  'pürüz',
  'pütür',
  'racon',
  'radar',
  'radde',
  'radyo',
  'ragbi',
  'rahat',
  'rahim',
  'rahip',
  'rakam',
  'raket',
  'rakım',
  'rakip',
  'rakun',
  'ralli',
  'ramak',
  'rampa',
  'ranza',
  'rapor',
  'raunt',
  'recep',
  'reçel',
  'redif',
  'refah',
  'rehin',
  'rejim',
  'rekat',
  'rekor',
  'rende',
  'resif',
  'resim',
  'resmi',
  'resul',
  'reşit',
  'revan',
  'revir',
  'reyon',
  'rezil',
  'rızık',
  'rimel',
  'ritim',
  'robot',
  'rodeo',
  'roket',
  'roman',
  'romen',
  'rosto',
  'rozet',
  'röfle',
  'rögar',
  'rötar',
  'rötuş',
  'rubai',
  'ruble',
  'rugan',
  'rulet',
  'rumca',
  'rumuz',
  'runik',
  'rusça',
  'rutin',
  'rüküş',
  'rüsva',
  'rütbe',
  'sabah',
  'saban',
  'sabır',
  'sabit',
  'sabun',
  'saçak',
  'saçma',
  'sadak',
  'sadet',
  'sadık',
  'safça',
  'safha',
  'safir',
  'safra',
  'sağım',
  'sağır',
  'sahaf',
  'sahan',
  'sahil',
  'sahip',
  'sahne',
  'sahra',
  'sahte',
  'sahur',
  'sakal',
  'sakar',
  'sakat',
  'sakın',
  'sakız',
  'sakin',
  'saklı',
  'saksı',
  'salak',
  'salam',
  'salaş',
  'salça',
  'salep',
  'salgı',
  'salim',
  'salon',
  'salsa',
  'salya',
  'saman',
  'samba',
  'samur',
  'sanal',
  'sanat',
  'sancı',
  'sanık',
  'sanki',
  'sanrı',
  'sapak',
  'sapan',
  'sapık',
  'sapma',
  'saray',
  'sargı',
  'sarma',
  'sarpa',
  'saten',
  'satım',
  'satır',
  'satış',
  'sauna',
  'savan',
  'savaş',
  'savcı',
  'savma',
  'sayaç',
  'sayfa',
  'saygı',
  'sayım',
  'sayın',
  'sayış',
  'sazan',
  'seans',
  'sebep',
  'sebil',
  'sebze',
  'secde',
  'seçim',
  'seçme',
  'sedef',
  'sedir',
  'sedye',
  'sefer',
  'sefil',
  'sefir',
  'seher',
  'sehpa',
  'sekiz',
  'seksi',
  'sekte',
  'selam',
  'selim',
  'selvi',
  'semai',
  'semer',
  'semiz',
  'senet',
  'sepet',
  'sepya',
  'serap',
  'serçe',
  'sergi',
  'serin',
  'serum',
  'servi',
  'sesli',
  'sevap',
  'sevda',
  'sever',
  'sevgi',
  'seviş',
  'seyir',
  'sezgi',
  'sezon',
  'sıcak',
  'sıçan',
  'sıfat',
  'sıfır',
  'sığır',
  'sıhhi',
  'sıkça',
  'sınav',
  'sınıf',
  'sınır',
  'sırat',
  'sırık',
  'sırım',
  'sırma',
  'sıska',
  'sıtma',
  'sızma',
  'sibop',
  'sicil',
  'sicim',
  'sidik',
  'sifon',
  'siğil',
  'sihir',
  'sikke',
  'silah',
  'silgi',
  'silik',
  'sille',
  'silme',
  'simge',
  'simit',
  'simya',
  'sinek',
  'sinir',
  'sinsi',
  'sinüs',
  'siper',
  'siren',
  'sirke',
  'siroz',
  'sisli',
  'sitem',
  'sivil',
  'sivri',
  'siyah',
  'skala',
  'slayt',
  'sofra',
  'soğan',
  'soğuk',
  'sokak',
  'soket',
  'sokum',
  'solak',
  'soluk',
  'somon',
  'somun',
  'somut',
  'somya',
  'sonar',
  'sonat',
  'sonda',
  'sonra',
  'sonuç',
  'sorgu',
  'sorun',
  'sosis',
  'soylu',
  'soyma',
  'soyut',
  'söğüş',
  'söğüt',
  'sökük',
  'sökün',
  'sönük',
  'sövgü',
  'sövme',
  'sözcü',
  'sözel',
  'sözlü',
  'spazm',
  'sperm',
  'sprey',
  'stant',
  'statü',
  'stent',
  'streç',
  'stres',
  'subay',
  'sucuk',
  'sucul',
  'suçlu',
  'sufle',
  'sulak',
  'suluk',
  'sumak',
  'sunak',
  'sunta',
  'sunum',
  'sunuş',
  'surat',
  'suret',
  'susam',
  'susuz',
  'sükse',
  'sülük',
  'sülün',
  'sümer',
  'sümük',
  'süngü',
  'sünni',
  'süper',
  'sürat',
  'süreç',
  'sürgü',
  'sürme',
  'sürüm',
  'süslü',
  'sütçü',
  'sütlü',
  'sütun',
  'şaban',
  'şafak',
  'şafii',
  'şahap',
  'şahıs',
  'şahin',
  'şahit',
  'şahsi',
  'şaibe',
  'şakak',
  'şaman',
  'şamar',
  'şanlı',
  'şapka',
  'şarap',
  'şarkı',
  'şaşaa',
  'şaşma',
  'şayet',
  'şebek',
  'şehir',
  'şehit',
  'şehla',
  'şeker',
  'şekil',
  'şeref',
  'şerif',
  'şerit',
  'şınav',
  'şifon',
  'şifre',
  'şilte',
  'şimdi',
  'şirin',
  'şişik',
  'şişko',
  'şişme',
  'şoför',
  'şopar',
  'şölen',
  'şubat',
  'şurup',
  'şükür',
  'şüphe',
  'tabak',
  'taban',
  'tabii',
  'tabip',
  'tabir',
  'tabla',
  'tablo',
  'tabur',
  'tabut',
  'tacir',
  'taciz',
  'tadım',
  'tahıl',
  'tahin',
  'tahta',
  'takas',
  'takat',
  'takım',
  'takip',
  'takke',
  'takla',
  'takoz',
  'taksi',
  'takva',
  'talan',
  'talaş',
  'talaz',
  'talep',
  'talih',
  'talil',
  'talim',
  'talip',
  'tamah',
  'tamam',
  'tamir',
  'tango',
  'tanık',
  'tanım',
  'tanış',
  'tanrı',
  'tapma',
  'taraf',
  'tarak',
  'taraz',
  'tarım',
  'tarif',
  'tarih',
  'tarik',
  'tariz',
  'tarla',
  'tartı',
  'tasma',
  'taşıt',
  'taşma',
  'taşra',
  'tatar',
  'tatil',
  'tatlı',
  'tatma',
  'tavaf',
  'tavan',
  'tavır',
  'taviz',
  'tavla',
  'tavuk',
  'tavus',
  'tayfa',
  'tayin',
  'tebaa',
  'tecil',
  'teğet',
  'teizm',
  'tekel',
  'teker',
  'tekil',
  'tekin',
  'tekir',
  'tekke',
  'tekli',
  'tekme',
  'tekne',
  'telaş',
  'telef',
  'telif',
  'telli',
  'telve',
  'temas',
  'temel',
  'temin',
  'temiz',
  'tempo',
  'tenha',
  'tenis',
  'tenor',
  'tente',
  'tenya',
  'teori',
  'tepki',
  'tepme',
  'tepsi',
  'teras',
  'terfi',
  'terim',
  'terli',
  'terör',
  'terzi',
  'tesir',
  'testi',
  'tetik',
  'teyit',
  'teyze',
  'tezat',
  'tezce',
  'tezek',
  'tıbbi',
  'tıfıl',
  'tıkaç',
  'tıkır',
  'tımar',
  'tıpkı',
  'tıraş',
  'tilki',
  'tiner',
  'tipik',
  'titan',
  'titiz',
  'tohum',
  'tokat',
  'tokyo',
  'tomar',
  'toner',
  'tonik',
  'topak',
  'topal',
  'topaz',
  'topçu',
  'toplu',
  'topuk',
  'topuz',
  'torba',
  'torna',
  'tortu',
  'torun',
  'tosun',
  'total',
  'totem',
  'tozlu',
  'tören',
  'törpü',
  'tövbe',
  'trafo',
  'trans',
  'triko',
  'tufan',
  'tugay',
  'tuğla',
  'tuğra',
  'tuhaf',
  'tulum',
  'tunik',
  'turan',
  'turbo',
  'turna',
  'turne',
  'turşu',
  'turta',
  'tutam',
  'tutar',
  'tutku',
  'tutuk',
  'tutum',
  'tuval',
  'tuyuğ',
  'tuzak',
  'tuzlu',
  'tüfek',
  'tümce',
  'tümen',
  'tümör',
  'tünel',
  'tüpçü',
  'türbe',
  'türev',
  'türkü',
  'türlü',
  'tütsü',
  'tütün',
  'tüvit',
  'tüylü',
  'tüzel',
  'tüzük',
  'ucube',
  'uçarı',
  'uçkur',
  'uçmak',
  'uçsuz',
  'uçucu',
  'uğrak',
  'uğraş',
  'ukala',
  'ulama',
  'uluma',
  'ummak',
  'umumi',
  'unsur',
  'unvan',
  'urban',
  'urgan',
  'usanç',
  'utanç',
  'uyarı',
  'uygar',
  'uygun',
  'uygur',
  'uyluk',
  'uymak',
  'uyruk',
  'uysal',
  'uyuma',
  'uzama',
  'uzman',
  'ücret',
  'üçgen',
  'ülser',
  'ümmet',
  'ünite',
  'ünlem',
  'ünsüz',
  'üreme',
  'ürkek',
  'ürkme',
  'üryan',
  'üslup',
  'üstat',
  'üstün',
  'üşüme',
  'ütülü',
  'üzgün',
  'üzücü',
  'vacip',
  'vagon',
  'vahim',
  'vahiy',
  'vahşi',
  'vakıf',
  'vakit',
  'vakum',
  'vakur',
  'valiz',
  'vapur',
  'varak',
  'varış',
  'varil',
  'varis',
  'varoş',
  'vasat',
  'vasıf',
  'vaşak',
  'vatan',
  'vatka',
  'vatoz',
  'vebal',
  'vefat',
  'vekil',
  'velet',
  'venüs',
  'verem',
  'vergi',
  'verim',
  'vezir',
  'vezne',
  'vıcık',
  'video',
  'villa',
  'viraj',
  'viral',
  'viran',
  'virüs',
  'viski',
  'vişne',
  'vites',
  'viyak',
  'vizon',
  'vizör',
  'vokal',
  'volan',
  'volta',
  'votka',
  'vurgu',
  'vuruş',
  'vücut',
  'yaban',
  'yafta',
  'yağcı',
  'yahni',
  'yahut',
  'yakın',
  'yakıt',
  'yakut',
  'yalan',
  'yalaz',
  'yalın',
  'yamaç',
  'yaman',
  'yamuk',
  'yanak',
  'yancı',
  'yanık',
  'yanıt',
  'yankı',
  'yapay',
  'yapım',
  'yapıt',
  'yarar',
  'yaren',
  'yargı',
  'yarık',
  'yarın',
  'yarış',
  'yarma',
  'yasak',
  'yasal',
  'yasin',
  'yaslı',
  'yassı',
  'yaşam',
  'yaşıt',
  'yaşlı',
  'yatak',
  'yatay',
  'yatık',
  'yatır',
  'yavan',
  'yavaş',
  'yaver',
  'yavru',
  'yavuz',
  'yayan',
  'yayık',
  'yayın',
  'yayla',
  'yaylı',
  'yayma',
  'yazar',
  'yazgı',
  'yazık',
  'yazıt',
  'yedek',
  'yeğen',
  'yelek',
  'yemek',
  'yemin',
  'yenge',
  'yenik',
  'yergi',
  'yerli',
  'yeşil',
  'yeşim',
  'yeter',
  'yetim',
  'yetki',
  'yığın',
  'yıkık',
  'yılan',
  'yılgı',
  'yiğit',
  'yitik',
  'yobaz',
  'yoğun',
  'yokuş',
  'yolcu',
  'yollu',
  'yonca',
  'yonga',
  'yontu',
  'yorum',
  'yosma',
  'yosun',
  'yönlü',
  'yörük',
  'yudum',
  'yufka',
  'yulaf',
  'yular',
  'yumak',
  'yumru',
  'yumuk',
  'yunan',
  'yunus',
  'yutak',
  'yuvar',
  'yüklü',
  'yünlü',
  'yürek',
  'yüzde',
  'yüzer',
  'yüzey',
  'yüzük',
  'zabıt',
  'zafer',
  'zalim',
  'zaman',
  'zamir',
  'zamlı',
  'zanlı',
  'zarar',
  'zarif',
  'zaten',
  'zayıf',
  'zebra',
  'zebur',
  'zehir',
  'zekat',
  'zemin',
  'zenci',
  'zenne',
  'zerre',
  'zeval',
  'zevce',
  'zıbın',
  'zımba',
  'zıpır',
  'zırva',
  'zifir',
  'zigon',
  'zigot',
  'zihin',
  'zikir',
  'zilli',
  'zinde',
  'zirai',
  'zirve',
  'ziyan',
  'zombi',
  'zorba',
  'zulüm',
  'zurna',
  'zühre',
  'zülüf',
  'zümre',
  'züppe',
  'adalı',
  'adama',
  'afili',
  'afişe',
  'ağcık',
  'ajite',
  'alyan',
  'ansız',
  'anyon',
  'apsis',
  'arpej',
  'arter',
  'atfen',
  'atılı',
  'avşar',
  'ayıcı',
  'aymaz',
  'ayyuk',
  'bağıl',
  'balcı',
  'bıkış',
  'bitim',
  'bozum',
  'bozuş',
  'bröve',
  'büküş',
  'büluğ',
  'cayış',
  'cihaz',
  'coşum',
  'coşuş',
  'çakar',
  'çakım',
  'çancı',
  'çanlı',
  'çaylı',
  'çeçen',
  'çelim',
  'çengi',
  'çerçi',
  'çıkan',
  'çiziş',
  'çökme',
  'çöküm',
  'çömme',
  'çöplü',
  'çözme',
  'dağlı',
  'değil',
  'değiş',
  'dekar',
  'demek',
  'deşme',
  'diziş',
  'dizme',
  'doğma',
  'donlu',
  'dorse',
  'döküş',
  'dönme',
  'döper',
  'dutçu',
  'düzme',
  'evcik',
  'fışkı',
  'füsun',
  'geçen',
  'geren',
  'geriş',
  'geziş',
  'godoş',
  'göçme',
  'göçüm',
  'göçüş',
  'gürcü',
  'haluk',
  'havlu',
  'içici',
  'içsiz',
  'ilhak',
  'ilhan',
  'inönü',
  'ipçik',
  'ismen',
  'ismet',
  'istop',
  'itlik',
  'kabul',
  'kaçma',
  'kanış',
  'kapma',
  'kayma',
  'keski',
  'kisve',
  'kolon',
  'kopuş',
  'lüzum',
  'mason',
  'maşuk',
  'mehil',
  'mezra',
  'mümin',
  'nahoş',
  'neyse',
  'nonoş',
  'ojeli',
  'onsuz',
  'organ',
  'otluk',
  'örtük',
  'örtüş',
  'pafta',
  'polis',
  'satma',
  'seyis',
  'seyit',
  'soyuş',
  'sülüs',
  'üçlük',
  'yağız',
  'yanal'
];
