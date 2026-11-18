# Post-contenido — Unidad 6: Instrucciones y Direccionamiento en NASM

**Estudiante:** William Felipe Villamizar Soler  
**Código:** 1152498  
**Asignatura:** Arquitectura de Computadores  
**Herramientas:** NASM, DOSBox y DEBUG

## Parte 1 — Programa de instrucciones mixtas

El laboratorio desarrolla un programa en lenguaje ensamblador NASM para arquitectura x86, utilizando cinco bloques de instrucciones:

1. Transferencia de datos: MOV, LEA, XCHG, PUSH y POP.
2. Operaciones aritméticas: ADD, SUB, INC, DEC, MUL y DIV.
3. Operaciones lógicas: AND, OR, XOR, TEST, SHL y SHR.
4. Control de flujo: CMP, JG, JE y LOOP.
5. Rotaciones: ROL y ROR, comparadas con SHL y SHR.

## Resultados de los checkpoints

- **Checkpoint 1:** compilación exitosa mediante NASM.
- **Checkpoint 2:** verificación de registros y flags mediante DEBUG. La suma acumulada produjo AX=000Fh (15).
- **Checkpoint 3:** variante factorial de 5, con resultado AX=0078h (120).
- **Checkpoint 4:** rotaciones y desplazamientos verificados, con resultado final AL=5Ah.

## Decisiones técnicas

### Decisión técnica 1: SHL/SHR frente a ROL/ROR

La selección entre las instrucciones SHL/SHR y ROL/ROR depende del propósito de la manipulación binaria y de la necesidad de conservar los bits originales. SHL y SHR resultan apropiadas para operaciones aritméticas, como multiplicar o dividir números enteros sin signo entre potencias de dos, siempre que el resultado pueda representarse dentro del tamaño del registro y no sea necesario conservar los bits descartados. En cambio, ROL y ROR son preferibles cuando se requiere reorganizar los bits sin perder información, como en el intercambio de nibbles, determinadas operaciones criptográficas y algoritmos de checksum circular.

Para intercambiar los nibbles de un byte, utilizar únicamente SHL no es suficiente, porque los bits que salen por el extremo izquierdo se pierden del registro. Aunque se aplique posteriormente OR, esta instrucción no puede reconstruir automáticamente los bits originales descartados; para recuperarlos sería necesario haberlos conservado previamente en otro registro o variable. Por el contrario, ROL permite intercambiar ambos nibbles mediante una rotación de cuatro posiciones, manteniendo los ocho bits originales.

Esta diferencia se comprueba utilizando el valor AL=81h (10000001b). Al ejecutar `SHL AL, 1`, se obtiene AL=02h (00000010b): el bit 7 original se descarta del registro y queda reflejado en el flag CF. En cambio, `ROL AL, 1` produce AL=03h (00000011b), porque el bit 7 original se reinserta como el nuevo bit 0, manteniendo CF=1.

Por tanto, la elección técnica consiste en utilizar desplazamientos cuando interesa el efecto aritmético y se admite descartar bits, y rotaciones cuando se necesita preservar y redistribuir la información binaria.

## Evidencias

Las capturas de compilación, ejecución y depuración se almacenan en la carpeta `capturas/`.