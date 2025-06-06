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
								// desde otros codigos (usado en writeodc.s)
	.globl hacer_circulo
	.extern drawO
	.extern drawD
	.extern detailC
	.extern drawcero
	.extern drawcinco
	.extern drawODC

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE -----------------------------------
	sub sp, sp, #48    // Allocate space for 3 colors
	mov x24, sp
	movz w0, 0x0075, lsl 16
	movk w0, 0xAADB, lsl 00
	movz w1, 0x00FF, lsl 16
	movk w1, 0xFFFF, lsl 00
	movz w2, 0x00FC, lsl 16
	movk w2, 0xBF45, lsl 00
	str w0, [sp, #0]
	str w1, [sp, #4]
	str w2, [sp, #8]
	add sp, sp, #48

	mov x2, SCREEN_HEIGH  
	mov x0, x20      // Y Size
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

	// 2: DIBUJO DE ELEMENTOS DE LA IMAGEN:
	// a. PISO
	mov x0, 0 // esquina superior izquierda, pos x
	mov x1, 349 // esquina superior izquierda, pos y
	mov x2, 640 // ancho
	mov x3, 131 // alto
	movz w7, #0x31, lsl 16 // color
	movk w7, #0x33CC, lsl 00
	bl hacer_rectangulo


	// b. Marco del televisor
	mov x0, 87 // esquina superior izquierda, pos x
	mov x1, 16 // esquina superior izquierda, pos y
	mov x2, 476 // ancho
	mov x3, 252 // alto
	movz w7, #0x0019, lsl 16 // color
	movk w7, #0x1919, lsl 00
	bl hacer_rectangulo

	//c. Pantalla del televisor
	bl pantalla_negra

	//d. Cabezas:
	//i. Cabeza del sillón 1
	mov x0, #155     // centro x
    mov x1, #326        // centro y
    mov x2, #33         // radio
    movz w7, #0x6C, lsl 16 // color
	movk w7, #0x4600, lsl 00	
	bl hacer_circulo

	//ii. Cabeza del sillón 2
	mov x0, #268     
    mov x1, #326        
    mov x2, #33  
    movz w7, #0x6C, lsl 16 
	movk w7, #0x4600, lsl 00	
	bl hacer_circulo

	//iii. Cabeza del sillón 3
	mov x0, #378  
    mov x1, #326       
    mov x2, #33        
    movz w7, #0xF9, lsl 16 
	movk w7, #0x4B16, lsl 00	
	bl hacer_circulo

	//iv. Cabeza del sillón 4
	mov x0, #488     
    mov x1, #326       
    mov x2, #33         
    movz w7, #0xE8, lsl 16 
	movk w7, #0x9700, lsl 00	
	bl hacer_circulo

	//-------------------------------------------------SILLON---------------------------------------------------------

//Apoyabrazo izquierdo cuerpo
	mov x0, #75
	mov x1, #370
	mov x2, #505
	mov x3, #80
	movz w7, #0x76, lsl 16
	movk w7, #0x0202, lsl 00
	bl hacer_rectangulo	

//Apoyabrazo izquierdo margen izquierdo
	mov x0, #70
	mov x1, #375
	mov x2, #39
	mov x3, #80
	movz w7, #0x76, lsl 16
	movk w7, #0x0202, lsl 00
	bl hacer_rectangulo	

//Círculo del apoyabrazo izquierdo
	mov x0, #75
	mov x1, #375
	mov x2, #5
	movz w7, #0x76, lsl 16
	movk w7, #0x0202, lsl 00
	bl hacer_circulo

//Apoyabrazo derecho parte abajo
	mov x0, #541
	mov x1, #373
	mov x2, #44
	mov x3, #82
	movz w7, #0x76, lsl 16
	movk w7, #0x0202, lsl 00
	bl hacer_rectangulo

//Círculo del apoyabrazo izquierdo
	mov x0, #580
	mov x1, #375
	mov x2, #5
	movz w7, #0x76, lsl 16
	movk w7, #0x0202, lsl 00
	bl hacer_circulo


//CIRCULO IZQUIERDO DE RADIO 14
	mov x0, #106
	mov x1, #330
	mov x2, #14
	movz w7, #0xC0, lsl 16
	movk w7, #0x0303, lsl 00
	bl hacer_circulo

//CIRCULO DERECHO DE RADIO 14
	mov x0, #549
	mov x1, #330
	mov x2, #14
	movz w7, #0xC0, lsl 16
	movk w7, #0x0303, lsl 00
	bl hacer_circulo

	//Margen izquierdo del sillón
	mov x0, #92
	mov x1, #330
	mov x2, #14
	mov x3, #125
	movz w7, #0xC0, lsl 16
	movk w7, #0x0303, lsl 00
	bl hacer_rectangulo

	//Margen derecho del sillón
	mov x0, #549
	mov x1, #330
	mov x2, #14
	mov x3, #125
	movz w7, #0xC0, lsl 16
	movk w7, #0x0303, lsl 00
	bl hacer_rectangulo

	//Cuerpo del sillón
	mov x0, #106
	mov x1, #316
	mov x2, #443
	mov x3, #139
	movz w7, #0xC0, lsl 16
	movk w7, #0x0303, lsl 00
	bl hacer_rectangulo

	//ANIMACION
	bl animacion

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
	sub x3, x3, x20
	mov x10, 2560
	sdiv x3, x3, x10
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
	lsr x2, x2, #2
	ret

animacion:
	mov x15, 120 // Usamos x15 y x16 como los almacenes de la posicion de la 
	mov x16, 40 // esquina izquierda de odc, en x e y respectivamente
	mov x13, 1 // Movimiento en x
	mov x14, 1 // Movimiento en y
	mov x17, 3 // Uso x17 para hacer delay en el ruido blanco, porque dejarlo
	mov w19, 0 // sin delay es demasiado rapido. En W19 almaceno el color del
			   // primer pixel para poder alternar los colores del ruido blanco
			   // y que se vea mejor
.loop_an:
	bl pantalla_negra // Refrescamos la pantalla
	adds x2, x13, x14 // Para que el ruido blanco arranque y termine cada vez
	cbz x2, ruido_blanco // que rebota (en este caso, si el mov de x e y son opuestos)
.ret:
	mov x0, x15 //cargamos los datos guardados de la posicion de x e y en 
	mov x1, x16 // los registros que usamos como parametros de drawODC
	mov x2, 30 // ancho y alto
	mov x3, x2
	mov x4, 348 // limite derecho de rebote en x
	mov x5, 233 // limite inferior de rebote en y
	mov x12, 80 // limite izq de rebote en x
	mov x9, 21 // limite inf de rebote en y
	cmp x0, x12 // si llegamos al limite izquierdo, rebotamos en x
	b.le .rebotar_x
	cmp x0, x4 // si llegamos al limite derecho, tambien
	b.ge .rebotar_x
	b .no_rebotar_x // si no llegamos a ningun limite, no rebotamos
.rebotar_x:
	sub x13, xzr, x13 // rebotar es que se mueva en la dirección opuesta ;)
	add x24, x24, 4
	sub x6, sp, 36
	cmp x24, x6
	b.lt .no_resetear
	sub x24, x24, #12
.no_resetear:
.no_rebotar_x:
	cmp x1, x9 // hacemos la misma logica con y
	b.le .rebotar_y
	cmp x1, x5
	b.ge .rebotar_y

	b .no_rebotar_y
.rebotar_y:
	sub x14, xzr, x14
	add x24, x24, 4
	sub x6, sp, 36
	cmp x24, x6
	b.lt .no_rebotar_y
	sub x24, x24, #12
.no_rebotar_y:
	add x0, x0, x13 // nos movemos en x
	add x1, x1, x14 // nos movemos en y
	mov x15, x0 // guardamos la nueva posicion de x
	mov x16, x1 // guardamos la nueva posicion de y
	ldr w7,  [x24]

	bl drawODC

	mov x6, #1 // hacemos un delay
	lsl x6, x6, #21
.delay:
    subs x6, x6, #1
    b.ne .delay
	

	b .loop_an // seguimos la animacion

ruido_blanco:
	subs x17, x17, 1 // hacemos un delay de 6 iteraciones
	eor w19, w19, 0x00FFFFFF // invertimos el color de w19 para alternar el
	and w19, w19, 0x00FFFFFF // patron de ruido blanco. Le hacemos and para
							 // que no se salga del rango de color
	cbnz x17, .no_cambiar_patron
	mov x17, 3 // reiniciamos el contador de delay
	eor w19, w19, 0x00FFFFFF // invertimos el color de w19 para alternar el
	and w19, w19, 0x00FFFFFF // patron de ruido blanco. Le hacemos and para
							 // que no se salga del rango de color
.no_cambiar_patron:
	mov x2, 22 //arrancamos a dibujar desde esta posicion en y
	mov x3, 268  //limite en y
	mov x4, 2560 //cada fila tiene 2560 bytes (640*4)
	mul x2, x2, x4 // calcumamos las pos en y con respecto a 2560
	mul x3, x3, x4
	lsl x4, x4, #3 // multiplico por 8 para que el salto de puntos sea 4 filas
.loop0_rb:
	cmp x2, x3 // si llegamos o superamos la fila limite, cortamos
	b.ge .ret
	mov x0, x2 // x0 es el puntero a la fila que vamos a pintar
	add x0, x0, 380 //offset en x
	add x0, x0, x20 // sumamos el inicio del framebuffer
	mov x1, x0 
	add x1, x1, 1832 // limite de la fila con respecto al inicio, 1888=4*472
	add x2, x2, x4 // sumamos 4 filas para el siguiente bucle
	eor w19, w19, #0x00FFFFFF  // negamos el color de w19 para alternar el patron
	and w19, w19, #0x00FFFFFF // y que no se salga del rango de color
.loop1_rb:
	cmp x0, x1 // si llegamos al limite de la fila, cortamos
	b.ge .loop0_rb
	eor w19, w19, #0x00FFFFFF  // negamos el color de w19 para alternar el patron
	and w19, w19, #0x00FFFFFF // y que no se salga del rango de color
	stur w19, [x0] // pintamos 4 pixeles en fila
	stur w19, [x0, 4]
	stur w19, [x0, 8]
	stur w19, [x0, 12]
	add x0, x0, 32 // avanzamos 32 bytes (4 pixeles) para el siguiente bucle
	b .loop1_rb

pantalla_negra:
	mov x0, 92 // esquina superior izquierda, pos x
	mov x1, 21 // esquina superior izquierda, pos y
	mov x2, 466 // ancho
	mov x3, 242 // alto
	mov w7, #0 
	stp x29, x30, [sp, #-32]!   // para poder hacer un ret recursivo, hay que
	mov x29, sp                // guardar el frame pointer y el link register
	bl hacer_rectangulo
	ldp x29, x30, [sp], #32   // restauramos FP y LR
	ret
