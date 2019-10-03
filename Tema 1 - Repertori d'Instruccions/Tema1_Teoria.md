## Estructura bàsica

Cada màquina té el seu repertori d'instruccions. L'estructura bàsica de les instruccions és la següent:

```
Codi d'operació		Operadors
```

Exemple:

```
size = 5;
MOV [size], 5 --> 000101010...
```

### Esquema 

```
	CPU - Mem
	  \	  /
	   E/S
```

Busos: 

- Bus de direcció
- Bus de dades
- Bus de control (si s'escriu o es llegeix)

### Fluxe

1. Fetch instrucció: Portar la instrucció de la memòria a la CPU. 
2. Decodificador instrucció 
3. Fetch operació
4. Execució
5. Store operand. Es torna al punt 1.

Del program counter (PC) s'agafa la direcció de la següent instrucció a executar, es porta al Memory Address Register (MAR) i d'aquí es porta al bus de direccions. De la memòria s'agafa la instrucció, es posa al bus de dades i es posa al Memory Buffer Register (MBR), on acabarà al Instructions Register (IR).

## Tipus d'instruccions

### Funcions de transferència

- MOV

  ​	NO FER --> MOV [v1], [v2]. Poc rendiment.

- LOAD

- STORE

### Operacions Aritmètiques

- CMP (compare): En el fons és una resta.
- INC
- DEC
- ADD
- SUB

### Operacions Lògiques

- AND
- OR
- XOR
- NOT
- ...

### Entrada / Sortida (E/S)

Depenent d'on es transfereixi, es tracta de funcions de transferència.

- IN
- OUT

### Control de flux

#### Sense retorn

Es fa el salt i es continua el flux des d'allà.

##### Salt incondicional

- JMP direcció	

##### Salt condicional

- JE (jump equal) etiqueta
- JZ (jump si és 0)
- JNE
- JL (jump less)
- JG 
- JLE
- JGE

#### Amb retorn

Es fa el salt, es continuen les instruccions i, en algun moment, es torna per on s'anava. (Funcions)

- CALL (intel) / JSR: Intel utilitza el que anomena SP (Stack Pointer), una pila on va guardant les adreces d'on ha de tornar. La pila es guarda en la memòria i el registre SP guarda la direcció on s'ha de guardar la propera direcció de retorn a la memòria (aquest va actualitzant-se decrementant, SP-1), que serà PC+1. Per llegir el retorn, es llegeix SP+1 i es posa al PC.
  - RET (return): Indica que acaba la funció i es torna a SP+1. El SP s'actualitza posteriorment.

## Arrays

Indexat:

```
MOV R0, 2
MOV R1, A[R0]
```

on A és la direcció de començament i R0 l'índex al qual accedeixes

Registres d'intel:

- AX: registre general
  - RAX --> 64 bits
  - EAX --> 32 bits
  - AX --> 16 bits
  - AL i AH --> 8 bits
- BX: per a punters
- CX: per a comptadors
- DX: de suport
- ...
- SI (source index)
- DI (destination index)

## Problema 3

```c
int A[32], B[32], C[32];
int i;
for (i=0; i <32; i++)
{
	C[i]=A[i]+B[i]
} 
```

```assembly
INI:	MOV ESI, 0
BUCLE:	CMP ESI, 128
		JGE FI
		MOV EAX, B[ESI] 
		ADD EAX, A[ESI]
		MOV C[ESI], EAX 
		ADD ESI, 4
		JMP BUCLE
FI:
```

## Modes direccionament

### Immediat

| CODI D'OPERACIÓ | ...  | OPERAND |


```assembly
intel:	MOV R1, 6
HC12:	LDAA #6
```

### Registre / directe amb registre

| CODI D'OPERACIÓ | OPERAND DESTÍ | OPERAND |

```ASSEMBLY
MOV R1, R2
MUL EAX, EDX
```

### Directe

| CODI D'OPERACIÓ | DIRRECCIÓ OPERAND | ... |

| CODI D'OPERACIÓ | REGISTRE | DIRECCIÓ OPERAND |

```assembly
HC12:	17
```

### Indirecte per registre

En el registre tenim una direcció de memòria de l'operand. S'utilitza per treballar amb apuntadors.

| CODI D'OPERACIÓ | REGISTRE | ... |	El registre té la direcció de l'operand, llavors va a la direcció en memòria i s'obté d'ella.

```assembly
intel:	MOV EAX, [EBX]
HC12:	LDAA X
```

### Indirecte

No s'utilitzan registres, a l'operand es té una direcció d'una altra direcció.

| CODI D'OPERACIÓ | DIR |	Es va a la direcció 20 de la memòria, on hi haurà la direcció de l'operand.

```assembly
LDAA (20)
```

### Relatiu al PC

En comptes d'utilitzar una direcció, utilitzes el Program Counter.

| CODI D'OPERACIÓ | DESPLAÇAMENT |	El desplaçament se sumarà al PC, que dirà d'on agafar l'operand a la memòria.

### Amb registre base

Es fa servir amb structs.

| CODI D'OPERACIÓ | REGISTRE BASE | DEPLAÇAMENT |	Es va a la memòria al registre base + desplaçament

```assembly
MOV EAX, [EBX+5]
```

#### Exemple amb llista

X = número de 4 bits.

| LLISTA: X | SEG1: X | SEG2: X |
| --------- | ------- | ------- |
| SEG1      | SEG2    | NULL    |

```assembly
		MOV EAX, 0
		LEA EBX, lista		--> Posa la direcció efectiva de la variable en el registre
SIG:	ADD EAX, [EBX]
		MOV EBX, [EBX+4]	--> Llegeix la direcció del següent element de la llista
		CMP EBX, NULL
		JNE SIG
```

### Indexat

| CODI D'OPERACIÓ | DIRECCIÓ BASE | INDEX |	Es va a la direcció de base, se li suma l'índex i s'agafa el valor de la memòria.

```ASSEMBLY
intel:	MOV EAX, A[4]
HC12:	4,X
```

### Indirecte indexat

| CODI D'OPERACIÓ | DIRECCIÓ | REGISTRE |	--> Primer es va a la memòria, s'agafa la direcció, se suma al registre (s'indexa) i es torna a la memòria a agafar l'operand.

```assembly
LDAA (2), X
```

### Indexat indirecte

Es té un array d'apuntadors.

| CODI D'OPERACIÓ | DIRECCIÓ | REGISTRE |	S'agafa la direcció, s'indexa, es va a la memòria, s'agafa la direcció de l'operand i es guarda al registre (s'indexa) i es torna a la memòria a agafar l'operand.

```ASSEMBLY
LDAA (2,X)
```

## Problema 7

| MEM  | PROGRAMA     | 0    | 1          | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    | A            | X    | PC          | SP   | DIR  |
| ---- | ------------ | ---- | ---------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ------------ | ---- | ----------- | ---- | ---- |
|      |              | 0    | -2         | 3    | 4    | 1    | 3    | -2   | 1    | 5    | 0    | 5            | 0    | 40h         | 08   | ---- |
| 40h  | ADDA 1       |      | leer       |      |      |      |      |      |      |      |      | 5-2=3        |      | 42h         |      | 1    |
| 42h  | PSHA         |      |            |      |      |      |      |      | 3    |      |      |              |      | 44h         | 07   | 7    |
| 44h  | JSR 60h      |      |            |      |      |      |      | 46h  |      |      |      |              |      | 46h --> 60h | 06   | 6    |
| 60h  | LDX 7        |      |            |      |      |      |      |      | leer |      |      |              | 3    | 60h         |      | 7    |
| 62h  | LDA -2, X    |      | leer       |      |      |      |      |      |      |      |      | -2           |      | 64h         |      | 1    |
| 64h  | ADDA [1], X  |      | leer, leer |      |      |      |      |      |      |      |      | -2+(-2)-4=-4 |      | 66h         |      | 1    |
| 66h  | ADDA #1      |      |            |      |      |      |      |      |      |      |      | -4+1=-3      |      | 68h         |      | -    |
| 68h  | STAA [-1, X] |      |            | leer | -3   |      |      |      |      |      |      |              |      | 6Ah         | 07   | 3    |
| 6Ah  | RET          |      |            |      |      |      |      |      |      |      |      |              |      | 46h         | 07   | 6    |
| 46h  | PULA         |      |            |      |      |      |      |      | leer |      |      | 3            |      | 48h         | 08   | 7    |

## Problema 17

**a)**

| Arquitectura | Instrucció       | Funcionalitat          |
| ------------ | ---------------- | ---------------------- |
| 1            | LOAD $1000       | Acc <- MEM($1000)      |
| 1            | LOADi #7         | Acc <- 7               |
| 2            | ADD R0, R2       | R0 <- (R0) + (R2)      |
| 2            | ADDm R0, 1000    | R0 <- (R0) + Mem(1000) |
| 2            | ADDi R0, #$F     | R0 <- (R0) +$F         |
| 3            | ADD R0, R3, R7   | R0 <- (R3) + (R7)      |
| 3            | ADDi R0, R3, #15 | R0 <. (R3) - 15        |

**b)**

1:
COP M --> 4 + 20
COP I --> 4 + 20

| Arquitectura              | 1    | 2    | 3    |
| ------------------------- | ---- | ---- | ---- |
| Espai total adreçable     |      |      |      |
| Rang de constants tipus I |      |      |      |

**c)**

