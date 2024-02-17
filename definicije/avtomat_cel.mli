type t

val nov_grid : t -> Stanje.t array -> t
val prazen_avtomat : Stanje.t -> t
val dodaj_nesprejemno_stanje : Stanje.t -> t -> t
(* val dodaj_sprejemno_stanje : Stanje.t -> t -> t *)
val dodaj_prehod : (Stanje.t *Stanje.t *Stanje.t ) -> Stanje.t -> t -> t
val prehodna_funkcija : t -> t
(* val zacetno_stanje : t -> Stanje.t *)
val seznam_stanj : t -> Stanje.t list
val seznam_prehodov : t -> ((Stanje.t * Stanje.t *Stanje.t) * Stanje.t) list
val grid : t -> Stanje.t array
(* val je_sprejemno_stanje : t -> Stanje.t -> bool *)
(* val enke_1mod3 : t *)
val conway : t
(* val preberi_niz : t -> Stanje.t -> string -> Stanje.t option *)
