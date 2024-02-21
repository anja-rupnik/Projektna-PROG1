type stanje = Stanje.t

type okolica = int

type t = {
  stanja : stanje list;
  grid : stanje array array;
  def_okolice : int*int*int*int*int*int -> bool;
  prehodi : (okolica * stanje * stanje) list;
}

let ustvari_grid v s avtomat =
  {avtomat with grid = Array.make v (Array.make s (List.hd avtomat.stanja))}
let nova_vrstica avtomat vrstica i = 
  avtomat.grid.(i) <- vrstica

let nastavi_okolico avtomat f =
  {avtomat with def_okolice = f}

let prazen_avtomat def_okolice =
  {
    stanja = [];
    grid = [|[||]|];
    def_okolice = def_okolice;
    prehodi = [];
  }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_prehod okolica stanjeZ stanjeK avtomat =
  { avtomat with prehodi = (okolica, stanjeZ, stanjeK) :: avtomat.prehodi }

(*pri meni List.find_index ne dela, ker imam preslabo verzijo zato imamo to funkcijo ročno narejeno*)
let index list el =
  let rec aux list i =
    match list with
    | x :: _ when x = el -> i
    | _ :: xs -> aux xs i+1
    | [] -> failwith "tega el ni v listu"
  in
  aux list 0

let prehodna_funkcija avtomat =
  let v,s = Array.length avtomat.grid, Array.length avtomat.grid.(0) in
  (* let vrni = Array.make v (Array.make s (List.hd avtomat.stanja)) *)
  let vrni = Array.copy avtomat.grid
  and okolica_od n m =
    let vrednost_okolice = ref 0. in
    for i = 0 to v-1 do
      for j = 0 to s-1 do
        if (avtomat.def_okolice (n,m,i,j,v,s)) = true 
          then vrednost_okolice :=  (10.**(float_of_int(index avtomat.stanja avtomat.grid.(i).(j)))) +. !vrednost_okolice
        (* Vrednost okolice smo izracumali tako da natančno loči koliko celic posamezne vrste je v njej.
          Vsakemu od možnih stanj celic odgovarja eno desetiško mesto v vrednosti_okolice,
          desetiška mesta so napisana ravno v obratni smeri kot so v seznamu stanj (avtomat.stanja).
          Problem nastane, če je okolica večja od 10. Potem se lahko 10 v izrazu zamenja s max številom celic v okolici.
          Potem je vrednost_okolice treba pretvoriti iz desetiškega v tisti sistem, če želimo lažje prebrati, koliko celic v posameznem stanju imamo. *)
      done;
    done;
    int_of_float !vrednost_okolice
  in
  for i = 0 to v-1 do
    let vrst = Array.copy vrni.(i) in
    for j = 0 to s-1 do
      print_int (okolica_od i j);
      print_endline "to je bla okolica";
      print_char (Stanje.v_char avtomat.grid.(i).(j));
      print_endline "";
      match
      List.find_opt
        (fun (okolica', stanjeZ, _stanje) -> (okolica' = (okolica_od i j) && stanjeZ = avtomat.grid.(i).(j)))
        avtomat.prehodi
      with
      | None -> ()
      | Some (_, _, stanje) -> (vrst.(j) <- stanje);print_char (Stanje.v_char vrni.(i).(j)); print_char (Stanje.v_char stanje);print_endline"";
    done;
    (vrni.(i) <- vrst)
  done;
  {avtomat with grid = vrni}


let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi
let grid avtomat = avtomat.grid
let st_vrstic avtomat = Array.length avtomat.grid


(* PRIMER FUNKCIJE ZA DEFINICIJO OKOLICE 
   tale vrne zaprto okolico s polmerom r v metriki m. *)
let metricna r m =
  fun (x1, y1, x2, y2, _ , _) -> (float_of_int (abs x1-x2))**m +. (float_of_int (abs y1-y2))**m <= r**m
   
(* To, da podamo v in s - št vrstic in stolpcev funkciji za okolico,
   tukaj potrebujemo saj lahko tako mrežo spremenimo v torus. *)
let metricna_torus r m =
  fun (x1, y1, x2, y2, v, s) -> 
    (float_of_int (min (abs x1-x2) (v - abs x1-x2)))**m +. (float_of_int (min (abs y1-y2) (s - abs y1-y2)))**m <= r**m

(* Še primer "obroča" v metriki m (zaprte okolice z r1 brez zaprte okolice z r0). *)
let metricni_obroc_torus r0 r1 m =
  fun (x1, y1, x2, y2, v, s) -> 
    let d = (float_of_int (min (abs x1-x2) (v - abs x1-x2)))**m +. (float_of_int (min (abs y1-y2) (s - abs y1-y2)))**m in
    d <= r1**m && r0**m < d

(* Ena od najbolj osnovnih okolic - Moorova okolica, ki jo recimo uporablja eden
   od najbolj znanih primerov celičnih avtomatov - Conway's game of life. *)
let moore =
  fun (x1, y1, x2, y2, v, s) -> (x1 != x2 || y1 != y2) && (max (min (abs(x1-x2)) (v- abs(x1-x2))) (min (abs(y1-y2)) (s- abs(y1-y2)))) <= 1

(* moorova okolica bi bila pravzaprav metricni_obroc_torus 0. 1. infinity vendar je neskončnost
  očitno problematična za računalnik. *)

let conway =
  let q0 = Stanje.iz_char '0'
  and q1 = Stanje.iz_char '1'
  in
  prazen_avtomat moore |> dodaj_nesprejemno_stanje q1 |> dodaj_nesprejemno_stanje q0
  |> dodaj_prehod 08 q0 q0 |> dodaj_prehod 17 q0 q0 |> dodaj_prehod 26 q0 q0
  |> dodaj_prehod 35 q0 q1 |> dodaj_prehod 44 q0 q0 |> dodaj_prehod 53 q0 q0
  |> dodaj_prehod 62 q0 q0 |> dodaj_prehod 71 q0 q0 |> dodaj_prehod 80 q0 q0
  |> dodaj_prehod 08 q1 q0 |> dodaj_prehod 17 q1 q0 |> dodaj_prehod 26 q1 q1
  |> dodaj_prehod 35 q1 q1 |> dodaj_prehod 44 q1 q0 |> dodaj_prehod 53 q1 q0
  |> dodaj_prehod 62 q1 q0 |> dodaj_prehod 71 q1 q0 |> dodaj_prehod 80 q1 q0

