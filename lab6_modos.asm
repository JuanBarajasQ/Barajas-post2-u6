; lab6_modos.asm — Demostración de modos de direccionamiento x86
; Compilar: nasm -f bin lab6_modos.asm -o lab6_modos.com

org 100h

; Datos de prueba:

jmp inicio

; Array de 5 enteros de 16 bits
array dw 10, 20, 30, 40, 50

; Registro de estudiante: nota1(16b) + nota2(16b) + promedio(16b)
nota1 dw 85
nota2 dw 73
promedio dw 0

; Variable simple para direccionamiento directo
var_x dw 0FFFFh

; Tabla de bytes para XLAT (opcional)
tabla_hex db 30h,31h,32h,33h,34h,35h,36h,37h
 db 38h,39h,41h,42h,43h,44h,45h,46h

inicio:

; MODO 1: INMEDIATO
; El operando es un valor constante dentro de la instrucción
; Desensamblar con DEBUG --> U revela el valor 0064h en el opcode
 MOV ax, 100 ; AX = 100 — inmediato decimal
 MOV bx, 0A5h ; BX = 0xA5 — inmediato hex
 ADD cx, 55 ; CX += 55 — inmediato en operación aritmética
 AND dx, 00FFh ; DX AND máscara inmediata

; Verificación con DEBUG:
; Comando U 100 (desensamblar desde offset 0x100)
; Observar: "MOV AX,0064" — el 64h (100) está en el opcode
; No se genera tráfico de bus a memoria de datos
