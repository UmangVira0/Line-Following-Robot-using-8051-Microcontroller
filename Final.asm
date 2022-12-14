			$MOD51

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			COUNTER		EQU		30H
			DISPLAY_1		BIT		P0.6
			DISPLAY_2		BIT		P0.7
			BZR			BIT		P0.5
			SW_UP			BIT		P1.7
			SW_DWN		BIT		P1.6	
			D1			EQU		COUNTER	+ 1
			D2			EQU		COUNTER	+ 2
			D3			EQU		COUNTER	+ 3		
			VAR			EQU		COUNTER + 4
			DLY_RES		EQU		COUNTER+5
			DEST_RES		EQU		COUNTER+6
			SOURCE_RES		EQU		COUNTER+7
			PATH_RES		EQU		COUNTER+8




			F_L			BIT		01H	;LOW WHEN BLACK
			F_R			BIT		00H
			M_L			BIT		03H
			M_R			BIT		02H
			POS_1			BIT		04H	
			POS_2			BIT		05H
			POS_3			BIT		06H
			JUNCTION		BIT		08H	;High when Stop	
			TRACK_STAT		BIT		P3.4	;HIGH WHEN BLACK		
			ADD0			BIT		P3.5
			ADD1			BIT		P3.6
			ADD2			BIT		P3.7	


			PINK			BIT		P0.3
			R_BLU			BIT		P0.2
			L_BLU			BIT		P0.4

				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			ORG 00H
			MOV SP,#65H
			SETB TRACK_STAT
			SETB P3.3
			SETB F_L
			SETB F_R
			
			
			CALL LONG_BEEP
			MOV COUNTER,#05
	FLS_NXT:	CLR R_BLU	
			CALL DLY	
			CLR	PINK
			CALL DLY
			CLR L_BLU	
			CALL DLY
			CALL DLY
			SETB R_BLU	
			SETB PINK
			SETB L_BLU	
			CALL DLY
			CALL DLY
			DJNZ COUNTER,FLS_NXT
			MOV 20H,#0FFH
			SETB R_BLU	
			SETB PINK
			SETB L_BLU	

			CALL BEEP
		
			;;;;;   S E L E C T  D E S T I N A T I O N ;;;;;;

			CLR DISPLAY_1
			SETB DISPLAY_2

			MOV COUNTER,#00H
			CALL DIS_COUNT


WAIT:			JB SW_UP,CHK_DWN
			CALL DLY
			JB SW_UP,CHK_DWN
			
		
			INC COUNTER
			CALL DIS_COUNT
			CALL DLY_3
			MOV A,COUNTER
			CJNE A,#07H,NO_7
			MOV COUNTER,#00H
			CALL BEEP			
NO_7:			JMP WAIT

CHK_DWN:		JB SW_DWN,WAIT	
			CALL DLY
			JMP START_ROBO

			;;;;;   S E L E C T  D E S T I N A T I O N ;;;;;;






			;;;;;   S T A R T   R O B O  ;;;;;;

START_ROBO:	MOV DEST_RES,COUNTER	;01:07H
			CALL DIS_DEST		;DISPLAY DEST ON 7 SEGMENT

			CALL BEEP
			JNB SW_DWN,$

			SETB P3.3
			;;;;;   S T A R T   R O B O  ;;;;;;

FIRST_MOVE:	CLR JUNCTION	;LOW FOR NORMANL OPERATION
			CALL HIGH_WAY		;go till white line  or till 2 white
			CALL ROAD_CROSS
CHK_POSITION:	CALL POSITION	;DISPLAY POSITION ON 7 SEGMENT
			CALL DLY_3
			CALL DLY_3
			CALL BEEP
			JMP MAKE_PATH

			


		
			;;;   F I N D   T R A C K   N U M B E R  ;;;;;;
			;DEST_RES  1:7		;06H
			;SOURCE_RES  1:7	;01H   16H
MAKE_PATH:		MOV A,SOURCE_RES		;01H
			SWAP A			;10H
			ORL A,DEST_RES		;16H
			MOV PATH_RES,A		;SAVE 16H IN PATH RES

			MOV A,SOURCE_RES		;01H
MAY_1:		CJNE A,#01H,MAY_2
			JMP TRACK_1
MAY_2:		CJNE A,#02H,MAY_3
			JMP TRACK_2
MAY_3:		CJNE A,#03H,MAY_4
			JMP TRACK_3
MAY_4:		CJNE A,#04H,MAY_5
			JMP TRACK_4
MAY_5:		CJNE A,#05H,MAY_6
			JMP TRACK_5
MAY_6:		CJNE A,#06H,MAY_7
			JMP TRACK_6
MAY_7:		CJNE A,#07H,NO_MATCH
			JMP TRACK_7


NO_MATCH:
STAY_BEEP:		CALL BEEP
			JMP STAY_BEEP


			;;;   F I N D   DETAIL T R A C K-1   N U M B E R  ;;;;;;


TRACK_1:		MOV A,PATH_RES
CHK_11:		CJNE A,#11H,CHK_12
			JMP NO_MOVE
CHK_12:		CJNE A,#12H,CHK_13
			JMP TRACK_12
CHK_13:		CJNE A,#13H,CHK_14
			JMP TRACK_13
CHK_14:		CJNE A,#14H,CHK_15
			JMP TRACK_14
CHK_15:		CJNE A,#15H,CHK_16
			JMP TRACK_15
CHK_16:		CJNE A,#16H,CHK_17
			JMP TRACK_16
CHK_17:		CJNE A,#17,CHK_1_OUT
			JMP TRACK_17
			
CHK_1_OUT:		JMP EXIT_TRACK
	
			;;;   F I N D   DETAIL T R A C K-2   N U M B E R  ;;;;;;	


TRACK_2:		MOV A,PATH_RES
CHK_21:		CJNE A,#21H,CHK_22
			JMP TRACK_21
CHK_22:		CJNE A,#22H,CHK_23
			JMP NO_MOVE
CHK_23:		CJNE A,#23H,CHK_24
			JMP TRACK_23
CHK_24:		CJNE A,#24H,CHK_25
			JMP TRACK_24
CHK_25:		CJNE A,#25H,CHK_26
			JMP TRACK_25
CHK_26:		CJNE A,#26H,CHK_27
			JMP TRACK_26
CHK_27:		CJNE A,#27,CHK_2_OUT
			JMP TRACK_27
			
CHK_2_OUT:		JMP EXIT_TRACK



			;;;   F I N D   DETAIL T R A C K-3   N U M B E R  ;;;;;;	


TRACK_3:		MOV A,PATH_RES
CHK_31:		CJNE A,#31H,CHK_32
			JMP NO_MOVE
CHK_32:		CJNE A,#32H,CHK_33
			JMP TRACK_32
CHK_33:		CJNE A,#33H,CHK_34
			JMP NO_MOVE
CHK_34:		CJNE A,#34H,CHK_35
			JMP TRACK_34
CHK_35:		CJNE A,#35H,CHK_36
			JMP TRACK_35
CHK_36:		CJNE A,#36H,CHK_37
			JMP TRACK_36
CHK_37:		CJNE A,#37,CHK_3_OUT
			JMP TRACK_37
			
CHK_3_OUT:		JMP EXIT_TRACK


			;;;  D O  I T  Y O UR   S E  L F  ;;;

			;;;   F I N D   DETAIL T R A C K-4   N U M B E R  ;;;;;;	


TRACK_4:		MOV A,PATH_RES
CHK_41:		CJNE A,#41H,CHK_42
			JMP TRACK_41
CHK_42:		CJNE A,#42H,CHK_43
			JMP TRACK_42
CHK_43:		CJNE A,#43H,CHK_44
			JMP TRACK_43
CHK_44:		CJNE A,#44H,CHK_45
			JMP NO_MOVE
CHK_45:		CJNE A,#45H,CHK_46
			JMP TRACK_45
CHK_46:		CJNE A,#46H,CHK_47
			JMP TRACK_46
CHK_47:		CJNE A,#47,CHK_4_OUT
			JMP TRACK_47
			
CHK_4_OUT:		JMP EXIT_TRACK


			;;;   F I N D   DETAIL T R A C K-5   N U M B E R  ;;;;;;	


TRACK_5:		MOV A,PATH_RES
CHK_51:		CJNE A,#51H,CHK_52
			JMP TRACK_51
CHK_52:		CJNE A,#52H,CHK_53
			JMP TRACK_52
CHK_53:		CJNE A,#53H,CHK_54
			JMP TRACK_53
CHK_54:		CJNE A,#54H,CHK_55
			JMP TRACK_54
CHK_55:		CJNE A,#55H,CHK_56
			JMP NO_MOVE
CHK_56:		CJNE A,#56H,CHK_57
			JMP TRACK_56
CHK_57:		CJNE A,#57,CHK_5_OUT
			JMP TRACK_57
			
CHK_5_OUT:		JMP EXIT_TRACK


			;;;   F I N D   DETAIL T R A C K-6   N U M B E R  ;;;;;;	


TRACK_6:		MOV A,PATH_RES
CHK_61:		CJNE A,#61H,CHK_62
			JMP TRACK_61
CHK_62:		CJNE A,#62H,CHK_63
			JMP TRACK_62
CHK_63:		CJNE A,#63H,CHK_64
			JMP TRACK_63
CHK_64:		CJNE A,#64H,CHK_65
			JMP TRACK_64
CHK_65:		CJNE A,#65H,CHK_66
			JMP TRACK_65
CHK_66:		CJNE A,#66H,CHK_67
			JMP NO_MOVE
CHK_67:		CJNE A,#67,CHK_6_OUT
			JMP TRACK_67
			
CHK_6_OUT:		JMP EXIT_TRACK


			;;;   F I N D   DETAIL T R A C K-7   N U M B E R  ;;;;;;	


TRACK_7:		MOV A,PATH_RES
CHK_71:		CJNE A,#71H,CHK_72
			JMP TRACK_71
CHK_72:		CJNE A,#72H,CHK_73
			JMP TRACK_72
CHK_73:		CJNE A,#73H,CHK_74
			JMP TRACK_73
CHK_74:		CJNE A,#74H,CHK_75
			JMP TRACK_74
CHK_75:		CJNE A,#75H,CHK_76
			JMP TRACK_75
CHK_76:		CJNE A,#76H,CHK_77
			JMP TRACK_76
CHK_77:		CJNE A,#77,CHK_7_OUT
			JMP NO_MOVE
			
CHK_7_OUT:		JMP EXIT_TRACK



			;;;;;;;;;;;;;;;;;   T R A CK   E N D  ;;;;;;;;;;;




EXIT_TRACK:	jmp $


NO_MOVE:		JMP $






TRACK_12:		CALL DIS_DEST
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CALL LEFT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL RIGHT_90
			CLR JUNCTION
			JMP  PARKED









TRACK_13:		CALL DIS_DEST
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CALL DIS_DEST
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CALL LEFT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL RIGHT_90
			CLR JUNCTION
			JMP  PARKED




TRACK_14:		CALL DIS_DEST
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CALL DIS_DEST
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CALL RIGHT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CALL DIS_DEST
			CALL LEFT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL RIGHT_90
			CLR JUNCTION
			JMP  PARKED



TRACK_15:		CALL DIS_DEST
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CALL RIGHT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL RIGHT_90
			CLR JUNCTION
			JMP  PARKED



TRACK_16:		CALL DIS_DEST
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION		;DIS-2
			CALL DLY_POS
			CALL RIGHT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS		;DIS-5
			CALL RIGHT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION		;DIS-6
			CALL DLY_POS
			CALL LEFT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL RIGHT_90
			CLR JUNCTION
			JMP  PARKED


TRACK_17:		CALL DIS_DEST
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION		;DIS-1
			CALL DLY_POS
			CALL RIGHT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION		;DIS-2
			CALL DLY_POS
			CALL RIGHT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION		;DIS-6		
			CALL DLY_POS
			CALL RIGHT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION		;DIS-7/P
			CALL DLY_POS	
			CALL RIGHT_90
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL POSITION
			CALL DLY_POS
			CLR JUNCTION
			CALL HIGH_WAY
			CALL ROAD_CROSS
			CALL RIGHT_90
			CLR JUNCTION
			JMP  PARKED


		;;   T R A  C K   21  : 27

TRACK_21:		

TRACK_23:	
TRACK_24:	

TRACK_25:	
TRACK_26:	
TRACK_27:	

		;;   T R A  C K   31  : 37

TRACK_31:		

TRACK_32:	
TRACK_34:	

TRACK_35:	
TRACK_36:	
TRACK_37:	

			;;   T R A  C K   41  : 47
TRACK_41:		
TRACK_42:
TRACK_43:	
	

TRACK_45:	
TRACK_46:	
TRACK_47:	

			;;   T R A  C K   51  : 57
TRACK_51:		
TRACK_52:
TRACK_53:	
TRACK_54:	
TRACK_56:	
TRACK_57:	

			;;   T R A  C K   61  : 67
TRACK_61:		
TRACK_62:
TRACK_63:	
TRACK_64:
TRACK_65:		
TRACK_67:	

			;;   T R A  C K   71  : 77

TRACK_71:
TRACK_72:		
TRACK_73:	
TRACK_74:
TRACK_75:		
TRACK_76:	


START:		
			CLR JUNCTION	;LOW FOR NORMANL OPERATION

			CALL ROAD_CROSS
			
STAY:			CALL POSITION
			JMP STAY




			
			CALL LEFT_90
			
			CALL HIGH_WAY



			;LOW WHEN BLACK
LEFT_90:		

LEFT_1:		CALL STATUS_F
			CALL S_L_T
			JB F_L,LEFT_1	
			CALL  INFORM
			
			
LEFT_2:		CALL STATUS_F
			CALL S_L_T
			JNB F_L,LEFT_2
			CALL  INFORM

LEFT_3:		CALL STATUS_F
			CALL S_L_T
			JB F_L,LEFT_3	
			CALL  INFORM



			CALL STATUS_F
			
			RET

RIGHT_90:		RET


PARKED:		JMP $


INFORM:		CALL STOP
			CALL BEEP
			MOV DLY_RES,#10
			CALL DLY_V
			RET


ROAD_CROSS:	CALL STATUS_M
			MOV A,20H
			ANL A,#00001100B		;XXXXYYXX
			XRL A,#00001100B		
			JZ CROSS_DONE
			CALL FOR	
			MOV DLY_RES,#01H
			CALL DLY_V
			CALL STOP
			MOV DLY_RES,#10H
			CALL DLY_V
			JMP ROAD_CROSS

			
CROSS_DONE:	CALL STOP
			CALL BEEP
			CALL STATUS_M
			RET




STATUS_M:		CALL SELECT_L_M		;XXXX YXXX
			CALL SDLY
			CLR C
			MOV C,TRACK_STAT
			CPL	C
			MOV M_L,C
			MOV PINK,C

			CALL SELECT_R_M		;XXXX XYXX
			CALL SDLY
			CLR C
			MOV C,TRACK_STAT
			CPL	C
			MOV M_R,C
			MOV R_BLU,C
			RET


STATUS_F:		CALL SELECT_L_F		;XXXX XXYX
			CALL SDLY
			CLR C
			MOV C,TRACK_STAT
			CPL	C
			MOV F_L,C
			MOV PINK,C

			CALL SELECT_R_F		;XXXX XXXY
			CALL SDLY
			CLR C
			MOV C,TRACK_STAT
			CPL	C
			MOV F_R,C
			MOV R_BLU,C
			RET








SHOW_STATUS:	CALL GET_STATUS
			CALL DISP_STATUS
			RET






SHOT_BREAK:		CALL REV
			MOV DLY_RES,#05H
			CALL DLY_V
			CALL STOP
			CALL BEEP
			RET

HIGH_WAY:		CALL GET_STATUS	
			CALL DISP_STATUS
			CALL FUNCTION
			JNB JUNCTION,HIGH_WAY
			RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;;;; IR SUBROUTINE ;;;;

DISP_STATUS:	CLR C
			MOV C, F_L
			MOV R_BLU, C
			MOV C, F_R
			MOV PINK, C
			RET


POSITION:		

NO_1:			CALL SELECT_PS_1				;GET 1 POSITION IR STATUS
			CALL SDLY
			
			MOV C,TRACK_STAT
			CPL	C
			MOV POS_1, C
			MOV R_BLU,C

NO_2:			CALL SELECT_PS_2				;GET 2 POSITION IR STATUS
			CALL SDLY
			MOV C,TRACK_STAT
			CPL	C
			MOV POS_2, C
			MOV PINK,C

NO_3:			CALL SELECT_PS_3				;GET 3 POSITION IR STATUS
			CALL SDLY
			MOV C,TRACK_STAT
			CPL	C
			MOV POS_3, C
			MOV L_BLU,C


			MOV A,20H		;NYYYNNNN
			SWAP A		;NNNNNYYY
			ANL A,#00000111B	;00000YYY
			MOV SOURCE_RES,A	; SAVE POSITION IN SOURCE_RES
			CALL DIS_SOURCE
			RET

GET_STATUS:	SETB P3.3
			CALL SELECT_L_F					;GETS L_F AND R_F IR STATUR
			CALL SDLY
			CLR C
			MOV C,TRACK_STAT
			
			CPL	C
			MOV F_L,C
			;MOV PINK,C	


			CALL SELECT_R_F
			CALL SDLY
			CLR C
			MOV C,TRACK_STAT
			
			CPL	C
			MOV F_R,C
			;MOV BLU,C
			RET

SELECT_L_F:	CLR ADD2
			CLR ADD1
			CLR ADD0
			RET
			
SELECT_R_F:	CLR ADD2
			CLR ADD1
			SETB ADD0
			RET
			
SELECT_L_M:	CLR ADD2
			SETB ADD1
			CLR ADD0
			RET
						
SELECT_R_M:	CLR ADD2
			SETB ADD1
			SETB ADD0
			RET
						
SELECT_PS_4:SETB ADD2
			CLR ADD1
			CLR ADD0
			RET
						
SELECT_PS_1:SETB ADD2
			CLR ADD1
			SETB ADD0
			RET
						
SELECT_PS_3:SETB ADD2
			SETB ADD1
			CLR ADD0
			RET
						
SELECT_PS_2:SETB ADD2
			SETB ADD1
			SETB ADD0
			RET
					
		;;;; MOTOR SUBROUTINE ;;;;	
			
FUNCTION:	MOV A, 20H						;TO PERFORM FUNCTION ACC TO IR STATUS
			;MOV A, #00000001B		
			ANL A, #00000011B
GO_0:		CJNE A, #00H, GO_1
			CALL FOR
			RET
GO_1:		CJNE A, #01H, GO_2
			CALL L_L_T
			RET
GO_2:		CJNE A, #02H, GO_3
			CALL L_R_T
			RET
GO_3:			CJNE A, #03H, GO_OUT
			CALL STOP
			SETB JUNCTION	;
			RET			
GO_OUT:		RET


FOR:			CLR P1.3
			SETB P1.2
			SETB P1.1
			CLR P1.0
			RET
REV:			SETB P1.3
			CLR P1.2
			CLR P1.1
			SETB P1.0
			RET

S_R_T:		CLR P1.0
			SETB P1.1
			CLR P1.2	
			SETB P1.3
			RET

L_L_T:		SETB P1.3
			SETB P1.2
			SETB P1.1
			CLR P1.0
			RET

L_R_T:		CLR P1.3
			SETB P1.2
			SETB P1.1
			SETB P1.0
			RET
			
STOP:		SETB P1.3
			SETB P1.2
			SETB P1.1
			SETB P1.0
			;CALL DLY
			;CALL POS_STATUS
			RET
	

		

S_L_T:		SETB P1.0
			CLR P1.1
			SETB P1.2	
			CLR P1.3
			RET

		;;;; BUZZER SUBROUTINE ;;;;
BEEP:			CLR BZR 	; BUZZER ON
			CALL DLY
			SETB BZR	;BUZZER OFF
			RET

LONG_BEEP:		CLR BZR 	; BUZZER ON
			CALL LDLY
			CALL LDLY
			CALL LDLY	
			SETB BZR	;BUZZER OFF
			RET

		;;;; 7SEG DISP ;;;;	
DISP:			MOV DPTR, #TABLE
			MOVC A, @A+DPTR
			MOV P2, A
			RET
			
	
DIS_DEST:		CLR DISPLAY_1	;ON RIGHT DISPLAY
			SETB DISPLAY_2	;OFF LEFT DISPLAY
			MOV DPTR,#TABLE
			MOV A,DEST_RES
			MOVC A,@A+DPTR
			MOV P2,A
			RET	


DIS_SOURCE:	CLR DISPLAY_2	;ON LEFT DISPLAY
			SETB DISPLAY_1	;OFF RIGHT DISPLAY
			MOV DPTR,#TABLE
			MOV A,SOURCE_RES
			MOVC A,@A+DPTR
			MOV P2,A
			RET


DIS_COUNT:		MOV DPTR,#TABLE
			MOV A,COUNTER
			MOVC A,@A+DPTR
			MOV P2,A
			RET	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DELAY LOOP ;;;;;;;;;;;;;;;;;;;;;;;;

SDLY:		MOV R1, #100
DL6:		DJNZ R1, DL6
			RET

DLY:		MOV R1, #255
DL5:		MOV R2, #255
DL4:		DJNZ R2, DL4
			DJNZ R1, DL5
			RET

DLY_3:	MOV D1, #05H
DL1:		MOV D2, #0FFH
DL2:		MOV D3, #0FFH
DL3:		DJNZ D3, DL3
			DJNZ D2, DL2
			DJNZ D1, DL1
			RET

DLY_V:	MOV D1, DLY_RES
DLA1:		MOV D2, #200
DLA2:		MOV D3, #200
DLA3:		DJNZ D3, DLA3
			DJNZ D2, DLA2
			DJNZ D1, DLA1
			RET

DLY_POS:		CALL DLY_3
			CALL DLY_3
			RET
	
LDLY:			CALL DLY
			CALL DLY
			CALL DLY
			CALL DLY
			RET		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;; SAVE LOCATION ;;;;;;;;;;;;;;;;;;;;;;

			ORG 0800H
TABLE:		;DB	08H,28H,48H,68H,88H,0A8H,0C8H,0E8H			
			DB	0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			END
