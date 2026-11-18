
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

; -- BLOQUE 1: Transferencia de datos ----------------------

    ; MOV: carga valor de memoria a registro
    MOV ax, [valor_a]    ; AX = 45
    MOV bx, [valor_b]    ; BX = 12

    ; MOV entre registros
    MOV cx, ax           ; CX = 45
    MOV dx, bx           ; DX = 12

    ; LEA: carga la direccion, no el contenido
    LEA si, [valor_a]    ; SI = direccion de valor_a
    MOV ax, [si]         ; AX = 45

    ; XCHG: intercambio de registros
    XCHG cx, dx          ; CX = 12, DX = 45
    XCHG cx, dx          ; CX = 45, DX = 12

    ; PUSH/POP: preservar y restaurar
    PUSH ax              ; Guarda AX = 45
    MOV ax, 0FFFFh       ; Modifica AX temporalmente
    POP ax               ; Restaura AX = 45
