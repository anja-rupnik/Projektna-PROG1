type t

val nova_vrstica : t -> Stanje.t array -> int-> unit
val ustvari_grid : int -> int -> t -> t
val nastavi_okolico : t -> (int*int*int*int -> bool) -> t
val prazen_avtomat : Stanje.t -> t
val dodaj_nesprejemno_stanje : Stanje.t -> t -> t
(* val dodaj_sprejemno_stanje : Stanje.t -> t -> t *)
val dodaj_prehod : int -> Stanje.t -> t -> t
val prehodna_funkcija : t -> t
(* val zacetno_stanje : t -> Stanje.t *)
val seznam_stanj : t -> Stanje.t list
val seznam_prehodov : t -> (int * Stanje.t) list
val grid : t -> Stanje.t array array
val st_vrstic : t -> int
(* val je_sprejemno_stanje : t -> Stanje.t -> bool *)
(* val enke_1mod3 : t *)
(* val conway : t *)
(* val preberi_niz : t -> Stanje.t -> string -> Stanje.t option *)
