type stanje = Stanje.t


type okolica = Stanje.t * Stanje.t * Stanje.t

type t = {
  stanja : stanje list;
  grid : stanje array;
  prehodi : (okolica * stanje) list;
}


let nov_grid avtomat grid =
  {avtomat with grid = grid}

let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];
    grid = [||];
    prehodi = [];
  }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_prehod okolica stanje avtomat =
  { avtomat with prehodi = (okolica, stanje) :: avtomat.prehodi }

let prehodna_funkcija avtomat =
  let n = Array.length avtomat.grid in
  let okolica_od i =
    (avtomat.grid.((n+i-1) mod n) , avtomat.grid.(i) , avtomat.grid.((i+1) mod n))
  in
  let vrni = Array.copy avtomat.grid
  in
  for i = 0 to n-1 do
    match
    List.find_opt
      (fun (okolica', _stanje) -> okolica' = (okolica_od i))
      avtomat.prehodi
    with
    | None -> ()
    | Some (_, stanje) -> (vrni.(i)<- stanje)
  done;
  {avtomat with grid = vrni}


let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi
let grid avtomat = avtomat.grid

let elementaren1d rule =
  let q0 = Stanje.iz_char '0'
  and q1 = Stanje.iz_char '1'
  and rule_ar = rule |> String.to_seq |> Seq.map Stanje.iz_char |> Array.of_seq
  in
  prazen_avtomat q0 |> dodaj_nesprejemno_stanje q1
  |> dodaj_prehod (q1, q1, q1) rule_ar.(0) |> dodaj_prehod (q1, q1, q0) rule_ar.(1) |> dodaj_prehod (q1, q0, q1) rule_ar.(2)
  |> dodaj_prehod (q1, q0, q0) rule_ar.(3) |> dodaj_prehod (q0, q1, q1) rule_ar.(4) |> dodaj_prehod (q0, q1, q0) rule_ar.(5)
  |> dodaj_prehod (q0, q0, q1) rule_ar.(6) |> dodaj_prehod (q0, q0, q0) rule_ar.(7)

(* Tole je 1D elementarni celični avtomat, vseh možnih je 256 (poimenovani kot pravila od 0 do 255). 
   Trenutno je v tekstovni.Vmesnik.ml nastavljen na pravilo 110 (01101110 binarno). Za poljubno pravilo je treba poklicati
   funkcijo s stringom binarnega zapisa števila pravila na osmih mestih kot argumentom *)
