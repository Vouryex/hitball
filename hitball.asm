TITLE HITBALL (EXE)
.MODEL SMALL
.STACK 200H
;-----------------------------------
.DATA
  HOME_FILE DB 'hb-menu.txt', 00H
  ERROR_STR DB "Error!$"
  FILE_HANDLE DW ?
  HOME_STR DB 1896 DUP('$')

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

  PLAYER1_MOVE_FLAG DB 0    ; 0 - stop ; 1 - left ; 2 - right
  PLAYER2_MOVE_FLAG DB 0    ; 0 - stop ; 1 - left ; 2 - right
;-----------------------------------
.CODE
MAIN PROC FAR
  MOV AX, @data
  MOV DS, AX
  MOV ES, AX

INIT_HOME:
  CALL INIT_HOME_STR

MENU:
  CALL DISP_HOME

GAME:
  CALL PLAY

EXIT:
    MOV   AX, 4C00H
    INT   21H
MAIN ENDP
;-----------------------------------
INIT_HOME_STR PROC NEAR
OPEN_HOME_FILE:
  MOV AH, 3DH           
  MOV AL, 00            
  LEA DX, HOME_FILE
  INT 21H
  JC DISPLAY_ERROR
  MOV FILE_HANDLE, AX

READ_HOME_FILE:
  MOV AH, 3FH           
  MOV BX, FILE_HANDLE    
  MOV CX, 1895          
  LEA DX, HOME_STR   
  INT 21H
  JC DISPLAY_ERROR
  CMP AX, 00            
  JE DISPLAY_ERROR

CLOSE_HOME_FILE:
  MOV AH, 3EH           
  MOV BX, FILE_HANDLE    
  INT 21H
  JMP RETURN

DISPLAY_ERROR:
  LEA DX, ERROR_STR
  MOV AH, 09
  INT 21H

EXIT2:
    MOV AX, 4C00H
    INT 21H 

RETURN:
  RET
INIT_HOME_STR ENDP
;-----------------------------------
DISP_HOME PROC NEAR 

HOME_COLOR:
   CALL SET_HOME_COLOR

HOME_POS:
   MOV DX, 0100H
     PUSH DX
   CALL SET_HOME_POS

DISPLAY_HOME: 
  LEA DX, HOME_STR
  MOV AH, 09
  INT 21H

IS_ENTER:
  MOV AH, 10H
    INT 16H
    CMP AL, 0DH
    JE PLAY_GAME
    JMP IS_ENTER

PLAY_GAME:
  RET
DISP_HOME ENDP
;-------------------------------------
SET_HOME_COLOR PROC NEAR      
  MOV AX, 0600H
  MOV BH, 01H
  MOV CX, 0000H
  MOV DX, 184FH
  INT 10H
  RET
SET_HOME_COLOR ENDP
;-------------------------------------
SET_HOME_POS PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, 00   
  MOV DL, 00   
  INT 10H

  RET
SET_HOME_POS ENDP
;-------------------------------------
PLAY PROC NEAR
PLAY_LOOP:
BALL_COLOR:
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

REMOVE_CURSOR:
  CALL CURSOR_REMOVE

KEY_PRESSED:
    MOV AH, 01H   
    INT 16H
    JNZ IS_VALID_INPUT
    CALL DELAY
    JMP UPDATE_PLAYER_POS

IS_VALID_INPUT:
  CALL DELAY
  MOV AH, 00H
    INT 16H

IS_PLAYER1_RIGHT:
  CMP AH, 4DH
  JE PLAYER1_RIGHT
  
IS_PLAYER1_LEFT:
  CMP AH, 4BH
  JE PLAYER1_LEFT

IS_PLAYER2_RIGHT:
  CMP AL, 100
  JE PLAYER2_RIGHT

IS_PLAYER2_LEFT:
  CMP AL, 97
  JE PLAYER2_LEFT

IS_ESC:
  CMP AL, 27
  JE EXIT3
  JMP UPDATE_PLAYER_POS_JMP

EXIT3:
    MOV AX, 4C00H
    INT 21H 

UPDATE_PLAYER_POS_JMP:
  JMP UPDATE_PLAYER_POS

PLAYER1_RIGHT:
  MOV AL, 2
  MOV PLAYER1_MOVE_FLAG, AL
  
  JMP UPDATE_PLAYER_POS

PLAYER1_LEFT:
  MOV AL, 1
  MOV PLAYER1_MOVE_FLAG, AL
  
  JMP UPDATE_PLAYER_POS

PLAYER2_RIGHT:
  MOV AL, 2
  MOV PLAYER2_MOVE_FLAG, AL
  
  JMP UPDATE_PLAYER_POS

PLAYER2_LEFT:
  MOV AL, 1
  MOV PLAYER2_MOVE_FLAG, AL
  
UPDATE_PLAYER_POS:
UPDATE_PLAYER1_POS:
  MOV AL, PLAYER1_MOVE_FLAG

IS_PLAYER1_MOVE_LEFT:
  CMP AL, 1
  JE IS_PLAYER1_LEFT_BOUND
  JMP IS_PLAYER1_MOVE_RIGHT

IS_PLAYER1_LEFT_BOUND:
  MOV BL, PLAYER1_HEAD_COL
  CMP BL, 2
  JE PLAYER1_STOP
  JMP PLAYER1_MOVE_LEFT

PLAYER1_STOP:
  MOV BL, 0
  MOV PLAYER1_MOVE_FLAG, BL
  JMP UPDATE_PLAYER2_POS

IS_PLAYER1_MOVE_RIGHT:
  CMP AL, 2
  JE IS_PLAYER1_RIGHT_BOUND
  JMP UPDATE_PLAYER2_POS

IS_PLAYER1_RIGHT_BOUND:
  MOV BL, PLAYER1_HEAD_COL
  CMP BL, 77
  JE PLAYER1_STOP
  JMP PLAYER1_MOVE_RIGHT

PLAYER1_MOVE_LEFT:
  MOV BL, PLAYER1_HEAD_COL
  DEC BL
  MOV PLAYER1_HEAD_COL, BL

  MOV BL, PLAYER1_BODY_COL
  DEC BL
  MOV PLAYER1_BODY_COL, BL

  MOV BL, PLAYER1_FEET_COL
  DEC BL
  MOV PLAYER1_FEET_COL, BL

  JMP UPDATE_PLAYER2_POS

PLAYER1_MOVE_RIGHT:
  MOV BL, PLAYER1_HEAD_COL
  INC BL
  MOV PLAYER1_HEAD_COL, BL

  MOV BL, PLAYER1_BODY_COL
  INC BL
  MOV PLAYER1_BODY_COL, BL

  MOV BL, PLAYER1_FEET_COL
  INC BL
  MOV PLAYER1_FEET_COL, BL

UPDATE_PLAYER2_POS:
  MOV AL, PLAYER2_MOVE_FLAG

IS_PLAYER2_MOVE_LEFT:
  CMP AL, 1
  JE IS_PLAYER2_LEFT_BOUND
  JMP IS_PLAYER2_MOVE_RIGHT

IS_PLAYER2_LEFT_BOUND:
  MOV BL, PLAYER2_HEAD_COL
  CMP BL, 2
  JE PLAYER2_STOP
  JMP PLAYER2_MOVE_LEFT

PLAYER2_STOP:
  MOV BL, 0
  MOV PLAYER2_MOVE_FLAG, BL
  JMP PLAY_LOOP

IS_PLAYER2_MOVE_RIGHT:
  CMP AL, 2
  JE IS_PLAYER2_RIGHT_BOUND
  JMP PLAY_LOOP

IS_PLAYER2_RIGHT_BOUND:
  MOV BL, PLAYER2_HEAD_COL
  CMP BL, 77
  JE PLAYER2_STOP
  JMP PLAYER2_MOVE_RIGHT  

PLAYER2_MOVE_LEFT:
  MOV BL, PLAYER2_HEAD_COL
  DEC BL
  MOV PLAYER2_HEAD_COL, BL

  MOV BL, PLAYER2_BODY_COL
  DEC BL
  MOV PLAYER2_BODY_COL, BL

  MOV BL, PLAYER2_FEET_COL
  DEC BL
  MOV PLAYER2_FEET_COL, BL

  JMP PLAY_LOOP

PLAYER2_MOVE_RIGHT:
  MOV BL, PLAYER2_HEAD_COL
  INC BL
  MOV PLAYER2_HEAD_COL, BL

  MOV BL, PLAYER2_BODY_COL
  INC BL
  MOV PLAYER2_BODY_COL, BL

  MOV BL, PLAYER2_FEET_COL
  INC BL
  MOV PLAYER2_FEET_COL, BL

  JMP PLAY_LOOP
  
  RET
PLAY ENDP
;---------------------------------------------
SET_BALL_COLOR PROC NEAR
  MOV AX, 0600H   
  MOV BH, 03H     
  MOV CX, 0300H   
  MOV DX, 154FH   
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
;---------------------------------------------
DELAY PROC NEAR
  MOV BP, 2 ;lower value faster
  MOV SI, 2 ;lower value faster
DELAY2:
  DEC BP
  NOP
  JNZ DELAY2
  DEC SI
  CMP SI,0
  JNZ DELAY2
  RET
DELAY ENDP
;---------------------------------------------
CURSOR_REMOVE PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, 25   
  MOV DL, 80 
  INT 10H

  RET
CURSOR_REMOVE ENDP
END MAIN