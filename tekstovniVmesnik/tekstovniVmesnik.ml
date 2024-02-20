open Definicije
(* open Avtomat_cel_el *)


type stanje_vmesnika =
  | SeznamMoznosti
  | IzpisAvtomata
  | VstaviGrid
  | NaslednjiGrid
  | RezultatGrid
  | OpozoriloONapacnemNizu


type model = {
  avtomat : Avtomat_cel_el.t;
  stanje_vmesnika : stanje_vmesnika;
}

type msg = PreberiGrid of string | ZamenjajVmesnik of stanje_vmesnika | PosodobiGrid

let preberi_grid avtomat grid =
  Avtomat_cel_el.nov_grid avtomat (grid |> String.to_seq |> Seq.map Stanje.iz_char |> Array.of_seq)

  let update model = function
  | PreberiGrid grid ->
          let avtomat = preberi_grid (model.avtomat) grid in
          { avtomat;
            stanje_vmesnika = NaslednjiGrid;}
  | PosodobiGrid -> {avtomat = Avtomat_cel_el.prehodna_funkcija model.avtomat;
                    stanje_vmesnika = RezultatGrid}
  | ZamenjajVmesnik stanje_vmesnika -> { model with stanje_vmesnika }

let rec izpisi_moznosti () =
  print_endline "1) izpiši avtomat";
  print_endline "2) vstavi grid";
  print_endline "3) nadaljuj z istim gridom";
  print_string "> ";
  match read_line () with
  | "1" -> ZamenjajVmesnik IzpisAvtomata
  | "2" -> ZamenjajVmesnik VstaviGrid
  | "3" -> ZamenjajVmesnik NaslednjiGrid
  | _ ->
      print_endline "** VNESI 1, 2 ALI 3**";
      izpisi_moznosti ()

let izpisi_avtomat avtomat =
  let izpisi_stanje stanje =
    let prikaz = (Stanje.v_char stanje |> Char.escaped )
    in
    print_endline prikaz
  in
  List.iter izpisi_stanje (Avtomat_cel_el.seznam_stanj avtomat)

let beri_grid _model =
  print_endline "Vnesi grid > ";
  let grid = read_line () in
  PreberiGrid grid

let izpisi_rezultat model =
  print_endline (Array.to_seq (Avtomat_cel_el.grid model.avtomat) |> Seq.map Stanje.v_char |> String.of_seq )


let view model =
  match model.stanje_vmesnika with
  | SeznamMoznosti -> izpisi_moznosti ()
  | IzpisAvtomata ->
      izpisi_avtomat model.avtomat;
      ZamenjajVmesnik SeznamMoznosti
  | VstaviGrid -> beri_grid model
  | NaslednjiGrid -> PosodobiGrid
  | RezultatGrid ->
      izpisi_rezultat model;
      ZamenjajVmesnik SeznamMoznosti
  | OpozoriloONapacnemNizu ->
      print_endline "Niz ni veljaven";
      ZamenjajVmesnik SeznamMoznosti

let init avtomat =
  {
    avtomat;
    stanje_vmesnika = SeznamMoznosti;
  }

let rec loop model =
  let msg = view model in
  let model' = update model msg in
  loop model'

let _ = loop (init (Avtomat_cel_el.elementaren1d "01101110"))

(* Tukaj se lahko namesto 01101110 za poljubno pravilo vpiše število pravila v binarnem zapisu na osmih mestih. *)
