# GUIDA A L'USO di TRACKING STEP-BY-STEP - VER 1.1

Per utilizzare il tracker in lolli, importare il file

> "Lolli/Implementazione/llinterpTrace.pro"

Poi chiamare il predicato

```prolog
tracking.
```

Infine, tracciare il codice lolli in questo modo:

```prolog
seq(Unbound, Bound, Goal).
```

Ad ogni chiamata di `prove` viene stampato il contesto

> `Unbound;Bound => Goal`

Se una chiamata fallisce, sotto alla stampa verrà visualizzato

> `Fail`

e il sistema continuerà con il backtracking.

Tra una stampa e l'altra premere `c` per continuare il tracking, premere `s` per interromperlo.

Per eseguire senza tracking, chimare il predicato

```prolog
stop_traking.
```


# GUIDA A L'USO di TRACKING COLLECT - VER 1.0

Per utilizzare il tracker in lolli, importare il file

> "Lolli/Implementazione/llinterpTraceCollect.pro"

Poi tracciare il codice lolli in questo modo:

```prolog
seq(Unbound, Bound, Goal).
```

Alla fine della procedura, verrà stampata la seguente lista:

> LIVELLO &emsp;&emsp; CHIAMATE EFFETTUATE:

dove *livello* indica il livello di ricorsione interna (0 la radice, ecc) mentre *chiamate effettuate* indica il sequente calcolato. <br>
Le chiamate vengono collezionate sulla "strada di andata", prima della valutazione di `prove`. <br>
Se ci sono più chiamate allo stesso livello i motivi sono tre:

+ Si è verificato un `fail` durante la risoluzione del sequente
+ Vi era un tensore, quindi la prima chiamate risolve il predicato di sinistra, la seconda quello di destra
+ Vi era un ampersand, quindi la prima chiamate risolve il predicato di sinistra, la seconda quello di destra

Se il `goal` viene dimostrato, allora viene anche stampata la seguente lista:

> LIVELLO &emsp;&emsp; SEQUENZA CON SUCCESSO:

dove *livello* indica il livello di ricorsione interna (0 la radice, ecc) mentre *sequenza con successo* indica il sequente calcolato dove tutte le variabile sono istanziate. <br>
Le chiamate vengono collezionate sulla "strada di ritorno", dopo il successo della valutazione di `prove`. <br>
Se ci sono più chiamate allo stesso livello i motivi sono due:

+ Vi era un tensore, quindi la prima chiamate risolve il predicato di destra, la seconda quello di sinistra
+ Vi era un ampersand, quindi la prima chiamate risolve il predicato di destra, la seconda quello di sinistra

Notare che qui la stampa del predicato di destra avviene prima di quella di sinistra (a causa della collezione a posteriori).
