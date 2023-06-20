TITLE TEST code: 160169_3

INCLUDE irvine32.inc

.data
INCLUDE hw3.inc
count DWORD ?
temp DWORD ?

.code
main PROC

	mov eax, X
	mov temp, eax
	mov eax, 0
	mov ecx, Y
	dec ecx

L1: 
	mov		count, ecx
	mov		ecx, X
L2:
	add eax, temp
	loop L2
	mov temp, eax
	mov eax, 0
	mov ecx, count
	loop L1

	mov eax, temp

	mov ebx, Y
	mov temp, ebx
	mov ebx, 0
	mov ecx, X
	dec ecx

L3: 
	mov		count, ecx
	mov		ecx, Y
L4:
	add ebx, temp
	loop L4
	mov temp, ebx
	mov ebx, 0
	mov ecx, count
	loop L3

	mov ebx, temp

	call DumpRegs
main ENDP
END main