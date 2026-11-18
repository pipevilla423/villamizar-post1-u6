
; lab6_instrucciones.asm
; Demostracion de categorias de instrucciones x86
; Compilar: nasm -f bin lab6_instrucciones.asm -o lab6_instrucciones.com

org 100h

; -- Datos ------------------------------------------------

jmp inicio

valor_a   dw 45
valor_b   dw 12
resultado dw 0
contador  db 5
mascara   db 0Fh

; -- Codigo ------------------------------------------------

inicio:
