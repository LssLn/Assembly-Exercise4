.data
ST: .space 16
stack: .space 32

msg1: .asciiz "Inserisci una stringa con 8 lettere minuscole"
msg2: .asciiz "Numero = %d\n" ;# num 1° arg msg2

p1sys5: .space 8
num: .space 8 ;# 1° arg msg2 = conta dalla funct

p1sys3: .word 0 ;#fd null
ind: .space 8
dim: .word 16 ;# numbyte da leggere <= ST

.code 
;# init stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s0,$0,0 ;#       $s0 = i =0
;#for(i=0;i<3;i++)
for:
    slti $t0,$s0,3 ;#$t0=0 quando $s0 (i) >= 3
    beq $t0,$0,exit ;# exit per $t0=0, fine ciclo

    ;# printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# scanf ST
    daddi $t0,$0,ST
    sd $t0,ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    
    move $s1,r1     ;# $s1 = strlen
    daddi $a0,$0,ST     ;# $a0 = ST
    ;# if(strlen(ST)==8){
    daddi $t1,$0,8  ;# $t1 = 8 per confronto if
    bne $s1,$t1,incr ;# se strlen!==8 va a incr, scorre il for
        ;# se lo è fa la funzione+printf msg2 e poi va a incr
    jal elabora ;# solo $a0 = ST
    sd r1,num($0)   ;# num = r1 (return conta); 1° arg msg2
    ;# printf msg2
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# vado comunque a incr
incr:
    daddi $s0,$s0,1 ;# i++
    j for
elabora:
    ;# $a0 = ST
    daddi $sp,$sp,-16
    sd $s2,0($sp) ;# i
    sd $s3,8($sp) ;# conta
    daddi $s2,$0,0 ;# i = 0
    daddi $s3,$0,0 ;# conta = 0
for_f:
    slti $t0,$s2,8 ;# $t0=0 quando $s2 (i) >= 8
    beq $t0,$0,return ;#return quando $t0=0
     ;# conta=conta+st[i]-97
    ;# st[i]
    dadd $t0,$a0,$s2 ;# $t0 = &st[i] = $a0 (st) + $s2 (i)
    lbu $t1,0($t0) ;# $t1 = st[i]
    dadd $s3,$s3,$t1 ;# conta=conta+st[i]
    daddi $s3,$s3,-97 ;# -97

    ;# incr
    daddi $s2,$s2,1
    j for_f
return:
    move r1,$s3      ;# r1 = conta ($s3)
    ld $s2,0($sp)
    ld $s3,8($sp)
    daddi $sp,$sp,16

    jr $ra
exit:
    syscall 0
