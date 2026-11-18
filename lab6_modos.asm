
; lab6_modos.asm
; Unidad 6 - Arquitectura de Computadores
; Parte 2: Modos de direccionamiento x86
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

; Variable de direccionamiento directo
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
; MODO 3: INDIRECTO POR REGISTRO
; =========================================================

    ; Puntero a nota1
    MOV si, nota1        ; SI = direccion de nota1
    MOV ax, [si]         ; AX = 85

    ; Puntero a nota2
    MOV si, nota2        ; SI = direccion de nota2
    MOV bx, [si]         ; BX = 73

    ; Calcular promedio
    ADD ax, bx           ; AX = 158
    SHR ax, 1            ; AX = 79

    ; Guardar promedio mediante puntero
    MOV si, promedio
    MOV [si], ax         ; promedio = 79

; =========================================================
; MODO 4: INDEXADO CON BASE E INDICE
; =========================================================

    ; Acceder al tercer elemento: array[2] = 30
    MOV bx, array        ; BX = direccion base
    MOV si, 4            ; Desplazamiento: 2 * 2 bytes
    MOV ax, [bx + si]    ; AX = 30 = 001Eh

    ; Sumar todos los elementos del array
    XOR ax, ax           ; AX = 0
    MOV bx, array        ; BX = base del array
    MOV cx, 5            ; Cinco elementos
    XOR si, si           ; SI = 0

.bucle_array:

    ADD ax, [bx + si]    ; Sumar elemento actual
    ADD si, 2            ; Siguiente word
    LOOP .bucle_array    ; Repetir hasta CX = 0

    ; Resultado: AX = 150 = 0096h

    ; Acceder a los campos del registro estudiante
    MOV bx, nota1        ; BX = direccion base

    MOV ax, [bx]         ; AX = nota1 = 85
    MOV cx, [bx + 2]     ; CX = nota2 = 73
    MOV dx, [bx + 4]     ; DX = promedio = 79

; =========================================================
; FIN DEL PROGRAMA
; =========================================================

    INT 20h
