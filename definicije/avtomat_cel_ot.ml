type stanje = Stanje.t

(* maybe nared svojo *)
type okolica = int

type t = {
  stanja : stanje list;
  grid : stanje array array;
  def_okolice : int*int*int*int -> bool;
  prehodi : (okolica * stanje) list;
}

let ustvari_grid v s avtomat =
  {avtomat with grid = Array.make v (Array.make s (List.hd avtomat.stanja))}
let nova_vrstica avtomat vrstica i = 
  avtomat.grid.(i) <- vrstica

let nastavi_okolico avtomat f =
  {avtomat with def_okolice = f}

let prazen_avtomat zac_el =
  {
    stanja = [zac_el];
    grid = [|[||]|];
    prehodi = [];
    def_okolice = fun _ -> false
  }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_prehod okolica stanje avtomat =
  { avtomat with prehodi = (okolica, stanje) :: avtomat.prehodi }

(* popravi!!! *)
let prehodna_funkcija avtomat =
  let v,s = Array.length avtomat.grid, Array.length avtomat.grid.(0) in
  (* (okolica -> string(okolica)) -> prehodi -> novo stanje *) 
  let okolica_od n m =
    let vr_ok = ref 0. in
      for i = 0 to v do
        for j = 0 to s do
          if (avtomat.def_okolice (n,m,i,j)) = true 
            then vr_ok :=  10.**(float_of_int (int_of_char (Stanje.v_char avtomat.grid.(i).(j)))) +. !vr_ok
        done
      done;
      int_of_float !vr_ok
    in
  let vrni = Array.copy avtomat.grid
  in
  for i = 0 to v do
    for j = 0 to s do
      match
      List.find_opt
        (fun (okolica', _stanje) -> okolica' = (okolica_od i j))
        avtomat.prehodi
      with
      | None -> ()
      | Some (_, stanje) -> (vrni.(i).(j)<- stanje)
    done
  done;
  {avtomat with grid = vrni}


let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi
let grid avtomat = avtomat.grid
let st_vrstic avtomat = Array.length avtomat.grid


(* let elementaren1d =
  let q0 = Stanje.iz_char '0'
  and q1 = Stanje.iz_char '1'
  in
  prazen_avtomat q0 |> dodaj_nesprejemno_stanje q1
  |> dodaj_prehod (q1, q1, q1) q0 |> dodaj_prehod (q1, q1, q0) q1 |> dodaj_prehod (q1, q0, q1) q1
  |> dodaj_prehod (q1, q0, q0) q0 |> dodaj_prehod (q0, q1, q1) q1 |> dodaj_prehod (q0, q1, q0) q0
  |> dodaj_prehod (q0, q0, q1) q0 |> dodaj_prehod (q0, q0, q0) q0 *)

(* let preberi_niz avtomat q niz =
  let aux acc znak =
    match acc with None -> None | Some q -> prehodna_funkcija avtomat q znak
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q) *)
