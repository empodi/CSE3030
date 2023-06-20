TITLE 160169_3

INCLUDE Irvine32.inc

.data
arr		BYTE	21 DUP(0)
msg		BYTE	"Is this string palindrome? : ", 0
yes		BYTE	"It's a palindrome!", 0
no		BYTE	"It's NOT a palindrome", 0

.code
MAIN		PROC

	mov		edx, OFFSET msg
	call	WriteString

	mov		edx, OFFSET arr
	mov		ecx, LENGTHOF arr - 1
	call	ReadString

	cmp		eax, 1
	je		Succ

	mov		ecx, eax
	shr		ecx, 1
	mov		esi, 0
	mov		ebx, 0
L1:
	mov		bl, arr[esi]
	push	ebx
	inc		esi
	loop	L1

	mov		ecx, eax
	shr		ecx, 1

	mov		edx, ecx
	and		eax, 1
	jz		skip		
	inc		edx
skip:
	mov		ebx, 0
L2:	
	pop		ebx
	mov		al, arr[edx]
	cmp		al, bl
	jne		Fail
	inc		edx
	loop	L2
Succ:
	mov		edx, OFFSET yes
	call	WriteString
	call	Crlf
	jmp		Quit

Fail:
	mov		edx, OFFSET no
	call	WriteString
	call	Crlf
Quit:
	exit

MAIN		ENDP
end		main
