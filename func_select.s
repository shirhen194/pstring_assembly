.section .data
.align 8    #create place for adresess in 8 jumps
.L1:
    .quad   .L2   #case 50
    .quad   .L3   #case 51 - default
    .quad   .L4   #case 52
    .quad   .L5   #case 53
    .quad   .L6   #case 54
    .quad   .L7   #case 55
    .quad   .L3   #case 56 - default
    .quad   .L3   #case 57 - default
    .quad   .L3   #case 58 - default
    .quad   .L3   #case 59 - default
    .quad   .L2   #case 60

.section .rodata
f_char:     .string   "%c"
f_d:     .string   "%d"
two_chars:     .string   "%c %c"
two_nums:     .string   "%d %d"


    #for 50 60:
format_print50: .string   "first pstring length: %d, second pstring length: %d\n"
    #for 52:
format_print52: .string   "old char: %c, new char: %c, first string: %s, second string: %s\n"
format_print53: .string   "length: %d, string: %s\n"    #for 53
    #in the file theres one eith spce and one without so..:
print54: .string   "length: %d, string: %s\n "   #for 54
format_print55: .string   "compare result: %d\n"    #for 55
print_def: .string   "invalid option!\n"  #for default
print_inv: .string   "invalid input!\n"

.section    .text
.globl  func_run
.type   func_run, @function
func_run:
    xorq    %rax, %rax  #zero the return var
    #zero the calle args
    xorq    %rbx, %rbx
    xorq    %r12, %r12
    xorq    %r13, %r13
    #move caller args to calle because we're calling functions
    movq    %rdi, %rbx  #option
    movq    %rsi, %r12  #&s1
    movq    %rdx, %r13  #&s2
    #create jump table
    #according to practice 5
    leaq    -100(%rbx), %r14    #calc r14 = option - 100
    cmpq    $10, %r14   #compare rsi:10
    ja  .L9  #if rsi > 10 go to default
    jmp*    .L1(,%rsi,8)   #go to the jump table in place[rsi]
.L2:
    #50 or 60
    #guideline:call pstrlen to calc string lengths
    #create args for func pstrlen:
    movq    %r12, %rdi  #string address
    xorq    %rax, %rax  #zero the return var
    #call pstrlen
    call    pstrlen
    #save result:
    movq    %rax, %r15  #length 1
    #for 2 string: create args for func pstrlen:
    #should zero too?
    movq    %r13, %rdi  #string address
    xorq    %rax, %rax  #zero the return var
    #call pstrlen
    call    pstrlen
    #TODO: should save aside rax from 2 func call????? for now i didnt
    #print result by pattern
    #passing the fitting string as first parameter
    movq    $format_print50, %rdi
    movq    %r15, %rsi   #passing the first length as second parameter
    movq    %rax, %rdx   #passing the second length as third parameter
    movq    $0, %rax
    #call to print
    call    printf

.L3:
    #51 or 56-59
    #default case
.L4:
    #52
    #guideline: switch chars using replaceChar

    #create format for scanf (char):
    #move the scanf pattern as first srg(%c %c)
    movq    $two_chars, %rdi
    #TODO: Maybe put args in stack instead of registers(for now its on stack):
    #create space for two chars
    addq    $-2, %rsp
    leaq    2(%rsp), %rsi   #enter oldchar addr space to 1 arg
    leaq    1(%rsp), %rdx   #enter newchar addr space to 2 arg

    #get chars:
    movq    $0, %rax
    call    scanf

    #move chars to their place
    leaq    2(%rsp), %r14   #r14 = old char(rsp +2)
    leaq    1(%rsp), %r15   #r15 = new char(rsp +2)

    #TODO: maybe you can shorten this and not write same code twice??
    #first call to replaceChar:
    #create vars for calling replaceChar:
    leaq    %r12, %rdi  #first string
    movq    %r14, %rsi  #old char
    movq    %r15, %rdx  #new char
    xorq    %rax, %rax  #zero the return var

    #call replace char:
    call    replaceChar
    #save aside return value(s1) in stack:
    subq    $1, %rsp    #place for string1 p in stack
    #TODO: CHECK IF LINE BEFORE AND AFTER ARE WRITTEN CORRECTLY
    movq    %rax, %rsp  #move rax value(p1 addres) to rsp

    #second call to replaceChar:
    #create vars for calling replaceChar:
    movq    %r13, %rdi  #second string
    movq    %r14, %rsi  #old char
    movq    %r15, %rdx  #new char
    xorq    %rax, %rax  #zero the return var

    #call replace char:
    call    replaceChar
    #passing second string as fifth parameter for the printf call
    movq    %rax, %r8
    addq    $1, %r8 #it's value (addres(?))+1 beacause the first place is the length

    #passing the fitting string as first parameter
    movq    $format_print52, %rdi
    #passing oldChar as second parameter
    movq    %r14, %rsi
    #passing newChar as third parameter
    movq    %r15, %rdx
    #passing first string (addres + 1) as forth parameter
    #TODO: SHOULD DO  leaq    1(%rsp), %rcx *OR* pass value to rcx then addq    $1, %rcx ?
    movq    %rsp, %rcx
    addq    $1, %rcx     #it's add+1 beacause the first place is the length

    #print result:
    movq    $0, %rax
    call    printf

.L5:
    #53
    #guideline: copy string using pstrijcpy
    #get two numbers, i - first index, j - second index
    #create format for scanf (number as char):
    #move the scanf pattern as first srg(%s %s)
    movq    $two_chars, %rdi
    #TODO: Maybe put args in stack instead of registers(for now its on stack):
    #create space for two chars
    addq    $-2, %rsp
    leaq    2(%rsp), %rsi   #enter i addr space to 1 arg
    leaq    1(%rsp), %rdx   #enter j addr space to 2 arg

    #get chars:
    movq    $0, %rax
    call    scanf

    #move chars to their place
    leaq    2(%rsp), %r14   #r14 = i(rsp +2)
    leaq    1(%rsp), %r15   #r15 = j(rsp +1)


    #create vars for calling pstrijcpy:
    #Pstring* pstrijcpy(Pstring* dst(first), Pstring* src(second), char i, char j);
    movq    %r12, %rdi  #1. first pstring
    movq    %r13, %rsi  #2. second pstring
    movq    %r14, %rdx  #3. start index = i
    movq    %r15, %rcx  #4. finish index = j
    xorq    %rax, %rax  #zero the return var

    #call pstrijcpy:
    call pstrijcpy
    leaq (%rax), %r15 #move func retrun value (ps 1) to r15
    #TODO: should call strlen to get the strings length (1)?

    #vars for print (first):
    movq    $format_print53, %rdi   #"length: %d, string: %s\n"
    #passing first string as second parameter
    movzbq    (%r15), %rsi #second param - length
    leaq    1(%r15), %rdx #third param - the string(1) (pstring+1)
    #print first string length and value
    movq    $0, %rax
    call    printf

    #TODO: should call strlen to get the string length(2)?

    #vars for print (second):
    movq    $format_print53, %rdi   #"length: %d, string: %s\n"
    #passing first string as second parameter
    movzbq    (%r13), %rsi #second param - length
    leaq    1(%r13), %rdx #third param - the string(2) (pstring+1)
    #print second string length and value
    call    printf

.L6:
    #54
    #guideline: switch stings cases using swapCase
    #create args for func swapCase:
    movq    %r12, %rdi  #string address
    xorq    %rax, %rax  #zero the return var
    #call swapCase
    call    swapCase
    leaq    (%rax), %r15  #save ret value to r15
    #TODO: should call strlen to get the strings length? (twice)

    #vars for print (first):
    movq    $print54, %rdi   #"length: %d, string: %s\n "
    #passing first string as second parameter
    movzbq    (%r15), %rsi  #second param - length
    leaq    1(%r15), %rdx  #third param - the string(1) (pstring+1)
    #print first string length and value
    movq    $0, %rax
    call    printf

    #for 2 string: create args for func swapCase:
    #should zero too?
    movq    %r13, %rdi  #string address
    xorq    %rax, %rax  #zero the return var
    #call pstrlen
    call    swapCase
    leaq    (%rax), %r15  #save ret value to r15

    #vars for print (first):
    movq    $print54, %rdi   #"length: %d, string: %s\n "
    #passing first string as second parameter
    movzbq    (%r15), %rsi  #second param - length
    leaq    1(%r15), %rdx  #third param - the string(1)
    #print first string length and value
    movq    $0, %rax
    call    printf


.L4:
    #55
    #guideline: compare strings using pstrijcmp
    #get two numbers, i - first index, j - second index
    #create format for scanf (number as char):
    #move the scanf pattern as first srg(%s %s)
    movq    $two_chars, %rdi
    #TODO: Maybe put args in stack instead of registers(for now its on stack):
    #create space for two chars
    addq    $-2, %rsp
    leaq    2(%rsp), %rsi   #enter i addr space to 1 arg
    leaq    1(%rsp), %rdx   #enter j addr space to 2 arg

    #get chars:
    movq    $0, %rax
    call    scanf

    #move chars to their place
    leaq    2(%rsp), %r14   #r14 = i(rsp +2)
    leaq    1(%rsp), %r15   #r15 = j(rsp +1)

    #create vars for calling pstrijcmp:
    #int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j);
    movq    %r12, %rdi  #1. first string
    movq    %r13, %rsi  #2. second string
    movq    %r14, %rdx  #3. start index = i
    movq    %r15, %rcx  #4. finish index = j
    xorq    %rax, %rax  #zero the return var

    #call replace char:
    call pstrijcpy

    #save result:
    movq    %rax, %r15  #compersion result




ret

