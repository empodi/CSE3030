TITLE 160169 TASK 1

INCLUDE irvine32.inc

.data
var1	BYTE	"206032401663", 0

.code
main PROC
	mov		ecx, LENGTHOF var1 - 2
	mov		esi, OFFSET var1
	mov		ebx, [esi + ecx]
	and		bl, 00001111b
L1:
	call	SepToDec
	add		ebx, eax
	inc		esi
	loop	L1
	mov		eax, ebx
	call	DumpRegs
	exit
main ENDP

SepToDec	PROC	USES ecx ebx esi
	mov		eax, 0
	mov		al, [esi]
	and		al, 00001111b
	mov		ebx, 7
L2:
	mul		ebx
	loop	L2
	ret
SepToDec	ENDP

END main