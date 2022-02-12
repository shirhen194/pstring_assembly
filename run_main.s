.data
.section    .rodata
f_num: .string "%d"
f_str:  .string "%s"
f_char: .string "%hhu"
    .text
.globl  run_main
.type   run_main, @function
run_main:
    pushq   %rbp    #set rbp with new frame's start address
    movq    %rsp, %rbp
    xorq    %rax, %rax  #zero the return var
    subq    $560, %rsp  #open space for input in rsp

    #create space in stack for length 1
    movq    $f_char, %rdi  #insert pattern (%s) 1st arg
    leaq    -257(%rbp), %rsi   #enter l1 addr space to 1 arg
    #get length 1:
    movq    $0, %rax
    call    scanf
    movzbq  -257(%rbp), %rbx   #rbx = i(rsp - 257)  for testing

    #create space in stack for s 1
    movq    $f_str, %rdi  #insert pattern (%s) 1st arg
    leaq    -256(%rbp), %rsi   #enter s1 addr space to 1 arg
    #get s1:
    movq    $0, %rax
    call    scanf
    movzbq  -256(%rbp), %r12   #r12 = i(rsp - 256)

    #create space in stack for length 2
    movq    $f_char, %rdi  #insert pattern (%s) 1st arg
    leaq    -514(%rbp), %rsi   #enter i addr space to 1 arg
    #get l2:
    movq    $0, %rax
    call    scanf
    movzbq  -514(%rbp), %r13   #ps2[0]r13 = i(rsp - 517)

    #create space in stack for s 2
    movq    $f_str, %rdi  #insert pattern (%s) 1st arg
    leaq    -513(%rbp), %rsi   #enter i addr space to 1 arg
    #get s2:
    movq    $0, %rax
    call    scanf
    movzbq  -513(%rbp), %r14   #ps2[1] r14 = i(rsp - 513)

    #create space in stack for option
    movq    $f_num, %rdi  #insert pattern (%d) 1st arg
    leaq    -522(%rbp), %rsi   #enter i addr space to 1 arg
    #get chars:
    movq    $0, %rax
    call    scanf
    movzbq  -522(%rbp), %r14  #save oprion value: for testing


#add /0
#TODO: add /0?

    #create vars for calling pstrijcpy:
    #Pstring* pstrijcpy(Pstring* dst(first), Pstring* src(second), char i, char j);
    movzbq  -522(%rbp), %rdi  #1. option
    leaq    -257(%rbp), %rsi  #2. first pstring
    leaq    -514(%rbp), %rdx  #3. second pstring
    xorq    %rax, %rax  #zero the return var

    call    func_select
    leave
    ret