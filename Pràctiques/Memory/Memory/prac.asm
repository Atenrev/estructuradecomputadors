.586
.MODEL FLAT, C


; Funcions definides en C
printChar_C PROTO C, value:SDWORD
printInt_C PROTO C, value:SDWORD
clearscreen_C PROTO C
clearArea_C PROTO C, value:SDWORD, value1: SDWORD
printMenu_C PROTO C
gotoxy_C PROTO C, value:SDWORD, value1: SDWORD
getch_C PROTO C
printBoard_C PROTO C, value: DWORD
initialPosition_C PROTO C
rand PROTO C, value:SDWORD

.code   
   
;;Macros que guarden y recuperen de la pila els registres de proposit general de la arquitectura de 32 bits de Intel  
Push_all macro
	push eax
   	push ebx
    push ecx
    push edx
    push esi
    push edi
endm


Pop_all macro
	pop edi
   	pop esi
   	pop edx
   	pop ecx
   	pop ebx
   	pop eax
endm
   
   
public C posCurScreenP1, getMoveP1, moveCursorP1, movContinuoP1, openP1, openContinuousP1, setupBoard
                         

extern C opc: SDWORD, row:SDWORD, col: BYTE, carac: BYTE, carac2: BYTE, gameCards: BYTE, tauler: BYTE, indexMat: SDWORD
extern C rowScreen: SDWORD, colScreen: SDWORD, RowScreenIni: SDWORD, ColScreenIni: SDWORD
extern C rowIni: SDWORD, colIni: BYTE
extern C gameCards: BYTE, firstVal: SDWORD, firstCol: BYTE, firstRow: SDWORD, cardTurn: SDWORD, totalPairs: SDWORD, totalTries: SDWORD
extern C cards: BYTE

;****************************************************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situar el cursor en una fila i una columna de la pantalla
; en funci� de la fila i columna indicats per les variables colScreen i rowScreen
; cridant a la funci� gotoxy_C.
;
; Variables utilitzades: 
; Cap
; 
; Par�metres d'entrada : 
; Cap
;    
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy proc
   push ebp
   mov  ebp, esp
   Push_all

   ; Quan cridem la funci� gotoxy_C(int row_num, int col_num) des d'assemblador 
   ; els par�metres s'han de passar per la pila
      
   mov eax, [colScreen]
   push eax
   mov eax, [rowScreen]
   push eax
   call gotoxy_C
   pop eax
   pop eax 
   
   Pop_all

   mov esp, ebp
   pop ebp
   ret
gotoxy endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar un car�cter, guardat a la variable carac
; en la pantalla en la posici� on est� el cursor,  
; cridant a la funci� printChar_C.
; 
; Variables utilitzades: 
; carac : variable on est� emmagatzemat el caracter a treure per pantalla
; 
; Par�metres d'entrada : 
; Cap
;    
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch proc
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perqu�
   ;les funcions de C no mantenen l'estat dels registres.
   
   Push_all

   ; Quan cridem la funci�  printch_C(char c) des d'assemblador, 
   ; el par�metre (carac) s'ha de passar per la pila.
 
   xor eax,eax
   mov  al, [carac]
   push eax 
   call printChar_C
 
   pop eax
   Pop_all

   mov esp, ebp
   pop ebp
   ret
printch endp
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un car�cter de teclat   
; cridant a la funci� getch_C
; i deixar-lo a la variable carac2.
;
; Variables utilitzades: 
; carac2 : Variable on s'emmagatzema el caracter llegit
;
; Par�metres d'entrada : 
; Cap
;    
; Par�metres de sortida: 
; El caracter llegit s'emmagatzema a la variable carac
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch proc
   push ebp
   mov  ebp, esp
    
   Push_all

   call getch_C
   
   mov [carac2],al
   
   Pop_all

   mov esp, ebp
   pop ebp
   ret
getch endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posicionar el cursor a la pantalla, dins el tauler, en funci� de
; les variables (row) fila (int) i (col) columna (char), a partir dels
; valors de les constants RowScreenIni i ColScreenIni.
; Primer cal restar 1 a row (fila) per a que quedi entre 0 i 3 
; i convertir el char de la columna (A..D) a un n�mero entre 0 i 3.
; Per calcular la posici� del cursor a pantalla (rowScreen) i 
; (colScreen) utilitzar aquestes f�rmules:
; rowScreen=rowScreenIni+(row*2)
; colScreen=colScreenIni+(col*4)
; Per a posicionar el cursor cridar a la subrutina gotoxy.
;
; Variables utilitzades:	
; row       : fila per a accedir a la matriu gameCards/tauler
; col       : columna per a accedir a la matriu gameCards/tauler
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
;
; Par�metres d'entrada : 
; Cap
;
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
posCurScreenP1 proc
    push ebp
	mov  ebp, esp
	PUSH EAX
	PUSH EBX

	; rowScreen
	MOV EAX, [row]
	DEC EAX
	; colScreen
	xor ebx, ebx
	MOV BL, [col]
	SUB EBX, 65

	SHL EAX, 1
	ADD EAX, RowScreenIni
	SHL EBX, 2
	ADD EBX, ColScreenIni

	MOV [rowScreen], EAX
	MOV [colScreen], EBX

	call gotoxy

	POP EBX
	POP EAX
	mov esp, ebp
	pop ebp
	ret
posCurScreenP1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un car�cter de teclat   
; cridant a la subrutina getch
; Verificar que solament es pot introduir valors entre 'i' i 'l', 
; o les tecles espai ' ', o 's' i deixar-lo a la variable carac2.
; 
; Variables utilitzades: 
; carac2 : variable on s'emmagatzema el car�cter llegit
; 
; Par�metres d'entrada : 
; Cap
;    
; Par�metres de sortida: 
; El car�cter llegit s'emmagatzema a la variable carac2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getMoveP1 proc
   push ebp
   mov  ebp, esp
   PUSH EAX

   ; es guarda a carac2
   BUCLE:
   call getch
   MOV AL, [carac2]
   ; 105 <= AL <= 108 || AL == 115 || AL = 32 
   CMP AL, 105
   JL NEXT_CON
   CMP AL, 108
   JLE FI
   NEXT_CON:
   CMP AL, 115
   JE FI
   CMP AL, 32
   JE FI
   JMP BUCLE

   FI:
   POP EAX
   mov esp, ebp
   pop ebp
   ret
getMoveP1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actualitzar les variables (row) i (col) en funci� de 
; la tecla premuda que tenim a la variable (carac2)
; (i: amunt, j:esquerra, k:avall, l:dreta).
; Comprovar que no sortim del tauler, (row) i (col) nom�s poden 
; prendre els valors [1..4] i [A..D]. Si al fer el moviment es surt 
; del tauler, no fer el moviment.
; No posicionar el cursor a la pantalla, es fa a posCurScreenP1.
; 
; Variables utilitzades: 
; carac2 : car�cter llegit de teclat
;          'i': amunt, 'j':esquerra, 'k':avall, 'l':dreta
; row : fila del cursor a la matriu gameCards.
; col : columna del cursor a la matriu gameCards.
;
; Par�metres d'entrada : 
; Cap
;
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursorP1 proc
   push ebp
   mov  ebp, esp 
   PUSH EAX
   PUSH EBX

   MOV AL, [carac2]
   CMP AL, 105
   JE AMUNT
   CMP AL, 106
   JE ESQUERRA
   CMP AL, 107
   JE AVALL
   CMP AL, 108
   JE DRETA

   JMP FI

   AMUNT:
   MOV EBX, [row]
   DEC EBX
   CMP EBX, 1
   JL FI
   MOV [row], EBX
   JMP MOURE

   ESQUERRA:
   XOR EBX, EBX
   MOV BL, [col]
   DEC EBX
   CMP EBX, 65
   JL FI
   MOV [col], BL
   JMP MOURE

   AVALL:
   MOV EBX, [row]
   INC EBX
   CMP EBX, 4
   JG FI
   MOV [row], EBX
   JMP MOURE

   DRETA:
   XOR EBX, EBX
   MOV BL, [col]
   INC EBX
   CMP EBX, 68
   JG FI
   MOV [col], BL
   JMP MOURE

   MOURE:
   CALL posCurScreenP1

   FI: 
   POP EBX
   POP EAX
   mov esp, ebp
   pop ebp
   ret
moveCursorP1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment continuo. 
;
; Variables utilitzades:
;		carac2   : variable on s�emmagatzema el car�cter llegit
;		row      : fila per a accedir a la matriu gameCards
;		col      : columna per a accedir a la matriu gameCards
; 
; Par�metres d'entrada : 
; Cap
;
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
movContinuoP1 proc
	push ebp
	mov  ebp, esp
	PUSH EAX

	BUCLE:
	CALL getMoveP1
	MOV AL, [carac2]
	CMP AL, 115
	JE FI
	CMP AL, 32
	JE FI
	CALL moveCursorP1
	JMP BUCLE

	FI:
	POP EAX
	mov esp, ebp
	pop ebp
	ret
movContinuoP1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Calcular l'�ndex per a accedir a les matrius en assemblador.
; gameCards[row][col] en C, �s [gameCards+indexMat] en assemblador.
; on indexMat = row*8 + col (col convertir a n�mero).
;
; Variables utilitzades:	
; row       : fila per a accedir a la matriu gameCards
; col       : columna per a accedir a la matriu gameCards
; indexMat  : �ndex per a accedir a la matriu gameCards
;
; Par�metres d'entrada : 
; Cap
;
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calcIndexP1 proc
	push ebp
	mov  ebp, esp
	PUSH EAX
	PUSH EBX

	; rowScreen
	MOV EAX, [row]
	DEC EAX
	SHL EAX, 2
	; colScreen
	XOR EBX, EBX
	MOV BL, [col]
	SUB EBX, 65

	ADD EAX, EBX
	MOV [indexMat], EAX

	POP EBX
	POP EAX
	mov esp, ebp
	pop ebp
	ret
calcIndexP1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; En primer lloc calcular la posici� de la matriu corresponent a la
; posici� que ocupa el cursor a la pantalla, cridant a la subrutina 
; calcIndexP1. Mostrar el contingut de la casella a la posici� de 
; pantalla corresponent.
;
; Canvis per a OpenContinuous:
; En cas de que la carta no estigui girada mostrar el valor
; En cas de que sigui la primera carta girada:
;	- Guardar el valor i la posici� de la carta en el registres 
;	  firstVal i firstPos
;	- Actualitzar la matriu tauler y printar el valor per pantalla 
;	  a la seva posici�
; En cas de que sigui la segona carta girada:
;	- Comprovar si el valor es el mateix que la primera carta
;		- Si el valor es el mateix actualitzar la matriu tauler, la 
;		  variable totalPairs, i el valor de parelles restants 
;		  mostrat per pantalla (updateScore)
;		- Si el valor no es el mateix, esperar a que el usuari premi 
;		  qualsevol tecla (getMoveP1), esborrar els valors de pantalla 
;		  i la matriu tauler, i actualitzar els intents restants.
; Mostrarem el contingut de la carta criant a la subrutina printch. L'�ndex per
; a accedir a la matriu gameCards, el calcularem cridant a la subrutina calcIndexP1.
; No es pot obrir una casella que ja tenim oberta o marcada.
;
; Canvis per al nivell avan�at:
; Cada vegada que fem una parella o fallem, actualitzar el total de parelles 
; i intents restants.
;
; Variables utilitzades:	
; row       : fila per a accedir a la matriu gameCards
; col       : columna per a accedir a la matriu gameCards
; indexMat  : �ndex per a accedir a la matriu gameCards
; gameCards : matriu 8x8 on tenim les posicions de les mines. 
; carac	    : car�cter per a escriure a pantalla.
; tauler   : matriu en la que guardem els valors de les tirades 
; firstVal  : valor de la primera carta destapada
; firstPos  : posici� de la primera carta destapada
; cardTurn  : flag per controlar si el jugador esta obrint la 
;             primera o la segona carta
; totalPairs: nombre de parelles restants
; totalTries: nombre de intents restants
;
; Par�metres d'entrada : 
; Cap
;
; Par�metres de sortida: 
; endGame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openP1 proc
	push ebp
	mov  ebp, esp
	PUSH EAX
	PUSH EBX
	PUSH ECX
	PUSH EDX

	CALL calcIndexP1
	MOV EBX, [indexMat]
	XOR EAX, EAX
	MOV AL, [gameCards + EBX]
	CMP [tauler + EBX], 32
	JNE FI

	MOV ECX, [cardTurn]
	CMP ECX, 0
	JE PRIMERA

	SEGONA:
	; Comprovem si s�n iguals
	MOV [cardTurn], 0
	MOV EDX, [firstVal]
	CMP EAX, EDX
	JE CORRECTE

	INCORRECTE:
	MOV ECX, [totalTries]
	DEC ECX
	; Pintem la carta aixecada
	MOV [totalTries], ECX
	MOV [carac], AL
	CALL printch
	CALL posCurScreenP1
	CALL getMoveP1
	; Buidem la casella actual
	MOV [carac], 32
	CALL posCurScreenP1
	CALL printch
	; Guardem les posicions actuals
	MOV ECX, [row]
	PUSH ECX
	XOR ECX, ECX
	MOV CL, [col]
	PUSH ECX
	; Buidem la casella restant
	MOV ECX, [firstRow]
	MOV [row], ECX
	XOR ECX, ECX
	MOV CL, [firstCol]
	MOV [col], CL
	CALL posCurScreenP1
	CALL printch
	CALL calcIndexP1
	MOV EBX, [indexMat]
	MOV [tauler + EBX], 32
	; Restaurem posicions
	XOR ECX, ECX
	POP ECX
	MOV [col], CL
	POP ECX
	MOV [row], ECX
	CALL posCurScreenP1
	JMP UPDATE

	CORRECTE:
	MOV ECX, [totalPairs]
	DEC ECX
	MOV [totalPairs], ECX
	JMP DEFAULT

	PRIMERA:
	MOV [cardTurn], 1
	MOV ECX, [row]
	MOV [firstRow], ECX
	XOR ECX, ECX
	MOV CL, [col]
	MOV [firstCol], CL
	MOV [firstVal], EAX

	DEFAULT:
	MOV [carac], AL
	CALL printch
	MOV [tauler + EBX], AL

	UPDATE:
	CALL updateScore
	FI:
	POP EDX
	POP ECX
	POP EBX
	POP EAX
	mov esp, ebp
	pop ebp
	ret
openP1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa l�obertura continua de cartes. S�ha 
; d�utilitzar la tecla espai per girar/obrir una carta i la 's' per 
; sortir. 
;
; Canvis per al nivell avan�at: 
; Per a cada moviment introdu�t comprovar si hem guanyat o perdut el 
; joc compovant les variables totalPairs i totalTries.
;
; Variables utilitzades: 
; carac2     : car�cter introdu�t per l�usuari
; row        : fila per a accedir a la matriu gameCards
; col        : columna per a accedir a la matriu gameCards
; totalPairs : nombre de variables restants que ens queden en joc
; totalTries : nombre de intents restants que ens queden en joc
;
; Par�metres d'entrada : 
; Cap
;
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openContinuousP1 proc
	push ebp
	mov  ebp, esp
	PUSH EAX

	MOV [cardTurn], 0
	BUCLE:
	; Vict�ria
	MOV EAX, [totalPairs]
	CMP EAX, 0
	JLE FI
	; Derrota
	MOV EAX, [totalTries]
	CMP EAX, 0
	JLE FI
	CALL movContinuoP1
	; Sortir del joc
	XOR EAX, EAX
	MOV AL, [carac2]
	CMP AL, 115
	JE FI 
	CALL openP1
	JMP BUCLE

	FI:
	POP EAX
	mov esp, ebp
	pop ebp
	ret
openContinuousP1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que mostra el n�mero de parelles restants. Moure el 
; cursor a la posici� (row=-1, col=5) i (row=-1, col=3), per printar 
; el n�mero de parelles i intents restants, al finalitzar, retornar
; el cursor a la posici� original.
;
; Variables utilitzades: 
; totalPairs : nombre de parelles restants
; totalTries : nombre d'intentns restants
; row        : fila per a accedir a la matriu gameCards
; col        : columna per a accedir a la matriu gameCards
;
; Par�metres d'entrada : 
; Cap
;
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateScore proc
	push ebp
	mov  ebp, esp
	PUSH EAX
	PUSH EBX
	PUSH ECX

	MOV EBX, [row]
	XOR ECX, ECX
	MOV CL, [col]

	MOV [col], 'B'
	MOV [row], -1
	CALL posCurScreenP1
	MOV EAX, [totalPairs]
	ADD EAX, 48
	MOV [carac], AL
	CALL printch
	MOV [col], 'E'
	MOV [row], -1
	CALL posCurScreenP1
	MOV EAX, [totalTries]
	ADD EAX, 48
	MOV [carac], AL
	CALL printch

	MOV [row], EBX
	MOV [col], CL
	CALL posCurScreenP1
	

	FI:
	POP ECX
	POP EBX
	POP EAX
	mov esp, ebp
	pop ebp
	ret
updateScore endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que inicialitza el tauler aleat�riament.
;
; Pistes:
; - La crida a la funci� rand guarda el valor aleatori al
;   registre eax
; - La crida a la funci� div guarda el modul de la divisi� al
;   registre edx
;
; Variables utilitzades: 
; row      : fila per a accedir a la matriu gameCards
; col      : columna per a accedir a la matriu gameCards
; cards	   : llistat ordenat de cartes en joc
; gameCards: matriu de cartes ordenades aleat�riament.
;
;
; Par�metres d'entrada : 
; Cap
;
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setupBoard proc
	push ebp
	mov  ebp, esp
	PUSH EAX
	PUSH EBX
	PUSH ECX
	PUSH EDX

	; SHUFFLE
	XOR EBX, EBX
	MOV ESI, 0
	BUCLE_RAND:

	CALL rand
	MOV EDX, 0
	MOV ECX, 7
	DIV ECX
	ADD EDX, 8
	XOR EAX, EAX
	MOV AL, [cards+ESI]
	MOV BL, [cards+EDX]
	MOV [cards+EDX], AL
	MOV [cards+ESI], BL

	INC ESI
	CMP ESI, 8
	JL BUCLE_RAND

	; Inicialitzaci�
	MOV ESI, 0
	BUCLE_ROW:
	CMP ESI, 4
	JGE END_ROW

	MOV EDI, 0

	BUCLE_COL:
	; Calcular �ndex
	CMP EDI, 4
	JGE END_COL

	; Calculem l'�ndex
	MOV EBX, ESI
	SHL EBX, 2
	ADD EBX, EDI
	; Assignem
	MOV CL, [cards+EBX]
	MOV [gameCards+EBX], CL

	INC EDI
	JMP BUCLE_COL
	END_COL:

	INC ESI
	JMP BUCLE_ROW
	END_ROW:

	POP EDX
	POP ECX
	POP EBX
	POP EAX
	mov esp, ebp
	pop ebp
	ret
setupBoard endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que mostra nombres de 2 xifres per pantalla
;
; rowscreen	: fila del cursor a la pantalla
; colscreen	: columna del cursor a la pantalla
; carac		: car�cter a visulatizar per la pantalla
;
; Par�metres d'entrada : 
; AL: nombre a mostrar
;
; Par�metres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showNumbers proc
	push ebp
	mov  ebp, esp



	mov esp, ebp
	pop ebp
	ret
showNumbers endp

;****************************************************************************************


END
