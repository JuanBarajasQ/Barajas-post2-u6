# Laboratorio: Modos de Direccionamiento en x86 (NASM)

* **Estudiante:** Juan Carlos Barajas Quintero 
* **Curso:** Arquitectura de Computadores - Unidad 6  
* **Institución:** Universidad Francisco de Paula Santander

## 1. Descripción del Proyecto
Este laboratorio demuestra la implementación y verificación de los cuatro modos de direccionamiento fundamentales de la arquitectura x86 mediante el uso de NASM y la herramienta de depuración DEBUG en DOSBox.

### Entorno de Trabajo
Para el cumplimiento de los objetivos, se utilizó el siguiente software y versiones:
*   **Emulador:** DOSBox 0.74+.
*   **Ensamblador:** NASM versión 2.14+.
*   **Control de Versiones:** Git para la gestión del repositorio.
*   **Editor de Texto:** VS code para la escritura de los archivos .asm.


## 2. Tabla Resumen de Modos de Direccionamiento

| Nombre del Modo | Fórmula de Dirección Efectiva (EA) | Instrucción NASM Usada | Valor Observado en DEBUG |
| :--- | :--- | :--- | :--- |
| **Inmediato** | No aplica (el dato está en el opcode) | `MOV ax, 100` | **AX = 0064h** |
| **Directo** | EA = Desplazamiento (fijo) | `MOV ax, [var_x]` | **AX = FFFFh** |
| **Indirecto** | EA = [Registro Base/Índice] | `MOV ax, [si]` | **AX = 0055h** |
| **Indexado** | EA = Base + Índice + Desplazamiento | `MOV ax, [bx + si]` | **AX = 001Eh** (array) |

---

## 3. Descripción Detallada de los Modos

### Modo 1: Inmediato
*   **Fórmula:** El operando es una constante embebida directamente en el código de la instrucción.
*   **Registros involucrados:** **AX, BX, CX, DX**. Al ejecutar `MOV ax, 100`, el valor 100 (64h) se carga directamente desde el flujo de instrucciones.
*   **Resultado:** No se genera tráfico de bus hacia la memoria de datos; el valor se observa desensamblando con el comando `U` en el opcode de la instrucción.

### Modo 2: Directo
*   **Fórmula:** **EA = Desplazamiento fijo**. La dirección absoluta está en la instrucción.
*   **Registros involucrados:** **AX, BX, CX**. Por ejemplo, al ejecutar `MOV ax, [var_x]`, la CPU accede a la dirección de memoria donde reside `var_x`.
*   **Resultado:** En DEBUG se observa el acceso a la dirección fija (ej. `[01XX]`). El valor cargado es el contenido de dicha dirección (ej. `FFFFh` para `var_x`).

### Modo 3: Indirecto por Registro
*   **Fórmula:** **EA = [SI]** o **[BX]**. El registro actúa como un puntero que contiene la dirección de memoria.
*   **Registros involucrados:** **SI, AX, BX**. Se carga la dirección de una etiqueta en SI y luego se accede a su contenido usando corchetes.
*   **Resultado:** Permite manejar punteros dinámicos. El trazado muestra que el valor en el registro de datos (AX) cambia según lo que apunte SI.

### Modo 4: Indexado
*   **Fórmula:** **EA = Base + Índice + Desplazamiento**. Combina un registro base (BX) con un índice (SI) y opcionalmente un valor fijo.
*   **Registros involucrados:** **BX, SI, AX**. Se utiliza para recorrer estructuras complejas como arrays.
*   **Resultado:** Al finalizar el bucle de suma de los elementos del array, se observa **AX = 0096h (150 decimal)**.

---

## 4. Checkpoint 2: Trazado del Modo Indirecto

Se realizó un seguimiento paso a paso del bloque de modo indirecto utilizando el comando `T` (Trace) de DEBUG para validar el funcionamiento de los punteros.

### Verificación de Registros Clave:
*   **Valor de SI antes de `MOV si, nota1`:** `0000`.
*   **Valor de SI después de `MOV si, nota1`:** `010C` (dirección de memoria de `nota1`).
*   **Valor de AX después de `MOV ax, [si]`:** `0055h`, lo cual confirma el valor decimal **85** almacenado en `nota1`.

### Tabla de Trazado de Instrucciones (Bloque Indirecto):

| Instrucción | Registro Modificado | Valor Resultante |
| :--- | :--- | :--- |
| `MOV SI, 010C` | **SI** | `010C` |
| `MOV AX, [SI]` | **AX** | `0055` |
| `MOV SI, 010E` | **SI** | `010E` |
| `MOV BX, [SI]` | **BX** | `0049` |
| `ADD AX, BX` | **AX** | `009E` |

*Nota: El valor `0049h` en BX corresponde a la `nota2` (73 decimal). La suma resultante `009Eh` equivale a 158 decimal.*

## 5. Instrucciones de Compilación y Ejecución
Para compilar el programa utilizando **NASM**, ejecute el siguiente comando en la consola de **DOSBox** (nombre del .com debe limitarse a 8 caracteres para ejecutarlo correctamente en DOSBox):

```bash
nasm -f bin lab6_modos.asm -o lab6_mod.com
```

Para depurar y observar el comportamiento de los registros:
```bash
debug lab6_mod.com
-t  (para ejecutar paso a paso)
```
