# Lanciare una query in CPS

Per lanciare una query nel PBT per `imp` fare:

1. Eseguire `chmod +x executeQuery.pro`

2. Lanciare `./executeQuery.pro M Q D C G` dove
   
   - `M` indica se usare la versione mutante o meno. Usando `M = N` con $N>0$ si attiva la $N$-esima versione mutante, con `M = 0` si usa la versione corretta. 
   
   - `Q` indica la query da eseguire. LA query viene cercata nel file `query.pro`.
   
   - `D` indica la dimensione di generazione
   
   - `C` indica il certificato da usare. `C = 0` usa `qheight`, `C = 1` usa `qsize`, `C = 2` usa `pairing(qheight, qsize)`.
   
   - `G` è il gas da usare.

Per lanciare un pacchetto di query pre fatto, fare:

1. Eseguire `chmod +x executeQuery.pro`

2. Eseguire `chmod +x testQuery.pro`

3. Lanciare `./testQuery.pro M` dove `M`indica se usare la versione mutante o meno. Usando`M = 1`si attiva la versione mutante, con`M = 0` si usa la versione corretta.
