
; lab6_modos.asm
; Demostracion de modos de direccionamiento x86
; Compilar: nasm -f bin lab6_modos.asm -o lab6_modos.com

org 100h

; =========================================================
; DATOS DE PRUEBA
; =========================================================

jmp inicio

; Array de 5 enteros de 16 bits
array dw 10, 20, 30, 40, 50

; Registro de estudiante
; nota1 (16 bits), nota2 (16 bits), promedio (16 bits)

nota1    dw 85
nota2    dw 73
promedio dw 0

; Variable para direccionamiento directo
var_x dw 0FFFFh

; Tabla de bytes para XLAT
tabla_hex db 30h,31h,32h,33h,34h,35h,36h,37h
          db 38h,39h,41h,42h,43h,44h,45h,46h

; =========================================================
; CODIGO
; =========================================================

inicio:

