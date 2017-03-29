
.model small
.stack 100h
.data
len    db 200
res db 0
string  db 200 dup('$')
number    db 'number$'
.code
shift    proc    near
cld
mov        di, si
xor        cx, cx
shiftstart:
mov        bl, byte ptr [si]
cmp        bl, '$'
je         add6
inc        cx
inc        si
jmp        shiftstart
add6:
inc        cx
mov        di, si
add        di, 6
process:
mov        bl, byte ptr [si]
mov        byte ptr [di], bl
dec        si
dec        di
loop    process
ret
shift    endp
copy    proc near
cld
lea        si, number
mov        cx, 6
rep        movsb
ret
copy    endp
find    proc near
mov        di, si
mov        bl, 1  
mov        ah, byte ptr[si]
cmp        ah, ' '
je         loopprobel
cmp        ah, 13
je         fullret
xstart:
mov        ah, byte ptr[si]
cmp        ah, 13
je         endprog
cmp        ah, ' '
je        probel
jmp        numbercheck
probel:
cmp        bl, 1
je         outproc
mov        bl, 1
jmp        loopprobel
outproc:
mov        ax, di 
ret
endprog:
cmp        bl, 1
je        outproc
mov        ax, 0
ret
numbercheck:
mov        ah, byte ptr[si] 
cmp        ah, '0'
jl        notnumber
cmp        ah, '9'
jg        notnumber  
inc        si
jmp       xstart
notnumber:          
mov        bl, 0 
inc        si
jmp        xstart
xx6:
mov        di, si
inc        si
jmp        xstart
loopprobel:
mov        ah, byte ptr[si] 
cmp        ah, ' '
jne        numbercheck
inc        si
mov        ah, byte ptr[si]
cmp        ah, 13
je         fullret
mov        di, si
jmp        loopprobel 
fullret:
mov        ax, 0
ret

find    endp
newline    proc    near
MOV AL, 0AH       
   INT 10H        
ret
newline endp
input proc near
mov        ah, 0Ah
int        21h
ret
input endp
output proc near

mov        ah, 9
int        21h
ret
output endp
do    proc near
lea        si, string
xxx1:
push    si
call    find
pop        si
cmp        ax, 0
je        xxx2
mov        si, di
push    di
call    shift
pop        di
call    copy
lea        si, string
jmp        xxx1
xxx2:
ret
do    endp
start   proc    near
mov        ax, @data
mov        ds, ax
mov        es, ax
xor        ax, ax

mov        dx, offset len
call    input
call    do
call    newline
mov        dx, offset string
call    output
mov        ah, 0
int        16h
mov        ah, 4Ch
mov        al, 0
int    21h
start   endp
end     start