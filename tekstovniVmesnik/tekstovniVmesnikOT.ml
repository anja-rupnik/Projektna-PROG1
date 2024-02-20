open Definicije


type stanje_vmesnika =
  | SeznamMoznosti
  | IzpisAvtomata
  | VstaviDim
  | VstaviVrstico
  | NaslednjiGrid
  | RezultatGrid
  | OpozoriloONapacnemNizu

type model = {
  avtomat : Avtomat_cel_ot.t;
  stanje_vmesnika : stanje_vmesnika;
  st_vrstic_ze : int
}

type msg = PreberiVrstico of string * int | DimenzijeGrida of int * int | ZamenjajVmesnik of stanje_vmesnika | PosodobiGrid

let preberi_vrstico avtomat vrstica i =
  Avtomat_cel_ot.nova_vrstica avtomat (vrstica |> String.to_seq |> Seq.map Stanje.iz_char |> Array.of_seq) i



let update model = function
  | DimenzijeGrida (v, s) -> 
    let avtomat = Avtomat_cel_ot.ustvari_grid v s model.avtomat in
    {avtomat;
    stanje_vmesnika = VstaviVrstico;
    st_vrstic_ze = 0}
  | PreberiVrstico (vrstica, i) ->
          preberi_vrstico (model.avtomat) vrstica i;
          if i+1 < Avtomat_cel_ot.st_vrstic model.avtomat then
            { model with
            stanje_vmesnika = VstaviVrstico;
            st_vrstic_ze = i+1}
          else
            { model with
            stanje_vmesnika = NaslednjiGrid;}
  | PosodobiGrid -> {model with avtomat = Avtomat_cel_ot.prehodna_funkcija model.avtomat;
                    stanje_vmesnika = RezultatGrid}
  | ZamenjajVmesnik stanje_vmesnika -> { model with stanje_vmesnika }

let rec izpisi_moznosti () =
  print_endline "1) izpiši avtomat";
  print_endline "2) vstavi grid";
  print_endline "3) nadaljuj z istim gridom";
  print_string "> ";
  match read_line () with
  | "1" -> ZamenjajVmesnik IzpisAvtomata
  | "2" -> ZamenjajVmesnik VstaviDim
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
  List.iter izpisi_stanje (Avtomat_cel_ot.seznam_stanj avtomat)

let beri_vrstico _model =
  print_string "Vnesi vrstico > ";
  let vrstica = read_line () in
  PreberiVrstico (vrstica, _model.st_vrstic_ze)

let beri_dim _model =
  print_string "Vnesi število vrstic > ";
  let v = read_line () in
  print_string "Vnesi število stolpcev > ";
  let s = read_line () in
  DimenzijeGrida (int_of_string v, int_of_string s)

let izpisi_rezultat _model =
  for i = 0 to Avtomat_cel_ot.st_vrstic _model.avtomat do
    print_endline (Array.to_seq (Avtomat_cel_ot.grid _model.avtomat).(i) |> Seq.map Stanje.v_char |> String.of_seq )
  done


let view model =
  match model.stanje_vmesnika with
  | SeznamMoznosti -> izpisi_moznosti ()
  | IzpisAvtomata ->
      izpisi_avtomat model.avtomat;
      ZamenjajVmesnik SeznamMoznosti
  | VstaviDim -> beri_dim model
  | VstaviVrstico -> beri_vrstico model
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
    st_vrstic_ze = 0
  }

let rec loop model =
  let msg = view model in
  let model' = update model msg in
  loop model'

let _ = loop (init Avtomat_cel_ot.conway)

