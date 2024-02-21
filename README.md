# Celični avtomati

V projektni nalogi so implementirani celični avtomati in nekaj primerov njihove uporabe.

Celični avtomat začne z nekim osnovnim poljem celic, nato pa se vse celice naenkrat spremenijo glede na stanja celic v svoji okolici. Tako se polje spreminja (ali pa na neki točki pride do stabilnega stanja ali zanke ali vesoljske ladje, ki se premika v neskončnost) in te korake lahko izvajamo poljubno dolgo časa.

## Matematična definicija

Celični avtomat definiramo kot nabor $(Q, \Sigma, F, \delta)$,
- $Q$- množica simbolov oz. abeceda možnih stanj točk
- $\Sigma$ - polje celic, stanja celic ob času 0
- $F$ - okolice točk
- $\delta : F \times \Sigma \to Q$ - prehodna funkcija
 
## Predstavljeni primeri
V tej projektni nalogi sta predstavljena avtomata za 1D elementarni celični avtomat (Elemantary cellular automata) in zunanji totalistični avtomat (Outer totalistic automata) ter za vsakega en primer. Pri obeh primerih se konec polja desno (dol) nadeljuje levo (gor), torej kot da bi imeli polje na torusu. Pri obeh primerih imamo 2 možni stanji celic: 0 in 1. 1 predstavlja živo celico, 0 pa mrtvo celico. 

### Elementarni celični avtomat
Imamo vrstico celic, ki jih predstavlja niz številk 0 in 1, 1 predstavlja živo celico, 0 pa mrtvo celico. Okolica točke je levi sosed, celica sama in desni sosed celice. V tem primeru ločimo celice v okolici glede na pozicijo, tako imamo 8 možnih okolic (binarni zapisi števil 0 - 8). Tako je le 2^8 = 256 različnih elementarnih celičnih avtomatov. Prehodne funkcije za te avtomate lahko torej oštevilčimo 0 do 255, in če število zapišemo binarno po vrsti dobimo v kaj se slika posamezna okolica (111 v 1. števko, 110 v 2., ... 000 v 8. števko).

### Zunanji totalistični avtomat
V totalističnem avtomatu imamo polje celic v 2D, stanja celic so ponavadi števila, novo stanje celice je določeno z vsoto vrednosti celic v okolici. Če je novo stanje odvisno od vsote vrednosti celic v okolici in od stanja celice je to zunanji totalistični avtomat. Najbolj znan primer je Conway's Game of Life, kjer na to ali bo celica živa ali mrtva vpliva njena vrednost in njena Moorova okolica (8 celic v kvadratu okoli nje). Ta primer je tudi predstavljen v tej projektni nalogi.

## Navodila za uporabo
Na voljo sta dva tekstovna vmesnika za omenjena dva tipa celičnih avtomatov. Z ukazom `dune build` v korenskem imeniku ustvarimo datoteki `tekstovniVmesnikEL.exe` in `tekstovniVmesnikOT.exe`, prva je za elementarne celične avtomate, druga pa za zunanje totalistične.
