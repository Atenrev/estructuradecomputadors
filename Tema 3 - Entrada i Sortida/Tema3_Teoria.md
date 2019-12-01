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

