[org 0x7c00]
;mov si,STR_0
;call print

;mov si,STR_T
;call print

;mov si,STR_TH
;call print

mov al,1   ;POWER TO CHANHE BEFORE CALLING readDisk
mov cl,2

call readDisk
jmp test        ;JUMPING TO THE TEST FUNCTION AFTER ACCESSING FROM DISK

jmp $                                                

print:
   pusha                                          
   str_loop:                      ;PRINT FUNCTION
      mov al,[si]
      cmp al,0
      jne print_char
      popa
      ret

    print_char:
      mov ah,0x0e
      int 0x10
      add si,1
      jmp str_loop

readDisk:
   pusha
   mov ah,0x02 ;BIOS INTERRUPT FOR READING FROM A DISK
   mov dl,0x80 ;HARD DISK
   mov ch,0    ;CYLINER POSITION NO.1
   mov dh,0    ;DISK POSITION
  ;mov al,1    ;NO. OF SECTORS TO READ
  ; mov cl,2    ;POSITION OF THE GIVEN SECTOR
   

   push bx         
   mov bx,0                  ;MEMORY BUFFER
   mov es,bx
   pop bx
   mov bx, 0x7c00+512        ;ACCESS TO SECOND BUFFER BY ADDING ANOTHER 512 BYTES

   int 0x13                  ;INTERRUPT

   jc disk_error
   popa
   ret

   disk_error:
      mov si,DISK_ERR_MSG
      call print
      jmp $                     ;HANGS 

;STR_0: db 'Loaded in 16-bit Real Mode to memory location 0x7c00.',0x0a,0x0d,0
;STR_T: db 'These messages use the BIOS interrupt 0x10 with the ah register set to 0x0e.',0x0a,0x0d,0
;STR_TH: db 'Test boot complete. Power off this machine and load a real OS,dummy.',0
DISK_ERR_MSG: db 'Error Loading Disk.',0x0a,0x0d,0
TEST_STR: db 'You are in the second sector.',0x0a,0x0d,0


;padding and magic number
times 510-($-$$) db 0
dw 0xaa55
test: 
mov si,TEST_STR
call print
times 512 db 0  ;PADDING ANOTHER 512 BYTES TO ACCESS THE NEXT SECTOR
