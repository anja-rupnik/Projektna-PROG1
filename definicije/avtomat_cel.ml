type stanje = Stanje.t

(* maybe nared svojo *)
type okolica = Stanje.t * Stanje.t * Stanje.t

type t = {
  stanja : stanje list;
  grid : stanje array;
  prehodi : (okolica * stanje) list;
}

(* spremeni grid  funkcija!!!*)
let nov_grid avtomat grid =
  {avtomat with grid = grid}
(* tole bo za popravt vrjetno *)
let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];
    grid = [||];
    prehodi = [];
  }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

(* let dodaj_sprejemno_stanje stanje avtomat =
  {
    avtomat with
    stanja = stanje :: avtomat.stanja;
    sprejemna_stanja = stanje :: avtomat.sprejemna_stanja;
  } *)

let dodaj_prehod okolica stanje avtomat =
  { avtomat with prehodi = (okolica, stanje) :: avtomat.prehodi }

let prehodna_funkcija avtomat =
  let n = Array.length avtomat.grid in
  (* (okolica -> string(okolica)) -> prehodi -> novo stanje *) 
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

let conway =
  let q0 = Stanje.iz_char '0'
  and q1 = Stanje.iz_char '1'
  in
  prazen_avtomat q0 |> dodaj_nesprejemno_stanje q1
  |> dodaj_prehod (q0, q0, q0) q0 |> dodaj_prehod (q1, q0, q0) q0 |> dodaj_prehod (q0, q1, q0) q0
  |> dodaj_prehod (q0, q0, q1) q0 |> dodaj_prehod (q1, q1, q0) q1 |> dodaj_prehod (q1, q1, q1) q0
  |> dodaj_prehod (q0, q1, q1) q1 |> dodaj_prehod (q1, q0, q1) q1

(* let preberi_niz avtomat q niz =
  let aux acc znak =
    match acc with None -> None | Some q -> prehodna_funkcija avtomat q znak
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q) *)
