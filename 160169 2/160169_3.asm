TITLE 160169 TASK 3

INCLUDE irvine32.inc

.data
Input			BYTE	100 DUP(0)
Target			BYTE	41 DUP(0)
InputMsg		BYTE	"Type_A_String: ", 0
TargetMsg		BYTE	"A_Word_for_Search: ", 0
FoundMsg		BYTE	"Found", 0
NotFoundMsg		BYTE	"Not found", 0
ChangedMsg		BYTE	"Changed : ", 0
Bye				BYTE	"Bye!", 0
inputLen		DWORD   0
targetLen		DWORD	0
MaxLen			DWORD	40

.code
main PROC	

Start:
	mov		edx, OFFSET	InputMsg
	call	WriteString
	mov		edx, OFFSET Input
	mov		ecx, LENGTHOF INPUT
	call	ReadString

	xor		ax, 00000000b
	jz		Quit

	mov		inputLen, eax
	cmp		MaxLen, eax
	jc		Start
	
	mov		edx, OFFSET	TargetMsg
	call	WriteString
	mov		edx, OFFSET Target
	mov		ecx, LENGTHOF Target
	call	ReadString

	xor		ax, 00000000b
	jz		Quit
	mov		targetLen, eax

	mov		esi, 0					; esi�� 0 -> Input �ε����� ���
	mov		edi, 0					; edi�� 0 -> target �ε����� ���
	mov		ecx, inputLen			; ecx�� input�� ����

L1:									;���� ����
	mov		al, Input[esi]
	mov		bl, Target[edi]
	xor		al, bl
	jnz		skipSearch    ; al, bl�� ������ ��� FuncSearch ȣ��

	push	ecx
	call	FuncSearch
	jecxz	SearchSuccess	;���� FindString �Լ����� ��ȯ���� ecx ���� 0�̸� Search Success
	pop		ecx
skipSearch:
	inc		esi
	loop	L1			;���� ����
	jecxz	SearchFail	;������ ����� �� ecx�� 0�̸� search fail

SearchSuccess:
	mov		edx, OFFSET FOUNDMsg
	call	WriteString
	call	Crlf
	call	DeleteTarget
	call	DisplayChange
	jmp		Start

SearchFail:
	call	DisplayChange
	mov		edx, OFFSET NotFOUNDMsg
	call	WriteString
	call	Crlf
	jmp		Start

Quit:
	mov		edx, OFFSET Bye
	call	WriteString
	call	Crlf
	exit
main ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------

DeleteTarget	PROC	USES	esi
	mov		ecx, targetLen
	mov		al, " "
L3:
	mov		Input[esi], al
	inc		esi
	loop	L3
	ret
DeleteTarget	ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------

DisplayChange	PROC
	mov		edx, OFFSET ChangedMsg
	call	WriteString
	mov		edx, OFFSET Input
	call	WriteString
	call	Crlf
	ret
DisplayChange	ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------
FuncSearch	PROC	USES esi edi
	
	mov		ecx, targetLen
L2:
	mov		al, Input[esi]
	mov		bl, Target[edi]
	xor		al, bl
	jnz		EndFunc		; ���ĺ��� �ٸ� ��� - �Լ� ����
	inc		esi
	inc		edi
	loop	L2			; ���� ���� (ecx == 0) -> target Search Success

	cmp		edi, inputLen	; input�� target�� ������ ������ ��� �Լ� ����
	jz		EndFunc

	mov		al, Input[esi]
	xor		al, 00100000b	; target �ٷ� ������ �ش��ϴ� input �ε��� �������� Ȯ�� - ������ �ƴϸ� fall through, �����̸� jump
	jz		checkFrontOfTarget

	mov		al, Input[esi]	; target �ٷ� ������ �ش��ϴ� input �ε����� EOL���� Ȯ�� - EOL�� �ƴϸ� fall through, EOL�̸� jump
	xor		al, 00000000b
	jz		checkFrontOfTarget
	inc		ecx

checkFrontOfTarget:			; target�� input�� ù �ܾ����� �Ǵ� target �ٷ� �տ� �ش��ϴ� input �ε����� �������� Ȯ��
	sub		esi, targetLen
	cmp		esi, 0
	jz		EndFunc			; target�� input�� ù �ܾ��̸� �Լ� ����
	dec		esi
	mov		al, Input[esi]
	xor		al, 00100000b
	jz		EndFunc			; target �ٷ� �տ� �ش��ϴ� input �ε����� �����̸� �Լ� ����
	inc		ecx

EndFunc:
	ret
FuncSearch	ENDP
END main