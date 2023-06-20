TITLE 160169_2

INCLUDE Irvine32.inc

.data
target		BYTE "AAEBDCFBBC", 0
freqTable	DWORD 256 DUP (0)
msg			BYTE "Index    freqTable", 0

.code
main	PROC

	call	Get_frequencies

	mov		edx, OFFSET msg
	call	WriteString
	call	Crlf

	mov		ecx, LENGTHOF freqTable
	mov		ebx, 0
	mov		esi, OFFSET freqTable
L2:
	mov		eax, [esi]
	cmp		eax, 0
	jz		Skip
	push	eax
	mov		eax, ebx
	call	WriteHex
	mov		al, " "
	call	WriteChar
	pop		eax
	call	WriteDec
	call	Crlf
Skip:
	add		esi, 4
	inc		ebx
	loop L2

exit
main	ENDP

Get_frequencies PROC	

	mov		edx, OFFSET freqTable
	mov		esi, OFFSET target
	mov		ecx, LENGTHOF target - 1
L1:
	mov		eax, 0
	mov		al, BYTE PTR [esi]

	mov		ebx, [edx + eax * TYPE freqTable]
	inc		ebx
	mov		[edx + eax * TYPE freqTable], ebx
	inc		esi
	loop	L1
	ret
Get_frequencies ENDP

END main