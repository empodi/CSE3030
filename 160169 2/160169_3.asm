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

	mov		esi, 0					; esi에 0 -> Input 인덱스로 사용
	mov		edi, 0					; edi에 0 -> target 인덱스로 사용
	mov		ecx, inputLen			; ecx에 input의 길이

L1:									;루프 시작
	mov		al, Input[esi]
	mov		bl, Target[edi]
	xor		al, bl
	jnz		skipSearch    ; al, bl이 동일한 경우 FuncSearch 호출

	push	ecx
	call	FuncSearch
	jecxz	SearchSuccess	;만약 FindString 함수에서 반환받은 ecx 값이 0이면 Search Success
	pop		ecx
skipSearch:
	inc		esi
	loop	L1			;루프 종료
	jecxz	SearchFail	;루프가 종료된 후 ecx가 0이면 search fail

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
	jnz		EndFunc		; 알파벳이 다른 경우 - 함수 종료
	inc		esi
	inc		edi
	loop	L2			; 루프 종료 (ecx == 0) -> target Search Success

	cmp		edi, inputLen	; input과 target이 완전히 동일한 경우 함수 종료
	jz		EndFunc

	mov		al, Input[esi]
	xor		al, 00100000b	; target 바로 다음에 해당하는 input 인덱스 공백인지 확인 - 공백이 아니면 fall through, 공백이면 jump
	jz		checkFrontOfTarget

	mov		al, Input[esi]	; target 바로 다음에 해당하는 input 인덱스가 EOL인지 확인 - EOL이 아니면 fall through, EOL이면 jump
	xor		al, 00000000b
	jz		checkFrontOfTarget
	inc		ecx

checkFrontOfTarget:			; target이 input의 첫 단어인지 또는 target 바로 앞에 해당하는 input 인덱스가 공백인지 확인
	sub		esi, targetLen
	cmp		esi, 0
	jz		EndFunc			; target이 input의 첫 단어이면 함수 종료
	dec		esi
	mov		al, Input[esi]
	xor		al, 00100000b
	jz		EndFunc			; target 바로 앞에 해당하는 input 인덱스가 공백이면 함수 종료
	inc		ecx

EndFunc:
	ret
FuncSearch	ENDP
END main