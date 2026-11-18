
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
; INICIO DEL PROGRAMA
; =========================================================

inicio:

; =========================================================
; MODO 1: DIRECCIONAMIENTO INMEDIATO
; =========================================================

    MOV ax, 100
    MOV bx, 0A5h
    ADD cx, 55
    AND dx, 00FFh

; =========================================================
; MODO 2: DIRECCIONAMIENTO DIRECTO
; =========================================================

    MOV ax, [var_x]      ; AX = FFFFh
    MOV bx, [array]      ; BX = 10
    MOV cx, [nota1]      ; CX = 85

    MOV word [var_x], 0

; =========================================================
; MODO 3: INDIRECTO POR REGISTRO SI
; =========================================================

    MOV si, nota1        ; SI = direccion de nota1
    MOV ax, [si]         ; AX = 85

    MOV si, nota2        ; SI = direccion de nota2
    MOV bx, [si]         ; BX = 73

    ADD ax, bx           ; AX = 158
    SHR ax, 1            ; AX = 79

    MOV si, promedio
    MOV [si], ax         ; promedio = 79

; =========================================================
; MODO 4: INDEXADO CON BASE E INDICE
; =========================================================

    ; Acceso a array[2] = 30
    MOV bx, array
    MOV si, 4
    MOV ax, [bx + si]

    ; Suma acumulada del array
    XOR ax, ax
    MOV bx, array
    MOV cx, 5
    XOR si, si

.bucle_array:
    ADD ax, [bx + si]
    ADD si, 2
    LOOP .bucle_array

    ; AX = 150 = 0096h

    ; Acceso a campos del registro
    MOV bx, nota1
    MOV ax, [bx]         ; AX = 85
    MOV cx, [bx + 2]     ; CX = 73
    MOV dx, [bx + 4]     ; DX = 79

; =========================================================
; MODO 3b: INDIRECTO CON BP - MARCO DE PILA
; =========================================================

    ; Preservar BP original
    PUSH bp

    ; Crear marco de pila
    MOV bp, sp

    ; Reservar 4 bytes para dos variables locales
    SUB sp, 4

    ; Variable local 1 = 99
    MOV word [bp - 2], 99

    ; Variable local 2 = 250
    MOV word [bp - 4], 250

    ; Leer local 1 mediante BP
    MOV ax, [bp - 2]     ; AX = 99 = 0063h

    ; Sumar local 2
    ADD ax, [bp - 4]     ; AX = 349 = 015Dh

    ; Liberar las variables locales
    MOV sp, bp

    ; Restaurar BP original
    POP bp

; =========================================================
; FIN DEL PROGRAMA
; =========================================================

    INT 20h
