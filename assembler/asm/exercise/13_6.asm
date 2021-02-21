;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;p260	13.6 BIOS中断例程应用
;
;
;编程：在屏幕的第5行12列显示3个红底高亮闪烁绿色的‘a’
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
assume cs:code, ds:data

data segment
	db 'Welcome to masm!'
data ends

code segment

start:	call clear_screen

	mov ah,2	;设置光标
	mov bh,0	;第0页
	mov dh,5	;dh中放行号	
	mov dl,12	;dl中放列号
	int 10h

	mov ah,9	;在光标位置显示字符
	mov al,'a'	;字符
	mov bl,11001010b
	mov bh,0	;第0页
	mov cx,3	;字符重复个数
	int 10h

	call debug_show
	
	mov ax,4c00h
	int 21h

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;名称：clear_screen；
;功能：清除屏幕显示内容
;参数：无
;返回：无
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
clear_screen:
	push es
	push di
	push cx
	
	mov di,0b800h
	mov es,di
	mov di,0		;使es:di指向显存的首地址

	mov cx,4000h		;将显存地址空间B8000H~BFFFFH清空
clean:	mov byte ptr es:[di],0
	add di,2
	loop clean

	pop cx
	pop di
	pop es

	ret
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;名称：debug_show；
;功能：循环检测，按Esc键则退出循环
;参数：无
;返回：无
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
debug_show:
	push ax
	
ds_check:	
	in al,60h
	cmp al,81h
	je ds_exit
	jmp short ds_check

ds_exit:	
	pop ax
	ret
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

code ends

end start