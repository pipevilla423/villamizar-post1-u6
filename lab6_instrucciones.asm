
; lab6_instrucciones.asm
; Unidad 6 - Arquitectura de Computadores
; Demostracion de instrucciones x86 en NASM
; Compilar: nasm -f bin lab6_instrucciones.asm -o lab6_instrucciones.com

org 100h

; =========================================================
; DATOS
; =========================================================

jmp inicio

valor_a   dw 45
valor_b   dw 12
resultado dw 0
contador  db 5
mascara   db 0Fh

; =========================================================
; CODIGO
; =========================================================

inicio:

; =========================================================
; BLOQUE 1: TRANSFERENCIA DE DATOS
; =========================================================

    ; MOV: cargar valores desde memoria
    MOV ax, [valor_a]    ; AX = 45
    MOV bx, [valor_b]    ; BX = 12

    ; MOV entre registros
    MOV cx, ax           ; CX = 45
    MOV dx, bx           ; DX = 12

    ; LEA: obtener direccion de memoria
    LEA si, [valor_a]    ; SI = direccion de valor_a
    MOV ax, [si]         ; AX = 45

    ; XCHG: intercambiar registros
    XCHG cx, dx          ; CX = 12, DX = 45
    XCHG cx, dx          ; CX = 45, DX = 12

    ; PUSH y POP: preservar registros
    PUSH ax
    MOV ax, 0FFFFh
    POP ax               ; AX = 45

; =========================================================
; BLOQUE 2: OPERACIONES ARITMETICAS
; =========================================================

    ; ADD: suma
    MOV ax, [valor_a]    ; AX = 45
    ADD ax, [valor_b]    ; AX = 57
    MOV [resultado], ax  ; Guardar resultado

    ; SUB: resta
    MOV ax, [valor_b]    ; AX = 12
    SUB ax, [valor_a]    ; AX = -33 = FFDFh

    ; INC y DEC
    MOV ax, [valor_a]    ; AX = 45
    INC ax               ; AX = 46
    DEC ax               ; AX = 45

    ; MUL: multiplicacion sin signo
    MOV al, 10
    MOV bl, 7
    MUL bl               ; AX = 70 = 0046h

    ; DIV: division sin signo
    MOV ax, 100
    MOV bl, 7
    DIV bl               ; AL = 14, AH = 2

; =========================================================
; BLOQUE 3: OPERACIONES LOGICAS
; =========================================================

    ; AND: conservar los cuatro bits bajos
    MOV al, 0B7h
    AND al, [mascara]    ; AL = 07h

    ; OR: activar los cuatro bits altos
    MOV al, 0B7h
    OR al, 0F0h          ; AL = F7h

    ; XOR: invertir bits
    MOV al, 0AAh
    XOR al, 0FFh         ; AL = 55h

    ; XOR: poner un registro a cero
    XOR bx, bx           ; BX = 0000h

    ; TEST: comprobar bit sin modificar AL
    MOV al, 0B7h
    TEST al, 01h         ; AL = B7h, ZF = 0

    ; SHL y SHR: desplazamientos
    MOV al, 08h
    SHL al, 2            ; AL = 20h
    SHR al, 1            ; AL = 10h

; =========================================================
; BLOQUE 4: CONTROL DE FLUJO
; =========================================================

    ; Comparacion entre valor_a y valor_b
    MOV ax, [valor_a]    ; AX = 45
    CMP ax, [valor_b]    ; Comparar 45 con 12

    JG .mayor
    JE .igual

    ; Caso menor
    XOR cx, cx
    JMP .fin_cmp

.mayor:
    MOV cx, 1
    JMP .fin_cmp

.igual:
    MOV cx, 2

.fin_cmp:

    ; Bucle: suma acumulada de 1 a 5
    XOR ax, ax           ; AX = 0
    MOV cx, 5            ; Cinco iteraciones
    MOV bx, 1            ; Primer sumando

.bucle_suma:
    ADD ax, bx           ; AX = AX + BX
    INC bx               ; Siguiente numero
    LOOP .bucle_suma

    ; Resultado: AX = 000Fh = 15 decimal

; =========================================================
; BLOQUE 5: ROTACIONES ROL Y ROR
; =========================================================

    ; Valor inicial para las comparaciones
    MOV al, 81h         ; AL = 10000001b

    ; SHL: desplaza y descarta el bit izquierdo
    MOV bl, al
    SHL bl, 1           ; BL = 02h, CF = 1

    ; ROL: rota y conserva el bit izquierdo
    MOV cl, al
    ROL cl, 1           ; CL = 03h, CF = 1

    ; SHR: desplaza y descarta el bit derecho
    MOV dl, al
    SHR dl, 1           ; DL = 40h, CF = 1

    ; ROR: rota y conserva el bit derecho
    MOV bh, al
    ROR bh, 1           ; BH = C0h, CF = 1

    ; Intercambiar los nibbles de un byte
    MOV al, 0A5h       ; AL = A5h
    ROL al, 4          ; AL = 5Ah

    ; Resultado final esperado:
    ; AX = 005Ah
    ; BX = C002h
    ; CX = 0003h
    ; DX = 0040h

; =========================================================
; FIN DEL PROGRAMA
; =========================================================

    INT 20h
