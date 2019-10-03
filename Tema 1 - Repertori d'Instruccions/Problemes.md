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

