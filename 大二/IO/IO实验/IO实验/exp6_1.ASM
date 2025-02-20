.8086
.MODEL SMALL
.STACK
.DATA
    COUNT1 DB 0AH
    COUNT2 DB 04H
    COUNT3 DB 0AH
    COUNT4 DB 04H
    STATE DB 10000001B,01000001B,00100100B,
        00100010B,00000001B,00100000B
    INDEX DB 00H
.CODE

INT0 PROC FAR
    PUSH SI
    PUSH AX
    PUSH DX
    PUSH DS
    MOV AX,@DATA
    MOV DS,AX
    
    MOV BL,INDEX
    CMP BL,05H
    JZ S4
    CMP BL,04H
    JZ S2
    CMP BL,03H
    JZ S4
    CMP BL,02H
    JZ S3
    CMP BL,01H
    JZ S2
    
S1:
    MOV BL,COUNT1
    CMP BL,0
    JZ S2
    DEC BL
    MOV COUNT1,BL
    MOV INDEX,00H
    MOV COUNT4,04H
    JMP EXIT

S2:
    MOV BL,COUNT2
    CMP BL,0
    JZ S3
    CMP BL,03H
    JZ S5
    CMP BL,01H
    JZ S5
    DEC BL
    MOV COUNT2,BL
    MOV INDEX,01H
    MOV COUNT1,0AH
    JMP EXIT
    
S3:
    MOV BL,COUNT3
    CMP BL,0
    JZ S4
    DEC BL
    MOV COUNT3,BL
    MOV INDEX,02H
    MOV COUNT2,04H
    JMP EXIT
    
S4:
    MOV BL,COUNT4
    CMP BL,0
    JZ S1
    CMP BL,03H
    JZ S6
    CMP BL,01H
    JZ S6
    DEC BL
    MOV COUNT4,BL
    MOV INDEX,03H
    MOV COUNT3,0AH
    JMP EXIT
    
S5:
    MOV INDEX,04H
    DEC BL
    MOV COUNT2,BL
    JMP EXIT
        
S6:
    MOV INDEX,05H
    DEC BL
    MOV COUNT4,BL
    JMP EXIT
    
EXIT:
    MOV BX,OFFSET STATE
    MOV AL,INDEX
    XLAT
    MOV DX,200H
    OUT DX,AL
    MOV AL,20H
    MOV DX,210H
    OUT DX,AL
    
    POP DS
    POP DX
    POP AX
    POP SI
    
    IRET
INT0 ENDP

START:
    MOV AX,@DATA
    MOV DS,AX
    
    ;8253
    MOV AL,00110111B
    MOV DX,226H
    OUT DX,AL
    MOV DX,220H
    MOV AX,1000H
    OUT DX,AL
    MOV AL,AH
    OUT DX,AL
    
    MOV AL,01110111B
    MOV DX,226H
    OUT DX,AL
    MOV DX,222H
    MOV AX,1000H
    OUT DX,AL
    MOV AL,AH
    OUT DX,AL
    
    ;8255
    MOV AL,10000001B
    MOV DX,206H
    OUT DX,AL
    
    ;8259
    MOV AL,00010011B
    MOV DX,210H
    OUT DX,AL
    MOV AL,00001000B
    MOV DX,212H
    OUT DX,AL
    MOV AL,01H
    OUT DX,AL
    
    CLI
    MOV AX,0
    MOV ES,AX
    MOV SI,0
    MOV CX,255
LP:  
    MOV AX,OFFSET INT0
    MOV ES:[SI],AX
    MOV AX,SEG INT0
    MOV ES:[SI+2],AX
    ADD SI,4
    LOOP LP
    
    MOV AX,OFFSET INT0
    MOV ES:[SI],AX
    MOV AX,SEG INT0
    MOV ES:[SI+2],AX
    
    MOV AX,@DATA
    MOV DS,AX
    STI
    JMP $
    
END START    