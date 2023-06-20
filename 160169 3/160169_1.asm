TITLE 160169_3

INCLUDE Irvine32.inc

.data
INCLUDE hw3.inc
spaceStr	BYTE ", ", 0
prompt1		BYTE "Before sort: ", 0
prompt2		BYTE "After sort: ", 0
BYE			BYTE "Bye!", 0
;LenData DWORD 7
;ArrData DWORD (51 0013h), (1 0001h), (2 0003h), (1 0005h), (51 0021h), (2 0001h), (1 0002h)

.code

MAIN	PROC

	mov		edx, OFFSET prompt1
	mov		ecx, LenData
	mov		esi, OFFSET ArrData
	call	DisplayArr

	mov		ecx, LenData
	call	sortX_ODD

	mov		ecx, LenData
	call	sortX_EVEN

	mov		ecx, LenData
	call	sortY

	mov		ecx, LenData
	mov		esi, OFFSET ArrData
	mov		edx, OFFSET prompt2
	call	DisplayArr

	mov		edx, OFFSET BYE
	call	WriteString
	exit

MAIN	ENDP

sortY		PROC
	sub		ecx, 2
	mov		esi, OFFSET ArrData
	mov		dx, 0
L1:
	mov		eax, [esi]
	shr		eax, 16
	mov		ebx, [esi + 8]
	shr		ebx, 16
	cmp		eax, ebx
	jne		Skip
	mov		eax, [esi]
	mov		ebx, [esi + 8]
	and		dx, 1
	jz		Temp1				;0, 2, 4 인덱스이면 eax, ebx 순서대로,   1, 3, 5 인덱스이면 ebx, eax 순서대로
	mov		eax, [esi + 8]
	mov		ebx, [esi]
Temp1:
	cmp		eax, ebx
	jnc		Skip
	mov		eax, [esi]
	xchg	eax, [esi + 8]
	mov		[esi], eax
Skip:
	add		esi, 4
	inc		dx
	loop	L1
	ret
sortY		ENDP

sortX_EVEN		PROC
	shr		ecx, 1
	dec		ecx
L1:
	push	ecx
	mov		esi, OFFSET ArrData + 4

L2:
	mov		eax, [esi]
	cmp		[esi + 8], eax
	jl		L3
	xchg	eax, [esi + 8]
	mov		[esi], eax
L3:	
	add		esi, 8
	loop	L2
	pop		ecx
	loop	L1
	ret
sortX_EVEN		ENDP

sortX_ODD		PROC	
	TEST	cl, 1
	jz		TEMP1
	inc		ecx
TEMP1:
	shr		ecx, 1
	dec		ecx
L1:
	push	ecx
	mov		esi, OFFSET ArrData
L2:
	mov		eax, [esi]
	cmp		[esi + 8], eax
	jg		L3
	xchg	eax, [esi + 8]
	mov		[esi], eax
L3:	
	add		esi, 8
	loop	L2
	pop		ecx
	loop	L1
	ret
sortX_ODD		ENDP

DisplayArr	PROC

	call	WriteString
	mov		edx, OFFSET spaceStr
L1:
	mov		eax, [esi]
	call	WriteHex
	cmp		ecx, 1
	jz		EndFunc
	mov		eax, 0
	call	WriteString
	add		esi, 4
	loop	L1
EndFunc:
	call	Crlf
	ret
DisplayArr	ENDP

end	main