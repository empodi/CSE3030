TITLE 160169_1

INCLUDE Irvine32.inc

.data
INPUT BYTE "Input: ", 0

.code
MAIN		PROC

	mov		edx, OFFSET INPUT
	call	WriteString
	call	readint

	mov		ecx, eax
	mov		ebx, 1

L1:
	push	ecx
	mov		ecx, ebx
L2:
	mov		al, "*"
	call	WriteChar
	loop	L2
	pop		ecx
	inc		ebx
	call	Crlf
	loop L1

	exit

MAIN		ENDP
end		main
