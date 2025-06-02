	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	//COLORES
	// FONDO, 0x6F7BF6
	// PISO, 0x3133CC
	// SILLON1, 0xC00303
	// SILLON2, 0x760202
	// CASTANO, 0x6C4600
	// COLORADO, 0xF94B16
	// RUBIO, 0xE89700
	// MARCO_TELE, 0x191919 

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
	// NOTA: como todo lo pintamos de un solo color, uso por defecto w7 para
	// holdear el color de la figura y lo cambio para cada figura con un color
	// diferente. Creo que estaria bueno mantener esa convencion en todas las
	// funciones, que el color sea siempre w7. 
	// FONDO
	movz x10, 0xC7, lsl 16 // esto es codigo basura del start viejo, habria que
	movk x10, 0x1585, lsl 00 // modificarlo para guardar el color de fondo

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w7,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto


	// MARCO DE TELE
	mov x0, 87 // esquina superior izquierda, pos x
	mov x1, 16 // esquina superior izquierda, pos y
	mov x2, 476 // ancho
	mov x3, 252 // alto
	movz w7, #0x0019, lsl 16 // color
	movk w7, #0x1919, lsl 00
	bl hacer_rectangulo

	mov x0, #320        // center x
    mov x1, #240        // center y
    mov x2, #50         // radius
    movz w7, #0x00FF, lsl 16 // color
	movk w7, #0xFFFF, lsl 00
	bl hacer_circulo

	// Ejemplo de uso de gpios (esto es codigo de los profes, lo dejo por las 
	// dudas)
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
// PRE: x0 < 640, x1 < 480, x2 < 640 + x0, x3 < 480 + x1, w7 <= 0xFFFFFF
hacer_rectangulo: //toma x0: esquina sup. izq. x,  x1: esquina sup. izq. y,
                  //x2: ancho, x3: alto, w7: color
	lsl x0, x0, #2 //todo * 2^2 (4) porque nos movemos cada 4 bytes por pixel
	lsl x2, x2, #2 // hacer mul con un registro que tenga el #4 es equivalente,
				   // yo uso lsl porque mul no toma numeros sueltos
	mov x10, 2560 // 640 * 4, solo se puede multiplicar con registros :(
	mul x1, x1, x10 // las alturas son como recorrer una fila completa,
	mul x3, x3, x10 // por eso el 640
	add x1, x1, x20 // A la altura le sumo el inicio del framebuffer
	add x2, x0, x2 // el largo y ancho dependen del punto de partida
	add x3, x1, x3 // ahora tratamos x2 y x3 como los pixeles limite de dibujo 
	mov x12, x1 //hago un contador de filas para poder ir saltando hacia abajo
.loop1_hr:
	cmp x12, x3  //si llegamos a la fila limite, cortamos
	b.eq .ret
	// NOTA: ahora usamos x1 como nuestro puntero, no es mas la pos y
	add x1, x0, x12 // para saltar, vamos al comienzo de la fila y sumamos x0
	add x11, x2, x12 // seteamos el limite de dibujo en la fila:
					 // posicion x limite mas "y" filas dibujadas
	add x12, x12, 2560 // una vez hechos los calculos, bajamos una fila.
					   // Esto solo afecta a la siguiente vuelta del bucle
.loop2_hr:
	cmp x1, x11
	b.eq .loop1_hr // si llegamos al pixel largo limite, volvemos a sumar fila
	stur w7, [x1] //pintamos
	add x1, x1, 4 //vamos al pixel siguiente	
	b .loop2_hr

// PRE: x0 < 640, x1 < 480, x2 < 640 + x0, x3 < 480 + x1, w7 <= 0xFFFFFF
// NOTA: para no buscar toda la pantalla, por eficiencia decidi que es mejor
// buscar solo en el cuadrado en donde esta el circulo, y por eso dibujo a
// partir de la esquina superior izquierda. Para calculrla dado un centro 
// (x, y) y un radio r, la esquina superior se calcula como (x - r, y - r)
hacer_circulo: // toma x0: esq. sup. x,  x1: esq. sup. y, x2: radio, w7: color
	lsl x0, x0, #2 // *4
	lsl x2, x2, #2
	mov x9, 2560 
	mul x1, x1, x9 // *4 *640 
	add x10, x1, x20 // esq y + fb
	                  // obteniendo la posicion del centro (x, y) en el frame
	lsl x13, x2, #1 // para el alto del cuadrado, guardamos el diametro (2r) en x13
	mul x14, x13, x9 
	add x14, x10, x14 //esy * 2560 + fb + 2(r*4) *2560
	mov x15, x10 //x15 = esy * 640 + fb, contador arranca desde esa pos
.loop1_hc:
	cmp x15, x14 
	b.eq .ret // contador de filas igual que fila limite, cortamos
	add x3, x0, x15 // 
	add x4, x2, x2
	add x4, x0, x4
	add x4, x4, x15 // columna + 2r + contador
	add x15, x15, 2560 
	mov x10, 0
.loop2_hc:
	add x13, x3, x10
	cmp x13, x4
	b.eq .loop1_hc
	// x^2+y^2 = r. y = +-sqrt(r^2 - x^2), idem x
	sub x5, x3, X20 //obtenemos la posicion limpia, sin framebuffer
	add x13, x0, x10 // pos actual x 
	sub x6, x5, x13 // obtenemos la posicion de pos actual en y * 640
	mov x9, 640
	mul x12, x2, x9
	add x12, x12, x1
	sub x6, x6, x12
	sdiv x6, x6, x9 // obtenemos la posicion del centro en y relativa al radio.
	mul x11, x2, x2 // r2
	sub x13, x10, x2 // x relativo al radio
	mul x13, x13, x13 // x^2
	subs x13, x11, x13 //r^2-x^2
	b.lt .else
	scvtf   d1, x13         // convert int → float
	fsqrt   d0, d1         // d0 = sqrt(d1)
	fcvtzs  x13, d0
	cmp x6, x13 // y <= sqrt
	b.gt .else
	sub x13, xzr, x13
	cmp x6, x13
	b.lt .else
	str w7, [x3, x10] //pintamos
.else:
	add x10, x10, 4 //vamos al pixel siguiente	
	b .loop2_hc

.ret:
	ret



