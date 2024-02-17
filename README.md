# Celični avtomati

V projektni nalogi so implementirani celični avtomati in nekaj primerov njihove uporabe.

Celični avtomat začne z nekim osnovnim poljem celic, nato pa se vse celice naenkrat spremenijo glede na stanja celic v svoji okolici. Tako se polje spreminja (ali pa na neki točki pride do stabilnega stanja ali zanke) in te korake lahko izvajamo poljubno dolgo časa. Moj model predvide da se levi konec polja nadaljuje na desnem

Za primer si oglejmo nekaj podobnega Conway's game of life ampak v 1D. Imamo torej vrstico celic, ki jih predstavlja niz številk 0 in 1, 1 predstavlja živo celico, 0 pa mrtvo celico. Okolica točke je levi sosed, celica sama in desni sosed celice. Če ima celica v okolici 2 živi celici bo tudi v naslednjem koraku živa, drugače pa bo mrtva.


## Matematična definicija

Celični avtomat definiramo kot nabor $(\Sigma, Q, q_0, F, \delta)$,
- $\Sigma$
- definicija je pol something along the lines of:
    - E - abeceda možnih stanj točk
    - A_0 - začetni seznam stanj točk (seprav bassiaclly grid), ta je element A (= E* E* ... *E - možni seznami stanj točk)
    - B - seznam sosesk točk
    - input je čas? al začetno stanje?
    - sprejemljiva stanja??
    - funkcija/kriterij: A * B -> A nova vrednost točke



Še za narest:
- da ti javi napake/ne sprejme grida
- 2d? -> okolice so drugačne
- še en primer?
