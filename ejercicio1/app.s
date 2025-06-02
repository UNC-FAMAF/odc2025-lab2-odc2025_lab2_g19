	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	//COLORES
	.equ FONDO, 0x6F7BF6
	.equ PISO, 0x3133CC
	.equ SILLON1, 0xC00303
	.equ SILLON2, 0x760202
	.equ CASTANO, 0x6C4600
	.equ COLORADO, 0xF94B16
	.equ RUBIO, 0xE89700
	.equ MARCO_TELE, 0x191919
	.equ POS_MARCO_TELE_X, 87
	.equ POS_MARCO_TELE_Y, 16


	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0xC7, lsl 16
	movk x10, 0x1585, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w6,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto

	movz w6, #0x1919
	movk w6, #0x0019, lsl #16
	
	mov x0, POS_MARCO_TELE_X
	mov x1, POS_MARCO_TELE_Y
	mov x4, 476
	mov x5, 252
	b hacer_rectangulo

	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10
	and w11, w10, 0b10

	// w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
	// efectivamente, su valor representará si GPIO 2 está activo
	lsr w11, w11, 1

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop

// Funciones
hacer_rectangulo: //toma x0: esquina sup. izq. x,  x1: esquina sup. izq. y,
                  //x4: ancho, x5: alto, W10: color
	//inicializamos los registros base
	lsl x0, x0, #2 
	lsl x1, x1, #2
	mov x10, 640
	mul x1, x1, x10
	lsl x4, x4, #2 //ancho * 4 porue nos movemos cada 4 bytes por pixel
	add x4, x0, x4
	lsl x5, x5, #2
	mul x5, x5, x10 // alto * 4 * 640 es el pixel limite del alto en el array 
	add x5, x1, x5
	add x1, x0, x1
	add x1, x1, x20
	mov x12, 0 //nuestro contador de filas
loop1_hr:
	cmp x12, x5  //si llegamos a la posicion y limite, cortamos
	b.eq fin_hacer_rectangulo
	add x1, x1, x12 // punto de partida en xy.
	add x11, x4, x12 // punto de llegada: ancho por 4 mas n fila
	add x11, x11, x20 // encontramos la posicion de memoria del pixel limite
					 // moviendonos x11 posiciones en el array
	add x12, x12, 2560 // sumamos 640*4 posiciones de registro y tenemos el
	                   // pixel de la fila de abajo
loop2_hr:
	cmp x1, x11
	b.eq loop1_hr // si llegamos al pixel largo limite, volvemos a sumar fila
	stur w6, [x1] //pintamos
	add x1, x1, 4 //vamos al pixel siguiente	
	b loop2_hr 
fin_hacer_rectangulo:
	ret
	


