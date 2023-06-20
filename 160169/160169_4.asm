TITLE TEST code : 160169_4

INCLUDE irvine32.inc

.data
INCLUDE hw4.inc
nameSize = ($ - target) - 2
temp DWORD ?

.code
main PROC
	
	mov		edi, 0
	mov		esi, nameSize
	mov		ecx, SIZEOF target

L1:
	mov		al, source[edi]
	mov		target[esi], al
	inc		edi
	dec		esi
	loop L1

	mov		edx, OFFSET target
	call WriteString

main ENDP
END main