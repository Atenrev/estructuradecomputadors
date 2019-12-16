# Entrada i escriptura

Flux: del dispositiu a la CPU i de la CPU a la memòria.
DMA: se salta el pas de passar per la CPU i la dada va directament a la memòria.

```
		interfície 							interfície
		normalizada							específica
CPU	---	bus sistema ---	| Controlador E/S |	----------------------	Dispositiu
					|	Reg dades		|
					|	Reg estat		|
					|	Comanda control	|
					|	Lògica 			| (si és per aquest controlador o no)
```

**Exemple**:

```assembly
; Es mou el contingut d'un registre del controlador a un de la CPU
MOV R1, [FF0Ah]
```

L'entrada i sortida pot presentar-se de dues maneres: mapejada o separada.

##  Mapejada

Les direccions es troben al mateix espai de direccionament.

```assembly
MOV port, R1
MOV [00FF], R1
```

## Separada

Les direccions no es troben en el mateix espai de memòria.

```assembly
MOV port, R1
; L'IN i l'OUT són l'equivalent al MOV per entrada i sortida
IN/OUT [00FF], R1
MOV [00FF], R1
```

## Tècnica E/S programada

Indicar comanda --> Llegir estat --> Dispositiu llest? (si no, es torna a llegir estat) --> Transferència --> Comptadors --> Fi? (si no, es torna al principi)

```ASSEMBLY
MOV AL, B0h
MOV [DIR COM], AX
MOV AX, [DIR ESTAT]
AND AX, 8
JZ Espera
MOV AX, [DIR DADES]
MOV [DIR MEM], AX
ADD DIR MEM, 2
DEC COMPTADOR
```

 

FETCH --> DEC --> CERCAR OPERACIÓ --> EXEC --> COMPROVAR SI HI HA INTERRUPCIÓ

Si n'hi ha:

​	   (Hardware)

1. Detectar interrupció

2. Reconèixer interrupció --> Vector interrupció (identificador de qui l'ha fet)

3. Salvar estat del procés i PC

4. Calcular direcció de la RTI (rutina de tractament d'interrupció) i posar-la al PC

   (Software)

5. Salvar registres del programa

6. Comprovar estat del dispositiu d'E/S

7. Transferència de la dada

8. Recuperar registres del programa

9. RETI (retorn)

   (Hardware)

10. Recuperar estat i PC

### RTI :

```assembly
PUSH ESI
PUSH AL
MOV ESI, [DIR (index)]
IN MOV AL, [Reg-dades]
MOV [9000h+ESI (ESI)], AL
ADD ESI, 1
MOV [DIR], ESI
POP AL
POP ESI
RETI
```

## Polling

```assembly
IN AL, [estat_D1]
AND AL, mascara%00010000
JNZ D1
MOV AL, [estat_D2]
...
```

## Daisy-chain

Cada dispositiu posarà el seu identificador al vector d'interrupcions i el bolcarà al bus de dades i activarà el bus d'interrupcions. 

## Interrupcions independents

Hi ha tantes línies d'interrupció i INT A (acknowledgement) com dispositius hi ha.

## Control d'interrupcions

Hi haurà enmig un controlador d'interrupcions amb un codificador al qual arribaran les senyals d'interrupció de cada dispositiu. Compta amb un buffer que emmagatzema els dispositius que han interromput. Hi ha un decodificador que, amb el buffer i la INT A farà un acknoledge a qui ha interromput i treurà el vector d'interrupcions al bus de dades, que és per on li arribarà a la CPU.

Hi ha una TVI (taula de vectors d'interrupció) on es guarden les direccions de les RTI de cada dispositiu, que seran a la memòria. La CPU tindrà on comença la TVI i, amb el vector d'interrupcions, dirà d'on agafar la direcció de la rutina del dispositiu que ha fet la interrupció.

## Programació del DMA

Fetch --> Decodificar --> BO --> Execucució --> Gestor d'operands --> (interrupció) o al principi

```assembly
MOV [0200h], 10h
MOV [0201h], 20
MOV [0202h], F0h
```

## Exercici 4

Disc --> Mem (A000h)

0Fh	comanda

DMA
0208h	DirHigh
0209h	DirLow
020Ah	ComptadorHigh
020Bh	ComptadorLow
020Ch	Control

Contr Disc
0204h	D
0205h	E
0206h	C

```ASSEMBLY
MOV [0208h], A0h
MOV [0209h], 00h
MOV [020Ah], 20h ; (de 2^13==8192)
MOV [020Bh], 00h
MOV [020Ch], 0Fh
```

500ns programació
500ns fi
Tassa de transferència 200 MB/s

Total: 8192B/200MB/s+500ns+500ns=40,06 microsegons

CPU --> 500ns + 500ns + temps d'ocupació del bus

tcessió+trecuperació = 4ns
ttransf = 2ns
2000
2000 (6ns)

## Exercici 16?

tc+tr = 5ns
ttransf = 2.5ns
8000
8 dades

(5ns + 8*2.5ns) * 1000