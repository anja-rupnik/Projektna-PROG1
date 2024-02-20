type t

val nova_vrstica : t -> Stanje.t array -> int-> unit
val ustvari_grid : int -> int -> t -> t
val nastavi_okolico : t -> (int*int*int*int*int*int -> bool) -> t
val prazen_avtomat : (int*int*int*int*int*int -> bool) -> t
val dodaj_nesprejemno_stanje : Stanje.t -> t -> t
val dodaj_prehod : int -> Stanje.t -> Stanje.t -> t -> t
val index: Stanje.t list -> Stanje.t -> int
val prehodna_funkcija : t -> t
val seznam_stanj : t -> Stanje.t list
val seznam_prehodov : t -> (int * Stanje.t * Stanje.t) list
val grid : t -> Stanje.t array array
val st_vrstic : t -> int

val metricna : float -> float -> (int*int*int*int*_*_ -> bool)
val metricna_torus : float -> float -> (int*int*int*int*int*int -> bool)
val metricni_obroc_torus : float -> float -> float -> (int*int*int*int*int*int -> bool)
val moore : int*int*int*int*int*int -> bool

val conway : t
