TITLE 160169_3

INCLUDE Irvine32.inc

.data
CaseTable	BYTE '1'
			DWORD	Process_1
EntrySize = ($ - CaseTable)
			BYTE '2'
			DWORD	Process_2
			BYTE '3'
			DWORD	Process_3
			BYTE '4'
			DWORD	Process_4
			BYTE '5'
			DWORD	Process_5
NumberOfEntries = ($ - CaseTable) / EntrySize

Sel			BYTE	?
Menu1		BYTE	"1. x AND y", 0dh, 0ah, 0
Menu2		BYTE	"2. x OR y", 0dh, 0ah, 0
Menu3		BYTE	"3. NOT x", 0dh, 0ah, 0
Menu4		BYTE	"4. x XOR y", 0dh, 0ah, 0
Menu5		BYTE	"5. Exit program", 0dh, 0ah, 0
Res1		BYTE	"Result of x AND y: ", 0
Res2		BYTE	"Result of x OR y: ", 0
Res3		BYTE	"Result of NOT x: ", 0
Res4		BYTE	"Result of x XOR y: ", 0
Choose		BYTE	"Choose Calculation Mode : ", 0
ChangeMode	BYTE	"Do you want to change the mode(Y/N)? : ", 0
EnterX		BYTE	"Enter x: ", 0
EnterY		BYTE	"Enter y: ", 0
Input		BYTE	10 DUP(0)
InputLen	DWORD	?
check		BYTE	?
temp		DWORD	?
BYE			BYTE	"Bye!", 0

.code
MAIN	PROC
Start:
	mov		eax, 0
	call	DisplayMenu
Reselect:
	mov		edx, OFFSET Choose
	call	WriteString
	call	ReadChar
	call	WriteChar
	call	Crlf
	call	CheckMenuRange
	jnz		Reselect
	mov		Sel, al
ContinueMode:
	mov		ebx, OFFSET CaseTable
	mov		ecx, NumberOfEntries
	mov		al, Sel

L1:	
	cmp		al, [ebx]
	jne		L2
	call	NEAR PTR [ebx + 1]
	call	Crlf
	jmp		ifchange
L2:
	add		ebx, EntrySize
	loop	L1

ifchange:
	mov		edx, OFFSET ChangeMode
	call	WriteString
	call	ReadChar
	call	WriteChar
	call	Crlf
	and		al, 11011111b
	cmp		al, 059h
	je		Start
	cmp		al, 04Eh
	je		ContinueMode
	jmp		ifchange

Quit::
	mov		edx, OFFSET BYE
	call	WriteString
	exit

MAIN	ENDP

Process_1		PROC	
	call	GetX
	push	eax
	call	GetY
	mov		ebx, eax
	pop		eax

	mov		edx, OFFSET Res1
	call	WriteString
	and		eax, ebx
	call	WriteHex
	call	Crlf
	ret
Process_1		ENDP

Process_2	PROC
	call	GetX
	push	eax
	call	GetY
	mov		ebx, eax
	pop		eax

	mov		edx, OFFSET Res2
	call	WriteString
	or		eax, ebx
	call	WriteHex
	call	Crlf
	ret
Process_2	ENDP

Process_3	PROC
	call	GetX

	mov		edx, OFFSET Res3
	call	WriteString
	NOT		eax
	call	WriteHex
	call	Crlf
	ret
Process_3	ENDP

Process_4	PROC
	call	GetX
	push	eax
	call	GetY
	mov		ebx, eax
	pop		eax

	mov		edx, OFFSET Res4
	call	WriteString
	xor		eax, ebx
	call	WriteHex
	call	Crlf
	ret
Process_4	ENDP

Process_5	PROC
	jmp		Quit
	ret
Process_5	ENDP

CheckMenuRange		PROC
	
	cmp		al, '1'
	jb		EndFunc
	cmp		al, '5'
	ja		EndFunc
	test	ax, 0
EndFunc:
	ret
CheckMenuRange		ENDP

DisplayMenu		PROC	
	mov		edx, OFFSET Menu1
	call	WriteString
	mov		edx, OFFSET Menu2
	call	WriteString
	mov		edx, OFFSET Menu3
	call	WriteString
	mov		edx, OFFSET Menu4
	call	WriteString
	mov		edx, OFFSET Menu5
	call	WriteString
	ret
DisplayMenu		ENDP

GetX		PROC	

again:
	mov		edx, OFFSET EnterX
	call	WriteString

	mov		edx, OFFSET Input
	mov		ecx, LENGTHOF Input - 1
	call	ReadString
	mov		InputLen, eax
	mov		temp, 0

	mov		ecx, InputLen
	mov		esi, 0
	mov		ebx, 16
L1:
	mov		al, Input[esi]
	call	checkDigit
	cmp		check, 1
	je		pass
	add		al, 48
	call	checkHex
	cmp		check, 0
	je		again
pass:
	cmp		ecx, 1
	je		lastchar
	push	ecx
	dec		ecx
L2:
	mul		ebx
	loop	L2
	pop		ecx
lastchar:
	add		temp, eax
	mov		eax, 0
	inc		esi
	loop	L1

	mov		eax, temp
	ret
GetX		ENDP

GetY		PROC
again:
	mov		edx, OFFSET EnterY
	call	WriteString

	mov		edx, OFFSET Input
	mov		ecx, LENGTHOF Input - 1
	call	ReadString
	mov		InputLen, eax
	mov		temp, 0

	mov		ecx, InputLen
	mov		esi, 0
	mov		ebx, 16

	L1:
	mov		al, Input[esi]
	call	checkDigit
	cmp		check, 1
	je		pass
	add		al, 48
	call	checkHex
	cmp		check, 0
	je		again
pass:
	cmp		ecx, 1
	je		lastchar
	push	ecx
	dec		ecx
L2:
	mul		ebx
	loop	L2
	pop		ecx
lastchar:
	add		temp, eax
	mov		eax, 0
	inc		esi
	loop	L1

	mov		eax, temp
	ret
GetY		ENDP

checkDigit	PROC
	mov		check, 1
	cmp		al, 30h
	jb		fail
	cmp		al, 39h
	jg		fail
	jmp		succ
fail:
	mov		check, 0
succ:
	sub		al, 48
	ret
checkDigit	ENDP

checkHex	PROC
	mov		check, 1
	and		al, 11011111b
	cmp		al, 41h
	jb		fail
	cmp		al, 46h
	jg		fail
	jmp		succ
fail:
	mov		check, 0
succ:
	sub		al, 55
	ret
checkHex	ENDP

end	main