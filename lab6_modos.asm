
; lab6_modos.asm
; Unidad 6 - Arquitectura de Computadores
; Parte 2: Demostracion de modos de direccionamiento x86
; Compilar: nasm -f bin lab6_modos.asm -o lab6_modos.com

org 100h

; =========================================================
; DATOS DE PRUEBA
; =========================================================

jmp inicio

; Array de 5 enteros de 16 bits
array dw 10, 20, 30, 40, 50

; Registro de estudiante
nota1    dw 85
nota2    dw 73
promedio dw 0

; Variable para direccionamiento directo
var_x dw 0FFFFh

; Tabla hexadecimal para XLAT
tabla_hex db 30h,31h,32h,33h,34h,35h,36h,37h
          db 38h,39h,41h,42h,43h,44h,45h,46h

; =========================================================
; CODIGO
; =========================================================

inicio:

; =========================================================
; MODO 1: DIRECCIONAMIENTO INMEDIATO
; =========================================================

    MOV ax, 100          ; AX = 0064h
    MOV bx, 0A5h         ; BX = 00A5h
    ADD cx, 55           ; CX = CX + 55
    AND dx, 00FFh        ; DX conserva sus 8 bits bajos

; =========================================================
; MODO 2: DIRECCIONAMIENTO DIRECTO
; =========================================================

    MOV ax, [var_x]      ; AX = FFFFh
    MOV bx, [array]      ; BX = 000Ah = 10
    MOV cx, [nota1]      ; CX = 0055h = 85

    MOV word [var_x], 0  ; var_x = 0000h

; =========================================================
; MODO 3: INDIRECTO POR REGISTRO
; =========================================================

    ; SI contiene la direccion de nota1
    MOV si, nota1        ; SI = 010Ch
    MOV ax, [si]         ; AX = 85 = 0055h

    ; SI ahora apunta a nota2
    MOV si, nota2        ; SI = 010Eh
    MOV bx, [si]         ; BX = 73 = 0049h

    ; Calcular promedio
    ADD ax, bx           ; AX = 85 + 73 = 158
    SHR ax, 1            ; AX = 79 = 004Fh

    ; Guardar el promedio mediante un puntero
    MOV si, promedio     ; SI = 0110h
    MOV [si], ax         ; Memoria[0110h] = 004Fh

; =========================================================
; FIN TEMPORAL DEL PROGRAMA
; =========================================================

    INT 20h
