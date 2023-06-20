TITLE TEST code : Assignment 160169_1

INCLUDE Irvine32.inc

.data
INCLUDE hw1.inc
arrLen = ($ - array1) - 4
val DWORD ?

.code

main PROC

	mov		esi, 0
	mov		ebx, array1[esi]
	mov		eax, array1[arrLen]
	sub		eax, ebx

	call DumpRegs
main ENDP
END main