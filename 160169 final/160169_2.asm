TITLE 160169_2

INCLUDE Irvine32.inc

.data
arr		BYTE	41 DUP(0)
input	BYTE	"Type_A_String_To_Reverse: ", 0
result	BYTE	"Reversed_String: ", 0
bye		BYTE	"Bye!", 0

.code
MAIN		PROC

Start:
	call	ReverseString
	jmp		Start

Quit::
	mov		edx, OFFSET bye
	call	WriteString

	exit

MAIN		ENDP

ReverseString	PROC

	mov		edx, OFFSET input
	call	WriteString

	mov		edx, OFFSET	arr
	mov		ecx, LENGTHOF arr - 1
	call	ReadString
	jz		Quit

	mov		ecx, eax
	mov		esi, 0
	mov		ebx, 0
L1:
	mov		bl, arr[esi]
	push	ebx
	inc		esi
	loop	L1

	mov		ecx, eax
	mov		esi, 0
L2:
	pop		ebx
	mov		arr[esi], bl
	inc		esi
	loop	L2

	mov		edx, OFFSET result
	call	WriteString
	mov		edx, OFFSET arr
	call	WriteString
	call	Crlf

	ret
ReverseString	ENDP

end		main
