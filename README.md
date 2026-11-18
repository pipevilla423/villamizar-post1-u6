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

### Decisión técnica 2: Uso de LOOP frente a DEC/JNZ

La elección entre las instrucciones `LOOP` y `DEC CX` seguido de `JNZ` depende de la legibilidad, el tamaño del código y el rendimiento esperado. La instrucción `LOOP` ofrece una ventaja de simplicidad porque realiza el decremento del registro CX y el salto condicional en una sola instrucción. Esto permite escribir bucles contados de forma más compacta y facilita la comprensión del código. Además, en el modo de 16 bits utilizado en DOSBox, `LOOP` ocupa normalmente dos bytes, mientras que la combinación `DEC CX` y `JNZ` requiere al menos tres bytes.

Sin embargo, una menor cantidad de instrucciones no garantiza un menor tiempo de ejecución. En los procesadores x86 modernos, cada instrucción tiene un coste diferente de decodificación y ejecución interna. Algunas instrucciones complejas pueden requerir varias microoperaciones, mientras que otras más sencillas pueden procesarse de manera más eficiente. Por esta razón, la secuencia `DEC CX` y `JNZ` puede ejecutarse en menos ciclos de reloj que `LOOP`, aunque utilice dos instrucciones en lugar de una.

En el Bloque 4 del laboratorio, el bucle realiza únicamente cinco iteraciones para calcular la suma acumulada de 1 a 5. En este caso, la diferencia de rendimiento entre ambas alternativas es prácticamente imperceptible, por lo que se considera preferible utilizar `LOOP` debido a su claridad y tamaño reducido. No obstante, si el mismo bucle se ejecutara millones de veces dentro de un programa de mayor tamaño, la diferencia acumulada de ciclos podría ser significativa. En ese escenario, convendría evaluar el rendimiento real sobre el procesador utilizado y considerar `DEC CX` seguido de `JNZ` cuando ofrezca mejores resultados.
## Evidencias

Las capturas de compilación, ejecución y depuración se almacenan en la carpeta `capturas/`.

### Checkpoint 2: Trazado del modo indirecto por registro

El direccionamiento indirecto permite acceder a los datos utilizando un registro que almacena su dirección de memoria. En este programa se utiliza SI como puntero para acceder a las notas del estudiante y almacenar el promedio calculado.

| Instrucción | Registro modificado | Valor resultante |
|---|---|---|
| `MOV SI, nota1` | SI | 010Ch |
| `MOV AX, [SI]` | AX | 0055h (85) |
| `MOV SI, nota2` | SI | 010Eh |
| `MOV BX, [SI]` | BX | 0049h (73) |
| `ADD AX, BX` | AX | 009Eh (158) |
| `SHR AX, 1` | AX | 004Fh (79) |
| `MOV SI, promedio` | SI | 0110h |
| `MOV [SI], AX` | Memoria DS:0110 | 004Fh (79) |

**Conclusión:** el registro SI permite acceder a distintas posiciones de memoria sin cambiar la instrucción utilizada para leer o escribir el dato. Esto demuestra el funcionamiento de los punteros en lenguaje ensamblador.