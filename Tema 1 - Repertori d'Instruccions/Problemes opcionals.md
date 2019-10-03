# Problemes opcionals

## Problema 9

### a)

``` assembly
MOV R1, 1
CMP R2, 0
JE FI
CMP R4, R5
JLE FI
MOV R1, 0
```

### b)

``` assembly
MOV R0, 0
MOV R1, 1
CMP R2, 0
JNE 6
INC R0 
CMP R4, R5
JG 9
INC R0
CMP R0, 1
JGE FI
MOV R1, 0
```

## Problema 10

### a)

``` C
num = 6;
count = 1;
fact = 1;
while (count < num) {
	count = count + 1;
	fact = fact * count;
}
```

``` ASSEMBLY
MOV EAX, 1
MOV ESI, 1
CMP ESI, 6
JGE FI
MUL EAX, ESI
INC ESI
JMP BUCLE
```

### b)

``` C
num = 10;
fib[0] = 1;
fib[1] = 1;
for (i=2;i<num;i++) {
	fib[i]=fib[i-1]+fib[i-2];
}
```

``` assembly
MOV ESI, 8
CMP ESI, 40
JGE FI
MOV EAX, fib[ESI-4]
ADD EAX, fib[ESI-8]
MOV fib[ESI], EAX
JUMP BUCLE
```

## Problema 11

```  C
int A[4][4], B[4][4], C[4][4];
int i, j, k;
for (i=0; i <4; i++)
{
    for (j=0; j <4; j++)
    {
        C[i][j]=0;
        for (k=0; k <4; k++)
        	C[i][j]=C[i][j]+A[i][k]*B[k][j];
    }
} 
```

``` assembly
INI: 		MOV ESI, 0
BUCLE_i: 	CMP ESI, 4
 			JGE FI_i
 			MOV EDI, 0
BUCLE_j: 	CMP EDI, 4
 			JGE FI_j
 			# ESI*4+EDI
 			# Calcula a partir de l'ESi i de l'EDI el proper índex --> EBX. 
 			CALL Calc_Index
 			MOV [Posi], EBX
 			MOV C[EBX],0
 			MOV ECX, 0
BUCLE_k: 	CMP ECX, 4
 			JGE Fi_k
 			PUSH EDI
 			MOV EDI, ECX
 			# ESI*4+ECX --> EBX
 			CALL Calc_Index
 			POP EDI
			MOV EAX, ____A[EBX]____
 			PUSH ESI
 			MOV ESI, ECX
 			# ECX*4+EDI --> EBX
 			CALL Calc_Index
 			POP ESI
 			MOV ____EDX____, B[EBX]
 			# Multiplicar A * B
 			MUL EDX, ____EAX____
 			# Recuperem la posició inicial
 			MOV EBX, [Posi]
 			# Sumar C + (A*B)
			ADD C[EBX], ____EDX_____
 			INC ECX
			JMP BUCLE_k
FI_k: 		INC EDI
 			JMP BUCLE_j
FI_j: 		INC ESI
 			JMP BUCLE_i
FI_i: 		END

Calc_Index: PUSH EAX
 			MOV EBX, ESI
 			SHL EBX, 4
 			MOV EAX,EDI
 			SHL EAX, 2
 			ADD EBX, EAX
 			POP EAX
 			RET
```

## Problema 12

| M    | Programa    | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    |      | A     | X    | SP   | PC   |
| ---- | ----------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
|      |             | 2    | 4    | 0    | 1    | 2    | 8    | 0    | 0    | 0    | 0    |      | 3     | 0    | 8    | 110  |
| 110  | LDAA #2     |      |      |      |      |      |      |      |      |      |      |      | 2     |      |      | 112  |
| 112  | STAA 3      |      |      |      | 2    |      |      |      |      |      |      |      | read  |      |      | 114  |
| 114  | LDX 1       |      | read |      |      |      |      |      |      |      |      |      |       | 4    |      | 116  |
| 116  | STAA 0, X   |      |      |      |      | 2    |      |      |      |      |      |      | read  |      |      | 118  |
| 118  | ADDA [1]    |      | read |      |      | read |      |      |      |      |      |      | 2+2=4 |      |      | 11A  |
| 11A  | STAA [0], X | read |      |      |      |      |      | 4    |      |      |      |      |       |      |      | 11C  |
| 11C  | ADDA #1     |      |      |      |      |      |      |      |      |      |      |      | 4+1=5 |      |      | 11E  |
| 11E  | STX [0, X]  |      |      | 4    |      | read |      |      |      |      |      |      |       |      |      | 120  |
| 120  | JSR #200    |      |      |      |      |      |      |      | 122  |      |      |      |       |      | 7    | 200  |
|      |             |      |      |      |      |      |      |      |      |      |      |      |       |      |      |      |
|      |             |      |      |      |      |      |      |      |      |      |      |      |       |      |      |      |
| 208  | LDDA #0     |      |      |      |      |      |      |      |      |      |      |      | 0     |      |      | 210  |
| 210  | RET         |      |      |      |      |      |      |      |      |      |      |      |       |      | 8    | 122  |
|      |             |      |      |      |      |      |      |      |      |      |      |      |       |      |      |      |
|      |             |      |      |      |      |      |      |      |      |      |      |      |       |      |      |      |

## Problema 13

### a)

#### Arquitectura 1

| Tipus d'Instrucció | Format | Mida (bits) |
| ------------------ | ------ | ----------- |
|                    |        |             |
|                    |        |             |

### Arquitectura 2

| Tipus d'Instrucció | Format | Mida (bits) |
| ------------------ | ------ | ----------- |
|                    |        |             |
|                    |        |             |
|                    |        |             |

### Arquitectura 3

| Tipus d'Instrucció | Format | Mida (bits) |
| ------------------ | ------ | ----------- |
|                    |        |             |
|                    |        |             |
|                    |        |             |

### b) A = (E * (B-C)) / ( E-D)

#### Arquitectura 1

|      | Instrucció | N. bytes instrucció | Accessos (inst.) | Accessos (dades) | Temps total |
| ---- | ---------- | ------------------- | ---------------- | ---------------- | ----------- |
| 1    | LOAD E     | 4                   | 2                | 2                | 40ns        |
| 2    | SUB D      | 4                   | 2                | 2                | 40ns        |
| 3    | STORE A    | 4                   | 2                | 2                | 40ns        |
| 4    | LOAD B     | 4                   | 2                | 2                | 40ns        |
| 5    | SUB C      | 4                   | 2                | 2                | 40ns        |
| 6    | MUL E      | 4                   | 2                | 2                | 60ns        |
| 7    | DIV A      | 4                   | 2                | 2                | 80ns        |
| 8    | STORE A    | 4                   | 2                | 2                | 40ns        |
|      | Total:     | 32                  | 16               | 16               | 380ns       |

