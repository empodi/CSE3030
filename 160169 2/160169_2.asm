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
	mov		edx, OFFSET prompt1		; multiplier�� ebx�� ����
	call	WriteString
	call	ReadHex
	jz		LAST	; Enter �Է½� ���������� 
	mov		ebx, eax
	mov		edx, OFFSET prompt2		; multiplicand�� eax�� ����
	call	WriteString
	call	ReadHex
	jz		LAST	; Enter �Է½� ���������� 
	mov		ecx, 0
	
	call	DoMultiply	; ���� �� ��� display�ϴ� �Լ�

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
	jnc		MID		; ebx�� shr�Ͽ� cf = 1 �� �Ǹ� ������ �Ѵ� 
	
	add		ecx, -1
	shl		eax, cl
	add		result, eax
	shr		eax, cl
	add		ecx, 1
MID:
	popfd
	jne		J1		; ebx�� 0�̸� ���� ����

	mov		edx, OFFSET prompt3  ; ���⼭���ʹ� produce ��� �κ�
	mov		eax, result
	call	WriteString
	call	WriteHex
	call	Crlf
	ret
DoMultiply ENDP

END main