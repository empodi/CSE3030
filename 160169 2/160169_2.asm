TITLE 160169 TASK 2

INCLUDE irvine32.inc

.data
prompt1		BYTE	"Enter a Multiplier : ", 0
prompt2		BYTE	"Enter a Multiplicand : ", 0
prompt3		BYTE	"Produce : ", 0
prompt4		BYTE	"Bye!", 0
result		DWORD	?

.code
main PROC	

Start:
	mov		result, 0
	mov		edx, OFFSET prompt1		; multiplier가 ebx에 대입
	call	WriteString
	call	ReadHex
	jz		LAST	; Enter 입력시 마지막으로 
	mov		ebx, eax
	mov		edx, OFFSET prompt2		; multiplicand가 eax에 대입
	call	WriteString
	call	ReadHex
	jz		LAST	; Enter 입력시 마지막으로 
	mov		ecx, 0
	
	call	DoMultiply	; 곱셈 후 결과 display하는 함수

	jmp		Start

LAST:
	mov		edx, OFFSET prompt4
	call	WriteString

	exit
main ENDP

DoMultiply PROC
J1:
	add		ecx, 1
	shr		ebx, 1
	pushfd
	jnc		MID		; ebx를 shr하여 cf = 1 이 되면 곱셈을 한다 
	
	add		ecx, -1
	shl		eax, cl
	add		result, eax
	shr		eax, cl
	add		ecx, 1
MID:
	popfd
	jne		J1		; ebx가 0이면 곱셈 종료

	mov		edx, OFFSET prompt3  ; 여기서부터는 produce 출력 부분
	mov		eax, result
	call	WriteString
	call	WriteHex
	call	Crlf
	ret
DoMultiply ENDP

END main