target triple = "i386-elf"

; magic number for grub (1BADB002 translated to base 10)
@magic = constant i32 464367618, section "multiboot", align 4
; boot flags
@flags = constant i32 0, section "multiboot", align 4
; checksum -(magic + flags)
@checksum = constant i32 -464367618, section "multiboot", align 4

; write a single character to output
define void @write_char(i8 %char, i64 %index) {
    ; allocate character pointer
    %char_ptr = alloca i8*, align 8
    ; set character pointer address (address is 0xB8000 when translated back to hex) 
    store i8* inttoptr (i64 753664 to i8*), i8** %char_ptr, align 8

    ; create an array
    %output_array = load i8*, i8** %char_ptr, align 8
    ; get array index pointer
    %index_pointer = getelementptr inbounds i8, i8* %output_array, i64 %index
    ; write char
    store i8 %char, i8* %index_pointer, align 1

    ; return
    ret void
}

define void @clear_screen() {
; allocate counter
%clear_counter = alloca i16

; jump into loop
br label %loop

loop:
    ; get old counter
    %old_counter = load i16, i16* %clear_counter
    ; increment by 1
    %incr_counter = add i16 1, %old_counter
    ; store incremented counter
    store i16 %incr_counter, i16* %clear_counter

    ; get character index
    %index = mul i16 2, %old_counter
    ; cast character index to i64
    %casted_index = zext i16 %index to i64

    ; write null character to memory
    call void @write_char(i8 0, i64 %casted_index)

    ; check if we should continue, counter < 16383 (memory range for vga characters in 16bit mode is B8000 - BFFFF)
    %continue = icmp ult i16 16383, %old_counter
    ; if we should continue jump back to the clear label, otherwise exit loop
    br i1 %continue, label %loop, label %exit
exit:
    ; return
    ret void
}

define void @_start() {
    call void @clear_screen()

    ; H
    call void @write_char(i8 72, i64 0)
    ; e
    call void @write_char(i8 101, i64 2)
    ; ll
    call void @write_char(i8 108, i64 4)
    call void @write_char(i8 108, i64 6)
    ; o
    call void @write_char(i8 111, i64 8)
    ; Space
    call void @write_char(i8 32, i64 10)
    ; W
    call void @write_char(i8 87, i64 12)
    ; o
    call void @write_char(i8 111, i64 14)
    ; r
    call void @write_char(i8 114, i64 16)
    ; l
    call void @write_char(i8 108, i64 18)
    ; d
    call void @write_char(i8 100, i64 20)

    ; jump into infinite loop so the machine doesn't crash
    br label %kernel_loop
kernel_loop:
    ; jump back to kernel loop to keep kernel from crashing
    br label %kernel_loop

    unreachable
}