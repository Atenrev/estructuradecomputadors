## Problema 4

```C
N = 6;
sum = 0;
partial_sum = 0;
i = 0;
while ( i < N) {
    partial_sum = partial_sum + V[i];
    i = i + 1;
}
sum = partial_sum;
```
### Solució

``` assembly
		MOV ESI, 0
		MOV EAX, 0
BUCLE:	CMP ESI, 24
		JGE END
		ADD EAX, V[ESI]
		ADD ESI, 4
		JMP BUCLE
END:	MOV [sum], EAX	
```

## Problema 5

```c
int A[4][4], B[4][4], C[4][4];
int i, j, k;
for (i=0; i < 4; i++)
{
    for (j=0; j < 4; j++)
    {
    	C[i][j]=A[i][j]+B[i][j];
    }
} 
```

### Solució

```assembly
INI: 		MOV ESI, 0
BUCLE_i: 	CMP ESI, 4
 			JGE FI_i
 			MOV EDI, 0
BUCLE_j: 	CMP EDI, 4
 			JGE FI_j
			CALL Calc_Index
 			MOV EAX, A[EBX]
 			ADD EAX, B[EBX]
 			MOV C[EBX], EAX
			INC EDI
			JMP BUCLE_j
FI_j: 		INC ESI
 			JMP BUCLE_i
FI_i: 		END

Calc_Index:	PUSH EAX
 			MOV EBX, ESI
 			SHL EBX, 4
 			MOV EAX,EDI
 			SHL EAX, 2
 			ADD EBX, EAX
 			POP EAX
 			RET
```

## Problema 6

```c
// 16 registres de 6 bytes
int Vector[20];
bool capicua = true;

for (int i = 0; i < 10; i++) {
    if (Vector[i] != Vector[19-i]) {
        capicua = false;
        break;
    }
}
```

``` assembly
INI:	MOV R0, 1	
		MOV ESI, 0
BUCLE:	CMP ESI, 10
		JGE END
		MOV R1, Vector[ESI*6]
		MOV R2, Vector[152-ESI*6]
		CMP R1, R2
		JNE NCIC
		INC ESI
NCIC:	MOV R0, 0
END:	END
		
```

## Problema 8

| Mem  | Programa     | 0    | 1         | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    | A    | X        | PC   | SP   | DIR  |
| ---- | ------------ | ---- | --------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | -------- | ---- | ---- | ---- |
|      |              | 0    | -2        | 3    | 4    | 1    | 3    | -2   | 1    | 8    | 0    | 5    | 0        | 40h  | 08   | ---  |
| 40h  | ADDA 1       |      | read      |      |      |      |      |      |      |      |      | 3    |          | 42h  |      | 1    |
| 42h  | PSHA         |      |           |      |      |      |      |      | 3    |      |      | read |          | 43h  | 07   | 7    |
| 43h  | JSR 60H      |      |           |      |      |      |      | 45h  |      |      |      |      |          | 60h  | 06   | 6    |
| ...  |              |      |           |      |      |      |      |      |      |      |      |      |          |      |      |      |
| 60h  | LDX 7        |      |           |      |      |      |      |      | read |      |      |      | 3        | 62h  |      | 7    |
| 62h  | LDA -2, X    |      | read      |      |      |      |      |      |      |      |      | -2   | read-2=1 | 64h  |      | 1    |
| 64h  | ADDA [1], X  |      | read,read |      |      |      |      |      |      |      |      | -4   | read-2=1 | 66h  |      | 1    |
| 66h  | ADDA #1      |      |           |      |      |      |      |      |      |      |      | -3   |          | 68h  |      | -    |
| 68h  | STAA [-1, X] |      |           | read | -3   |      |      |      |      |      |      |      | read-1=2 | 6Ah  |      | 3    |
| 6Ah  | RET          |      |           |      |      |      |      | read |      |      |      |      |          | 45h  | 07   | 6    |
| ...  |              |      |           |      |      |      |      |      |      |      |      |      |          |      |      |      |
| 45h  | PULA         |      |           |      |      |      |      |      | read |      |      | 3    |          |      | 08   | 7    |
| 46h  | HALT         |      |           |      |      |      |      |      |      |      |      |      |          |      |      |      |

## Problema 14

### a)

``` assembly
	MOV EAX, A
	MOV EBX, B
	CMP EAX, EBX
	JE FI
	MOV C, 1
FI:
```

### b)

``` assembly
	MOV ESI, 0
	MOV ECX, n
	SHL ECX, 2
BUCLE:
	CMP ESI, ECX
	JGE END
	MOV EAX, A[ESI]
	MOV EBX, B[ESI]
	ADD EAX, EBX
	MOV C[ESI], EAX
	ADD ESI, 4
    JMP BUCLE
END:
```

## Problema 15

``` assembly
	MOV RSI, 0
	MOV RCX, n
	SHL RCX, 3
BUCLE:
	CMP RSI, RCX
	JGE END
	MOV RAX, A[RSI]
	MOV RBX, B[RSI]
	ADD RAX, RBX
	MOV C[RSI], RAX
	ADD RAX, 8
	JMP BUCLE
END:
```

## Problema 16

### a)

|      | Programa    | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    |      | A      | X    | SP   | PC   |
| ---- | ----------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ------ | ---- | ---- | ---- |
|      |             | 0    | 5    | 3    | 3    | 1    | 2    | 2    | 0    | 8    | 0    |      | 5      | 0    | 8    | 100  |
| 100  | LDAA #4     |      |      |      |      |      |      |      |      |      |      |      | 4      |      |      | 102  |
| 102  | STAA 4      |      |      |      |      | 4    |      |      |      |      |      |      | R      |      |      | 104  |
| 104  | LDX 3       |      |      |      | R    |      |      |      |      |      |      |      |        | 3    |      | 106  |
| 106  | STAA 0, X   |      |      |      | 4    |      |      |      |      |      |      |      | R      |      |      | 108  |
| 108  | ADDA [1]    |      | R    |      |      |      | R    |      |      |      |      |      | 4+2=6  |      |      | 110  |
| 110  | STAA [6], X |      |      |      |      |      | 6    | R    |      |      |      |      |        |      |      | 112  |
| 112  | ADDA #1     |      |      |      |      |      |      |      |      |      |      |      | 6+1=7  |      |      | 114  |
| 114  | STX [4, X]  | 3    |      |      |      |      |      |      | R    |      |      |      |        | R    |      | 116  |
| 116  | JSR 200     |      |      |      |      |      |      |      | 118  |      |      |      |        |      | 7    | 200  |
|      | ...         |      |      |      |      |      |      |      |      |      |      |      |        |      |      |      |
| 206  | ADDA 0      | R    |      |      |      |      |      |      |      |      |      |      | 7+3=10 |      |      | 208  |
| 208  | RET         |      |      |      |      |      |      |      | R    |      |      |      |        |      | 8    | 118  |

