TITLE HITBALL (EXE)
.MODEL SMALL
.STACK 200H
;-----------------------------------
.DATA
	HOME DB 'hb-menu.txt', 00H
	ERROR_STR DB "Error!$"
	FILE_HANDLE	DW ?
	FILE_BUFFER	DB 1896 DUP('$')
	ROW DB 0
	COL DB 0

	PLAYER_HEAD DB  "O$"
	PLAYER_BODY DB "-|-$"
	PLAYER_FEET DB "/ \$"

	PLAYER1_HEAD_ROW DB 22
	PLAYER1_HEAD_COL DB 38
	PLAYER1_BODY_ROW DB 23
	PLAYER1_BODY_COL DB 37
	PLAYER1_FEET_ROW DB 24
	PLAYER1_FEET_COL DB 37

	PLAYER2_HEAD_ROW DB 00
	PLAYER2_HEAD_COL DB 38
	PLAYER2_BODY_ROW DB 01
	PLAYER2_BODY_COL DB 37
	PLAYER2_FEET_ROW DB 02
	PLAYER2_FEET_COL DB 37
;-----------------------------------
.CODE
MAIN PROC FAR
	MOV AX, @data
	MOV DS, AX
 	MOV ES, AX

MENU:
 	CALL DISP_HOME

GAME:
	CALL PLAY

EXIT:
   	MOV   AX, 4C00H
    INT   21H
MAIN ENDP
;-----------------------------------
DISP_HOME PROC NEAR												;DISPLAY MENU SCREEN
	MOV ROW, 0
	MOV COL, 0
	CALL SET_CURS
	CALL CLS
	LEA DX, HOME
	CALL FILE_READ
	;JMP 		MENU_CH

IS_ENTER:
	MOV AH, 10H
  	INT 16H
  	CMP AL, 0DH
  	JE PLAY_GAME
  	JMP IS_ENTER

PLAY_GAME:
	RET
DISP_HOME ENDP
;-----------------------------------
FILE_READ PROC NEAR
	MOV AX, 3D02H											;OPEN FILE
	INT	21H
	JC _ERROR
	MOV FILE_HANDLE, AX
	
	MOV AH, 3FH												;READ FILE
	MOV	BX, FILE_HANDLE
	MOV	CX, 1896
	LEA	DX, FILE_BUFFER
	INT	21H
	JC _ERROR
	
	MOV DX, 0500H											;DISPLAY FILE
	CALL SET_CURS
	LEA DX, FILE_BUFFER
	CALL DISPLAY

	MOV AH, 3EH         							;CLOSE FILE
	MOV BX, FILE_HANDLE
	INT 21H
	JC _ERROR

	RET

_ERROR:		
	LEA DX, ERROR_STR									;ERROR IN FILE OPERATION
	CALL DISPLAY
	RET
BK:			
	RET
FILE_READ ENDP
;-------------------------------------
DISPLAY PROC NEAR
	MOV AH, 09H
	INT 21H
	RET
DISPLAY ENDP
;-------------------------------------
SET_CURS PROC NEAR
	MOV	AH, 02H
	MOV	BH, 00
	MOV	DH, ROW
	MOV DL, COL
	INT 10H
	RET
SET_CURS ENDP
;-------------------------------------
CLS PROC NEAR			
	MOV	AX, 0600H
	MOV	BH, 01H
	MOV	CX, 0000H
	MOV DX, 184FH
	INT 10H
	RET
CLS ENDP
;-------------------------------------
PLAY PROC NEAR
CLEAR:
	CALL SET_BALL_COLOR

PLAYER1_COLOR:
	CALL SET_PLAYER1_COLOR

PLAYER1_HEAD_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER1_HEAD

DISPLAY_PLAYER1_HEAD:
	LEA DX, PLAYER_HEAD
	MOV AH, 09
	INT 21H

PLAYER1_BODY_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER1_BODY

DISPLAY_PLAYER1_BODY:
	LEA DX, PLAYER_BODY
	MOV AH, 09
	INT 21H

PLAYER1_FEET_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER1_FEET

DISPLAY_PLAYER1_FEET:
	LEA DX, PLAYER_FEET
	MOV AH, 09
	INT 21H

PLAYER2_COLOR:
	CALL SET_PLAYER2_COLOR

PLAYER2_HEAD_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER2_HEAD

DISPLAY_PLAYER2_HEAD:
	LEA DX, PLAYER_HEAD
	MOV AH, 09
	INT 21H

PLAYER2_BODY_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER2_BODY

DISPLAY_PLAYER2_BODY:
	LEA DX, PLAYER_BODY
	MOV AH, 09
	INT 21H

PLAYER2_FEET_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER2_FEET

DISPLAY_PLAYER2_FEET:
	LEA DX, PLAYER_FEET
	MOV AH, 09
	INT 21H

	RET
PLAY ENDP
;---------------------------------------------
SET_BALL_COLOR PROC NEAR
  MOV AX, 0600H   
  MOV BH, 03H     
  MOV CX, 0000H   
  MOV DX, 184FH   
  INT 10H

  RET
SET_BALL_COLOR ENDP
;---------------------------------------------
SET_PLAYER1_COLOR PROC NEAR
  MOV AX, 0600H   
  MOV BH, 01H     
  MOV CX, 1600H   
  MOV DX, 184FH   
  INT 10H

  RET
SET_PLAYER1_COLOR ENDP
;---------------------------------------------
SET_PLAYER1_HEAD PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER1_HEAD_ROW   
  MOV DL, PLAYER1_HEAD_COL   
  INT 10H

  RET
SET_PLAYER1_HEAD ENDP
;---------------------------------------------
SET_PLAYER1_BODY PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER1_BODY_ROW   
  MOV DL, PLAYER1_BODY_COL   
  INT 10H

  RET
SET_PLAYER1_BODY ENDP
;---------------------------------------------
SET_PLAYER1_FEET PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER1_FEET_ROW   
  MOV DL, PLAYER1_FEET_COL   
  INT 10H

  RET
SET_PLAYER1_FEET ENDP

;---------------------------------------------
SET_PLAYER2_COLOR PROC NEAR
  MOV AX, 0600H   
  MOV BH, 04H     
  MOV CX, 0000H   
  MOV DX, 034FH   
  INT 10H

  RET
SET_PLAYER2_COLOR ENDP
;---------------------------------------------
SET_PLAYER2_HEAD PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER2_HEAD_ROW   
  MOV DL, PLAYER2_HEAD_COL   
  INT 10H

  RET
SET_PLAYER2_HEAD ENDP
;---------------------------------------------
SET_PLAYER2_BODY PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER2_BODY_ROW   
  MOV DL, PLAYER2_BODY_COL   
  INT 10H

  RET
SET_PLAYER2_BODY ENDP
;---------------------------------------------
SET_PLAYER2_FEET PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER2_FEET_ROW   
  MOV DL, PLAYER2_FEET_COL   
  INT 10H

  RET
SET_PLAYER2_FEET ENDP
END MAIN