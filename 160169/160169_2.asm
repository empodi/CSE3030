TITLE TEST code : 160169_2

INCLUDE Irvine32.inc

.data
INCLUDE hw2.inc
val DWORD ?

.code

main PROC
	
	mov		eax, 1
	mov		ebx, 1
	mov		ecx, fib
	sub		ecx, 2

L1:
	add eax, ebx
	sub ebx, eax
	neg ebx
	loop L1

	call DumpRegs
main ENDP
END main