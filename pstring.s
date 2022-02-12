.section .rodata
print_inv: .string   "invalid input!\n"

.globl  pstrlen
.type   pstrlen,@function

    #gets string length
pstrlen:
    #char pstrlen(Pstring* pstr);
    xor %rax, %rax
    movq (%rdi), %rax
    ret


.globl  replaceChar
.type   replaceChar, @function
    #replaces occurences of oldchar with new char
replaceChar:
    #Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar);
    movq    %rdi, %rbx  #move the rdi pointer(string) to rbx
    movq    %rsi, %r12  #move oldchar to r12
    movq    %rdx, %r13  #move newchar to r13

    #get string length:
    #for the second string - create args for func pstrlen:
    movq    %rbx, %rdi  #string address
    xorq    %rax, %rax  #zero the return var
    #call pstrlen function:
    call    pstrlen
    #save length:
    movq    %rax, %r14  #string length
    xorq %r15, %r15 #zero the i var
    movq    %rbx, %rax  #move str to return value

    #loop
.L1:
    addq    $1, %r15    #i++
.L2:
    cmpq    %r14, %r15  #compare str length(r14) and i(r15)
    jl  .IN_LOOP    #jump inside the loop if i(r15) < (r14)str length
    jmp .OUT_LOOP   #jump out of the loop
.IN_LOOP:
    #get pstr->str[i] to compare to oldchar
    leaq    1(%rbx), %rbx     # advance rbx to next char
    cmpb    (%rbx), %r12b    #b(s[i])-a(oldChar), set flags
    jne .L1 #if its not equal to 0 meaning its not the same char jump to else
    #if it is the same char so a replace:
    movb    %r13b, (%rbx)  #switch current char s[i] = new char(r13)
    #continue loop
    jmp .L1
.OUT_LOOP:
    ret


.globl  pstrijcpy
.type   pstrijcpy, @function
    #copies string to string
pstrijcpy:
    #Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j);
    movq    %rdi, %rbx #move the rdi pointer(string dst) to rbx
    movq    %rsi, %r12 #move string src to r12
    #TODO: should get numeric value of i and j
    movq    %rdx, %r13 #move i to r13
    movq    %rcx, %r14 #move j to r14

.L_CHECK_1:
    #for the first string - create args for func pstrlen:
    movq    %rbx, %rdi  #string address
    #get string length:
    xorq    %rax, %rax  #zero the return var
    #call pstrlen function:
    call    pstrlen
    #save length:
    movq    %rax, %r15  #string length


    #validity check for string:
    cmp %r13, %r15  #compare i:length (length - i)
    #TODO: CHECK IF SHOLUD DO  > OR >=
    jg .VALID  #src->len(r15) > i

    cmp %r14, %r15  #compare j:length (length - j)
    #TODO: CHECK IF SHOLUD DO  < OR <=
    jl .VALID  #src->len(r15) < j



.L_CHECK_2:
    #for the SECOND string - create args for func pstrlen:
    movq    %r12, %rdi  #string address
    #get string length:
    xorq    %rax, %rax  #zero the return var
    #call pstrlen function:
    call    pstrlen
    #save length:
    movq    %rax, %r15  #string length


    #validity check for string:
    cmp %r13, %r15  #compare i:length (length - i)
    #TODO: CHECK IF SHOLUD DO  > OR >=
    jg .VALID  #src->len(r15) > i

    cmp %r14, %r15  #compare j:length (length - j)
    #TODO: CHECK IF SHOLUD DO  < OR <=
    jl .VALID  #src->len(r15) < j


    #if validity check was bad:
.NOT_VALID:
    movq    %rbx, %rax  #move dst to retun value
    #print result by pattern
    #passing the fitting pattern:
    movq    $print_inv, %rdi    #"invalid input!\n"
    movq    $0, %rax
    #call to print
    call    printf
    jmp .FINISH


    #if validity check was good:
.VALID:
    movq    %rbx, %rax  #move dst to retun value
    #loop
.I_ADD:
    addq    $1, %r13    #i++, we do it in the begining too because first bot is len
.CHECK_TERM:
    cmpq    %r14, %r13  #compare str j(r14) i(r13)
    jle  .IN_LOOP    #jump inside the loop if (r13)i <= j(r14)
    jmp .FINISH   #jump out of the loop
.IN_LOOP:
    leaq    (%rbx,%r13), %rbx  # (rbx)dst = &dst + i
    #rbx 8 bit is bl
    movb    (%r12, %r13), %bl #(src, i), move src(r12)[i] to dst(rbx)[i]
    jmp .I_ADD  #return to i++
.FINISH:
    ret




.globl  swapCase
.type   swapCase, @function
    #swap chars case in string
swapCase:
    #Pstring* swapCase(Pstring* pstr);
    movq    %rdi, %rbx #move the rdi pointer(string dst) to rbx

    #create args for func pstrlen:
    movq    %rbx, %rdi  #string address
    #get string length:
    xorq    %rax, %rax  #zero the return var
    #call pstrlen function:
    call    pstrlen
    #save length:
    movq    %rax, %r15  #string length

    movq    %rbx, %rax  #move str1 to return value

    #loop
.L1:
    addq    $1, %r15    #i++
.L2:
    cmpq    %r14, %r15  #compare str length(r14) and i(r15)
    jl  .IN_LOOP    #jump inside the loop if i(r15) < (r14)str length
    jmp .OUT_LOOP   #jump out of the loop
.IN_LOOP:
    #get pstr->str[i] to compare to oldchar
    leaq    1(%rbx), %rbx   # advance rbx to next char
    cmpb    (%rbx), %r12b   #b(s[i])-a(65), set flags
    cmp %r13, %r15  #compare i:length (length - i)
    #TODO: CHECK IF SHOLUD DO  > OR >=
    jg .VALID  #src->len(r15) > i
.CHECK_LOW:
    cmpb    (%rbx), $65   #b(s[i])-a(65), set flags

.CHEK_UP:
    jne .L1 #if its not equal to 0 meaning its not the same char jump to else
    #if it is the same char so a replace:
    movb    %r13b, (%rbx)  #switch current char s[i] = new char(r13)
    #continue loop
    jmp .L1
.OUT_LOOP:
    ret

.globl pstrijcmp
.type pstrijcmp, @function

pstrijcmp:

ret