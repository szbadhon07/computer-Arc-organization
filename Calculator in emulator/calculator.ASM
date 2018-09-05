.MODEL SMALL
.STACK 100H
.DATA   
                
    exitMsg DB '                           Press E for exit $'
    inpMsg1 DB 'Enter The First Number: $'
    inpMsg2 DB 'Enter The Second Number: $'
    optMsg DB 'Select The Operation < + - * / % >: $'
    resMsg DB 'Result: $'
    NUM1 DW ? 
    NUM2 DW ? 
    TEMPNUM DW ? 
    RES DW ?
    
    NL DB 0Dh,0Ah,'$'
     
.CODE

MAIN PROC
    
    MOV AX,@DATA
    MOV DS,AX  
    
    MOV AH,9
    LEA DX,exitMsg
    INT 21H
    LEA DX,NL
    INT 21H 
    
     
    INP:
        MOV NUM1,-1
        MOV NUM2,-1
        MOV AH,9
        LEA DX,NL 
       
        INT 21H 
        INPP:
        MOV AH,9
        LEA DX,inpMsg1
        INT 21H
        
        
        MOV CX,0D
        LP1:
           MOV AH,1
           INT 21H
           CMP AL,'E'
           JE  EXIT
           CMP AL,'e'
           JE EXIT
           CMP AL,0Dh
           JE CHK
           SUB AX,304
           INC CX
           CMP CX,2           
           JGE AddNextDigit1
           
           MOV NUM1,AX                              
           JMP LP1     
           
           
         LP2:
           MOV AH,1
           INT 21H
           CMP AL,'E'
           JE  EXIT
           CMP AL,'e'
           JE EXIT
           CMP AL,0Dh
           JE CHK2
           SUB AX,304
           INC CX
           CMP CX,2           
           JGE AddNextDigit2
           
           MOV NUM2,AX                              
           JMP LP2
             
            
           AddNextDigit1: 
                       
                       MOV TEMPNUM,AX
                       MOV AX,NUM1
                       MOV BX,10D
                       MUL BX
                       ADD AX,TEMPNUM
                       MOV NUM1,AX
                       JMP LP1
           
           
           AddNextDigit2:
                       
                       MOV TEMPNUM,AX
                       MOV AX,NUM2
                       MOV BX,10D
                       MUL BX
                       ADD AX,TEMPNUM
                       MOV NUM2,AX
                       JMP LP2
        
        CHK:
            
            CMP NUM1,-1
            JE INPP 
            MOV CX,0
            MOV AH,9
            LEA DX,NL
            INT 21H
            CHK3:
            MOV AH,9
            LEA DX,inpMsg2
            INT 21H   
            JMP LP2
         
        CHK2:
            CMP NUM2,-1
            JE CHK3
            MOV AH,9
            LEA DX,NL
            INT  21H
            
            JMP OPT
        
        OPT:
            
            MOV AH,9
            LEA DX,optMsg
            INT 21H
            MOV AH,1
            INT 21H
            
            CMP AL,'+'
            JE DO_ADD
            CMP AL,'-'
            JE DO_SUB
            CMP AL,'*'
            JE DO_MUL
            CMP AL,'/'
            JE DO_DIV
            CMP AL,'%'
            JE DO_MOD
            CMP AL,'E'
            JE  EXIT
            CMP AL,'e'
            JE EXIT
            JMP OPT
         DO_ADD:
            
            MOV AX,NUM1
            ADD AX,NUM2
            MOV RES,AX
            
            JMP PRINT
         
         DO_SUB:
            MOV AX,NUM1
            SUB AX,NUM2
            MOV RES,AX
            
            JMP PRINT
         
         DO_MUL:
            MOV AX,NUM1
            MUL NUM2
            MOV RES,AX
            JMP PRINT
                          
         DO_DIV:
            MOV AX,NUM1
            XOR DX,DX
            CWD 
            DIV NUM2
            MOV RES,AX
            JMP PRINT       
         
         DO_MOD:
            MOV AX,NUM1
            XOR DX,DX
            CWD 
            DIV NUM2
            MOV RES,DX
            JMP PRINT 
            
            
         PRINT: 
            MOV AH,9
            LEA DX,NL
            INT 21H
            MOV CX,0
            MOV AX,RES 
            MOV BH,10
            
            PR1:         
           
            DIV BH
            PUSH AX
            INC CX
            
            MOV AH,0
            CMP AL,0
            JNE PR1
                       
            MOV AH,9
            LEA DX,resMsg
            INT  21H
            PRT:
               MOV AH,2
               POP DX
               MOV DL,DH
               ADD DL,'0'
               INT 21H
               DEC CX
               CMP CL,0
               JNE PRT
               
               MOV AH,9
               LEA DX,NL
               INT 21H
               JMP INP
               
          EXIT:
            MOV AH,4CH
            INT 21H      
              
    MAIN ENDP

END MAIN