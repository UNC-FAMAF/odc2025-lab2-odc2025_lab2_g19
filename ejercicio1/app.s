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
	//AUTITO

	.globl main
	.globl hacer_rectangulo		// .globl Hace que las funciones puedan ser accedidas
								// desde otros codigos (lo uso en writeodc.s)
	.globl hacer_circulo
	.extern drawO
	.extern drawD
	.extern detailC
	.extern drawcero
	.extern drawcinco

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
	// NOTA: como todo lo pintamos de un solo color, uso por defecto w7 para
	// holdear el color de la figura y lo cambio para cada figura con un color
	// diferente. Creo que estaria bueno mantener esa convencion en todas las
	// funciones, que el color sea siempre w7.
	// NOTA2: LEAN ESTANDAR DE FUNCIONES ANTES DE ARRANCAR.
	// FONDO
	movz x10, 0xC7, lsl 16 // esto es codigo basura del start viejo, habria que
	movk x10, 0x1585, lsl 00 // modificarlo para guardar el color de fondo

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	movz w7, #0x006F, lsl 16 // color
	movk w7, #0x7BF6, lsl 00
	stur w7,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la 1fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto
	// PISO
	mov x0, 0 // esquina superior izquierda, pos x
	mov x1, 349 // esquina superior izquierda, pos y
	mov x2, 640 // ancho
	mov x3, 131 // alto
	movz w7, #0x31, lsl 16 // color
	movk w7, #0x33CC, lsl 00
	bl hacer_rectangulo


	// MARCO DE TELE 273 - 16 = 257 480 - 257 = 223
	mov x0, 87 // esquina superior izquierda, pos x
	mov x1, 16 // esquina superior izquierda, pos y
	mov x2, 476 // ancho
	mov x3, 252 // alto
	movz w7, #0x0019, lsl 16 // color
	movk w7, #0x1919, lsl 00
	bl hacer_rectangulo

	//CABEZA
	mov x0, #155     // center x
    mov x1, #326        // center y
    mov x2, #33         // radius
    movz w7, #0x6C, lsl 16 // color
	movk w7, #0x4600, lsl 00	
	bl hacer_circulo

	mov x0, #268     // center x
    mov x1, #326        // center y
    mov x2, #33         // radius
    movz w7, #0x6C, lsl 16 // color
	movk w7, #0x4600, lsl 00	
	bl hacer_circulo

	mov x0, #378     // center x
    mov x1, #326        // center y
    mov x2, #33         // radius
    movz w7, #0xF9, lsl 16 // color
	movk w7, #0x4B16, lsl 00	
	bl hacer_circulo

	mov x0, #488     // center x
    mov x1, #326        // center y
    mov x2, #33         // radius
    movz w7, #0xE8, lsl 16 // color
	movk w7, #0x9700, lsl 00	
	bl hacer_circulo

	// O-DC2025
	mov x0, 130	//centro x
	mov x1, 170	//centro y
	mov x3, 50	//alto
	movz w7, #0x00FF, lsl 16
	movk w7, #0xFFFF, lsl 00
	bl drawO
	//O interna
	mov x0, 130	//centro x
	mov x1, 170	//centro y
	mov x3, 35	//alto
	movz w7, #0x0019, lsl 16
	movk w7, #0x1919, lsl 00
	bl drawO

	//O-D-C2025
	mov x0, 185	//centro x
	mov x1, 170	//centro y
	mov x3, 50	//alto
	movz w7, #0x00FF, lsl 16
	movk w7, #0xFFFF, lsl 00
	bl drawD
	//D interna
	mov x0, 185	//centro x
	mov x1, 170	//centro y
	mov x3, 35	//alto
	movz w7, #0x0019, lsl 16
	movk w7, #0x1919, lsl 00
	bl drawD


	// OD-C-2025
	mov x0, 240	//centro x
	mov x1, 170	//centro y
	mov x3, 50	//alto
	movz w7, #0x00FF, lsl 16
	movk w7, #0xFFFF, lsl 00
	bl drawO
	mov x0, 240	//centro x
	mov x1, 170	//centro y
	mov x3, 35	//alto
	movz w7, #0x0019, lsl 16
	movk w7, #0x1919, lsl 00
	bl detailC


	// ODC-2-025
	mov x0, 290	//centro x
	mov x1, 170	//centro y
	mov x3, 50	//alto
	movz w7, #0x00FF, lsl 16
	movk w7, #0xFFFF, lsl 00
	bl drawdos

	// ODC2-0-25
	mov x0, 350	//centro x
	mov x1, 170	//centro y
	mov x3, 50	//alto
	movz w7, #0x00FF, lsl 16
	movk w7, #0xFFFF, lsl 00
	bl drawcero


	// ODC 202-5
	mov x0, 500	//centro x
	mov x1, 170	//centro y
	mov x3, 50	//alto
	movz w7, #0x00FF, lsl 16
	movk w7, #0xFFFF, lsl 00
	bl drawcinco
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
// Estándar de funciones (por si quieren hacer alguna)
// Se usan de x0 a x6 como parametros. x7 queda reservado para el parametro
// del color. x8 no se toca. En caso de necesitar mas parametros de variables,
// tienen que usar la memoria del stack. Una vez definidos los parametros
// pueden usar todos los x restantes hasta x6 y los registros desde x9 hasta
// x15 como registros de uso libre para lo que necesiten en el momento.
// Es recomendable que reutilizen los valores guardados en registros
// en vez de volver a calcular para optimizar lineas de codigo, pero como la
// cantidad es limitada (un maximo de 13 registros libres) no siempre es
// posible hacer esto.

// PRE: x0 < 640, x1 < 480, x2 < 640 + x0, x3 < 480 + x1, w7 <= 0xFFFFFF
hacer_rectangulo: //toma x0: esquina sup. izq. x,  x1: esquina sup. izq. y,
                  //x2: ancho, x3: alto, w7: color
	lsl x0, x0, #2 //todo * 2^2 (4) porque nos movemos cada 4 bytes por pixel
	lsl x2, x2, #2 // hacer mul con un registro que tenga el #4 es equivalente,
				   // yo uso lsl porque mul no toma numeros sueltos.
	mov x12, 2560 // 640 * 4, solo se puede multiplicar con registros :(. Esa es la escala de la altura, por cierto.
	mul x10, x1, x12 // las alturas son como recorrer una fila completa,
	mul x3, x3, x12 // por eso el 640
	add x10, x10, x20 // A la altura le sumo el inicio del framebuffer
	add x2, x0, x2 // el largo y ancho dependen del punto de partida
	add x3, x10, x3 // ahora tratamos x2 y x3 como los pixeles limite de dibujo 
	mov x12, x10 //hago un contador de filas para poder ir saltando hacia abajo
.loop1_hr:
	cmp x12, x3  //si llegamos a la fila limite, cortamos
	b.eq .ret_hr
	// NOTA: ahora usamos x1 como nuestro puntero, no es mas la pos y
	add x10, x0, x12 // para saltar, vamos al comienzo de la fila y sumamos x0
	add x11, x2, x12 // seteamos el limite de dibujo en la fila:
					 // posicion x limite mas "y" filas dibujadas
	add x12, x12, 2560 // una vez hechos los calculos, bajamos una fila.
					   // Esto solo afecta a la siguiente vuelta del bucle
.loop2_hr:
	cmp x10, x11
	b.eq .loop1_hr // si llegamos al pixel largo limite, volvemos a sumar fila
	stur w7, [x10] //pintamos
	add x10, x10, 4 //vamos al pixel siguiente	
	b .loop2_hr

.ret_hr:
	lsr x0, x0, #2
	lsr x2, x2, #2
	ret

// PRE: x01 < 640, x1 < 480, x2 < 640 + x0, x3 < 480 + x1, w7 <= 0xFFFFFF
// buscamos en toda la pantalla porque, a diferencia del rectangulo que
// no hay diferencia entre buscar en toda la pantalla y pintar el limite
// o buscar en los limites y pintar, en el circulo las condiciones de
// pintado (x^2 + y^2 = r^2) son las mismas en cualquier posicion en la
// pantalla 
hacer_circulo: // toma x0: centro x,  x1: centro y, x2: radio, w7: color
	lsl x0, x0, #2
	lsl x1, x1, #2
	lsl x2, x2, #2
	mov x3, 640
	mul x4, x1, x3 // x4 = centro y * 640
	mov x5, SCREEN_HEIGH
	mov x6, SCREEN_WIDTH
	mul x6, x5, x6 //640*480
	lsl x6, x6, #2 // * 4
	add x6, x6, x20 // calculamos el final de la pantalla: ancho * alto * 4 + sp del fb
	mov x5, x20 // x5 es puntero
	lsl x3, x3, #2

.loop_hc:
	cmp x5, x6
	b.eq .ret_hc
	sub x9, x5, X20 //obtenemos la posicion limpia, sin framebuffer, (y*640)+x
	sdiv x10, x9, x3     // obtenemos nuestra posicion en y: y + x/2560
	msub x11, x10, x3, x9 // obtenemos nuestra posicion en x = (y*2560)+x*4-y*640*4
	lsl x10, x10, #2
	sub x11, x11, x0 // obtenemos la posicion x relativa al centro: x - centro x
	sub x10, x10, x1 // obtenemos la posicion y relativa al centro: y - centro y
	mul x12, x2, x2 // r2
	mul x11, x11, x11 // x^2
	mul x10, x10, x10 //y^2
	add x10, x10, x11
	cmp x10, x12 // x^2+y^2=r^2
	b.gt .else
	str w7, [x5] //pintamos
.else:
	add x5, x5, 4 //vamos al pixel siguiente	
	b .loop_hc

.ret_hc:
	lsr x0, x0, #2
	lsr x1, x1, #2
	ret


