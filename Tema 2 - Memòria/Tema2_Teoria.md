Tenim 16Mb -> Necessitem 24 bits de bus per accedir-hi a totes les direccions.
Volem 1MB
Tenim xips de 128kbytes

Necessitem un bus de 17 bits per accedir a un xip i un de 8 per obtenir les dades.
Per 1MB necessitem 8 xips.

Està el temps d'accés a la memòria i el d'obtennció de la dada. A més, s'ha de sumar el temps del cicle.

## Problema 1

### Apartat a

#### a.1)



#### a.2)



#### a.3)



#### a.4)



### Apartat b

#### b.1)



#### b.2)

CS0 = (A23·!A22·A21·!A20)·!A19·!A18·!A0
CS1 = (A23·!A22·A21·!A20)·!A19·!A18·A0

#### b.3)



#### b.4)



## Organització memòria

Si volem emmagatzemar dades de 16 bits, podem concatenar 2 xips de 128kb de 8 bits de paraula, per exemple. Hi hauria 2 columnes de xips.

També podem concatenar els xips per augmentar el tamany de la memòria, de manera que, en comptes de tenir una paraula de 16 bits, en tindrem una de 8 però 256kb de paraules adreçables.

Pot haver-hi interleaving, que és la intercalació entre n xips de la posició del següent element. Si hi ha interleaving de 2 en un bloc de 4 xips, la primera direcció correspondrà al primer xip, la segona al segon, la tercera al primer i així. L'interleaving s'implementa utilitzant l'A0 en cas de ser de 2, A0 i A1 en cas de ser de 4, etc.

## Memòria dinàmica (DRAM)

Aquestes memòries necessiten refrescar-se, ho fan de fila en fila activant el RAS, en cicles de refresc. Mentre està en refresc, el processador no hi poden accedir, els cicles de refresc tenen major prioritat.

El bus de dades només té un 1 bit, per tant, haurien d'haver 8 xips si es vulgués una dada d'1 byte.

Aquests xips tenen un decodificador, al qual li entren 5 bits, que selecciona la fila; i un altre igual que selecciona la columna.

RAS (Row Access Site): Senyal que indica l'activació la fila del xip
CAS (Column Access Site): Senyal que indica l'activació la columna del xip

Llavors, al multiplexor se li passa la senyal fila/!col per deixar passar les línies de fila o de columna.

