
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

; -- BLOQUE 2: Operaciones aritmeticas ---------------------

    ; ADD: suma con actualizacion de flags
    MOV ax, [valor_a]    ; AX = 45
    ADD ax, [valor_b]    ; AX = 57 (ZF=0, CF=0, OF=0)
    MOV [resultado], ax  ; Guarda 57 en memoria

    ; SUB: resta
    MOV ax, [valor_b]    ; AX = 12
    SUB ax, [valor_a]    ; AX = -33 (SF=1, OF=0)

    ; INC y DEC: no modifican CF
    MOV ax, [valor_a]    ; AX = 45
    INC ax              ; AX = 46
    DEC ax              ; AX = 45

    ; MUL: multiplicacion sin signo de 8 bits
    MOV al, 10          ; AL = 10
    MOV bl, 7           ; BL = 7
    MUL bl              ; AX = 10 * 7 = 70

    ; DIV: division sin signo de 8 bits
    MOV ax, 100         ; AX = 100
    MOV bl, 7           ; BL = 7
    DIV bl              ; AL = 14, AH = 2
