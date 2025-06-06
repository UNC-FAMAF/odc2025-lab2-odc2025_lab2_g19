
//IDEA GENERAL: CREAR ETIQUETA WRITE-ODC QUE DADA UNA X EN Y CALCULE DONDE VA CADA LETRA.
// WRITE ODC SE CALCULA DESDE LA ESQUINA SUPERIOR IZQUIERDA E INTERNAMENTE
// CALCULA EL CENTRO DE CADA LETRA


    .extern hacer_rectangulo    //.extern se "complementa" con .globl
                                // trae la etiqueta desde un codigo, 
                                // tiene que ser globl en el archivo que lo contiene
    .extern hacer_circulo
    .globl drawO
    .globl drawD
    .globl detailC
    .globl drawdos
    .globl drawcinco
    .globl drawcero
    .globl drawODC


drawO:    
    //chatgpt agency, como hago muchos bl se pierde el valor de x30 (ret). 
    //asi que lo guardo en el stack y leeesto ya foeee
    stp x29, x30, [sp, #-16]!

    // X0 centro en x 
    // X1 centro en y
    // X3 Tamaño (en Y), tamaño en X (X2) es fixed 85% el tamaño en y (dios me bendiga haciendolo)
    // el ancho de la o esta fixeado

    //Dimensiones 
    //Rectangulo horizontal: [85% Y, 80% Y] 
    //Rectangulo vertical: [75% Y, Y]

    //Guardo los valores iniciales
    mov x21, x0
    mov x22, x1
    mov x23, x3

    //----------------------------------------
    //         RECTANGULO VERTICAL
    //----------------------------------------

    mov x9, #30
    mov x10, #100
    mul x4, x3, x9
    udiv x4, x4, x10 //x4 = 5% de tam

    mov x2, x3
    sub x2, x2, x4  //x2 (ancho) = 70% X3

    // Muevo el centro en y de la o a la esquina superior izquerda del rectangulo parado (seria 5%
    // del ancho de la figura)
    mov x9, x3
    mov x10, #2
    udiv x9, x9, x10 //x9 = tam/2

    sub x1, x1, x9  //centro_y = borde superior, ya que el centro seria una posicion en y y le reste tam/2

    mov x11, x2
    udiv x11, x11, x10 //x11 = (tam-25%)/2    

    sub x0, x0, x11 //centro_x = punta superior izquierda

    bl hacer_rectangulo

    //----------------------------------------
    //         RECTANGULO HORIZONTAL
    //----------------------------------------
    //Volver a los valores iniciales
    mov x0, x21
    mov x1, x22
    mov x3, x23

    //volver a calcular x4 por las dudas
    mov x9, #5
    mov x10, #100
    
    mul x4, x3, x9
    udiv x4, x4, x10

    //QUEREMOS QUE X3 SEA EL 85% DE LO QUE ERA ANTES, O SEA, EL ALTO DEL RECT HORZ
    //SEA EL 85% DE ALTO DEL VERTICAL 

    mov x2, x3
    sub x2, x2, x4
    sub x2, x2, x4
    sub x2, x2, x4 // x2 = ancho = 85% X3

    mov x3, x2 // x3 = x2
    sub x3, x3, x4 // x3 = x2-5%
    sub x3, x3, x4 // x3 = x2-5% = x3 = x2-10%

    // Recalcular esquina superior izquierda
    mov x9, x2
    mov x10, #2
    udiv x9, x9, x10
    sub x0, x0, x9

    udiv x9, x3, x10
    sub x1, x1, x9
    
    bl hacer_rectangulo

    ldp x29, x30, [sp], #16 //Restaurar para hacer el ret como la gente
    ret


drawD:
    stp x29, x30, [sp, #-16]! //Guardamos x30 en el stack para que el ret final ande

    //guardo los valores iniciales
    mov x21, x0
    mov x22, x1
    mov x23, x3

    //----------------------------------------
    //         RECTANGULO NO PANZA
    //----------------------------------------

    // Muevo el centro en y de la o a la esquina superior izquerda del rectangulo parado (seria 5%
    // del ancho de la figura)
    mov x9, x3
    mov x10, #2
    udiv x9, x9, x10 //x9 = tam/2

    sub x1, x1, x9  //centro_y = borde superior, ya que el centro seria una posicion en y y le reste tam/2

    sub x0, x0, x9 //centro_x = punta superior izquierda

    //me faltaba definir el ancho, lo voy a hacer que sea x3 * 7/8 
    mov x2, x3
    mov x9, 7
    mul x2, x2, x9
    mov x10, 8
    udiv x2, x2, x10
    bl hacer_rectangulo
    //----------------------------------------
    //         RECTANGULO PANZA
    //----------------------------------------

    //Volver a los valores iniciales
    mov x0, x21
    mov x1, x22
    mov x3, x23     // x3= Alto
    mov x2, x3

    mov x9, 75
    mov x10, 100

    mul x3, x3, x9
    udiv x3, x3, x10        //x3 ahora es el 65% de lo que era :p

    mov x10, #2 
    udiv x2, x2, x10

    mov x9, x3
    udiv x9, x9, x10

    sub x1, x1, x9

    bl hacer_rectangulo

    ldp x29, x30, [sp], #16
    ret

detailC:
    stp x29, x30, [sp, #-16]!

    //Guardo los valores iniciales
    mov x21, x0
    mov x22, x1
    mov x23, x3

    //----------------------------------------
    //  PARTE VACIA (se tiene que pintar primero tristemente)
    //----------------------------------------

    movz w7, 0x0019, lsl 16
    movk w7, 0x1919, lsl 00

    //Ajustar el tamaño de x3
    mov x9, 3
    mul x3, x3, x9
    mov x9, 5
    udiv x3, x3, x9


    mov x2, x3  //Hacer que el ancho sea 2 * x3 
    add x2, x2, x2

    //acomodar el eje en x a 2/5 x3
    mov x9, 2
    mov x10, 5

    mul x9, x9, x3
    udiv x9, x9, x10

    sub x0, x0, x9
    //Acomodar el eje en y que sea x3 div 2

    mov x10, 2
    udiv x9, x3, x10

    sub x1, x1, x9
    
    bl hacer_rectangulo

    ldp x29, x30, [sp], #16
    ret

drawdos:

    stp x29, x30, [sp, #-16]!

    //Guardo los valores iniciales
    mov x21, x0
    mov x22, x1
    mov x23, x3

    //IDEA: RECTANGULO GRANDE Y PINTO DOS DOS RECTANGULOS DEL COLOR DE LA TELE
    //defino ancho = 4/5 x3
    mov x2, x3
    mov x9, 4 
    mul x2, x2, x9
    mov x9, 5
    udiv x2, x2, x9

    //mover x1 x3/2 para arriba
    mov x9, x3
    mov x10, 2
    
    udiv x9, x9, x10

    sub x1, x1, x9
    //mover x0, x2/2 para izq
    mov x9, x2
    mov x10, 2
    
    udiv x9, x9, x10

    sub x0, x0, x9
    bl hacer_rectangulo

    //-------------------------------
    //     RECTANGULO NEGRO 1 (el de abajo)
    //-------------------------------
    // restauro val iniciales
    mov x0, x21
    mov x1, x22
    mov x3, x23
    movz w7, 0x0019, lsl 16
    movk w7, 0x1919, lsl 00

    //muevo x1
    mov x9, 9
    udiv x9, x3, x9   
    add x1, x1, x9 

    //defino ancho = 3/4
    mov x2, x3
    mov x9, 3
    mul x2, x2, x9
    mov x9, 5
    udiv x2, x2, x9

    //defino alto = 1/5
    mov x9, 4
    udiv x3, x3, x9 //x3 = 1/5 (x3)

    //muevo x0
    mov x9, 1
    mul x9, x2, x9
    mov x10, 4
    udiv x9, x9, x10

    sub x0, x0, x9

    bl hacer_rectangulo 

    //----------------------------------------
    // PROXIMO RECTANGULO NEGRO
    //----------------------------------------

    mov x0, x21
    mov x1, x22
    mov x3, x23
    movz w7, 0x0019, lsl 16
    movk w7, 0x1919, lsl 00    
    
    //muevo x1
    mov x9, 3
    udiv x9, x3, x9   
    sub x1, x1, x9 

    //defino ancho = 2/3 (quedaba cool)
    mov x2, x3
    mov x9, 2
    mul x2, x2, x9
    mov x9, 3
    udiv x2, x2, x9

    //defino alto = 1/4
    mov x9, 4
    udiv x3, x3, x9 //x3 = 1/4 (x3)

    //muevo x0
    mov x9, 5
    mul x9, x2, x9
    mov x10, 7
    udiv x9, x9, x10

    sub x0, x0, x9

    bl hacer_rectangulo

    ldp x29, x30, [sp], #16
    ret

drawcero:

    stp x29, x30, [sp, #-16]!
    //Guardo los valores iniciales
    mov x21, x0
    mov x22, x1
    mov x23, x3

    //----------------------------------------
    //         RECTANGULO VERTICAL
    //----------------------------------------

    mov x9, 2
    udiv x2, x3, x9 //x2 = x3/2

    // Muevo el centro en y de la o a la esquina superior izquerda del rectangulo parado (seria 5%
    // del ancho de la figura)
    mov x9, x3
    mov x10, #2
    udiv x9, x9, x10 //x9 = tam/2

    sub x1, x1, x9  //centro_y = borde superior, ya que el centro seria una posicion en y y le reste tam/2

    mov x11, x2
    udiv x11, x11, x10 //x11 = (tam-25%)/2    

    sub x0, x0, x11 //centro_x = punta superior izquierda

    bl hacer_rectangulo

    //----------------------------------------
    //         RECTANGULO HORIZONTAL
    //----------------------------------------
    //Volver a los valores iniciales
    mov x0, x21
    mov x1, x22
    mov x3, x23

    //Calculo de x2 = 7/10 * x3
    mov x9, 7
    mul x9, x3, x9
    mov x10, 10
    udiv x2, x9, x10

    //Reduccion de x3
    mov x9, 4
    mul x3, x3, x9
    mov x9, 5
    udiv x3, x3, x9

    // Recalcular esquina superior izquierda
    mov x9, x2
    mov x10, #2
    udiv x9, x9, x10
    sub x0, x0, x9

    udiv x9, x3, x10
    sub x1, x1, x9
    
    bl hacer_rectangulo

    ldp x29, x30, [sp], #16 //Restaurar para hacer el ret como la gente
    ret

drawcinco:

    stp x29, x30, [sp, #-16]!

    //Guardo los valores iniciales
    mov x21, x0
    mov x22, x1
    mov x23, x3

    //IDEA: RECTANGULO GRANDE Y PINTO DOS DOS RECTANGULOS DEL COLOR DE LA TELE
    //defino ancho = 4/5 x3
    mov x2, x3
    mov x9, 4 
    mul x2, x2, x9
    mov x9, 5
    udiv x2, x2, x9

    //mover x1 x3/2 para arriba
    mov x9, x3
    mov x10, 2
    
    udiv x9, x9, x10

    sub x1, x1, x9
    //mover x0, x2/2 para izq
    mov x9, x2
    mov x10, 2
    
    udiv x9, x9, x10

    sub x0, x0, x9
    bl hacer_rectangulo

    //-------------------------------
    //     RECTANGULO NEGRO 1
    //-------------------------------
    // restauro val iniciales
    mov x0, x21
    mov x1, x22
    mov x3, x23
    movz w7, 0x0019, lsl 16
    movk w7, 0x1919, lsl 00

    //muevo x1
    mov x9, 9
    udiv x9, x3, x9   
    add x1, x1, x9 

    //defino ancho = 3/4
    mov x2, x3
    mov x9, 3
    mul x2, x2, x9
    mov x9, 4
    udiv x2, x2, x9

    //defino alto = 1/5
    mov x9, 4
    udiv x3, x3, x9 //x3 = 1/5 (x3)

    //muevo x0
    mov x9, 3
    mul x9, x2, x9
    mov x10, 4
    udiv x9, x9, x10

    sub x0, x0, x9

    bl hacer_rectangulo 

    //----------------------------------------
    // PROXIMO RECTANGULO NEGRO
    //----------------------------------------

    mov x0, x21
    mov x1, x22
    mov x3, x23
    movz w7, 0x0019, lsl 16
    movk w7, 0x1919, lsl 00    
    
    //muevo x1
    mov x9, 3
    udiv x9, x3, x9   
    sub x1, x1, x9 

    //defino ancho = 12/21 (quedaba cool)
    mov x2, x3
    mov x9, 12
    mul x2, x2, x9
    mov x9, 21
    udiv x2, x2, x9

    //defino alto = 1/5
    mov x9, 4
    udiv x3, x3, x9 //x3 = 1/5 (x3)

    //muevo x0
    mov x9, 2
    mul x9, x2, x9
    mov x10, 7
    udiv x9, x9, x10

    sub x0, x0, x9

    bl hacer_rectangulo

    ldp x29, x30, [sp], #16
    ret

drawODC:
    stp x29, x30, [sp, #-16]!

    // Guardar valores iniciales
    mov x25, x0      // x inicial
    mov x27, x3      // alto base
    mov w28, w7      // color base

    // Calcular y fijo el centro vertical (alineado)
    mov x9, 2
    udiv x3, x3, x9 
    add x26, x1, x3 // centro en Y = y + x3 / 2

    mov x3, x27
    // Factor de avance horizontal (0.85 x3) para cada letra
    mov x9, 85
    mul x9, x9, x3      // x9 = 85 * x3
    mov x10, 100
    udiv x9, x9, x10    // x9 = 0.85 * x3

    // Comienzo en x25, centro O
    add x25, x25, x9
    mov x0, x25
    mov x1, x26
    mov x3, x27
    mov w7, w28
    bl drawO

    // O interna 
    mov x0, x25
    mov x1, x26
    mov x3, x27
    mov x10, 2
    mul x3, x3, x10    
    mov x10, 3
    udiv x3, x3, x10// x3 = x3 * 2/3 (hueco interno)
    movz w7, #0x0019, lsl 16
    movk w7, #0x1919, lsl 00
    bl drawO

    // Avanzar para D
    mov x3, x27
    add x25, x25, x3   //avance hasta el final de la o

    add x25, x25, 3 //me muevo inm pixeles a la derecha

    //seteo para D
    mov x0, x25
    mov x1, x26
    mov x3, x27
    mov w7, w28
    bl drawD

    // D interna
    mov x0, x25
    mov x1, x26
    mov x3, x27
    mov x10, 2
    mul x3, x3, x10
    mov x10, 3
    udiv x3, x3, x10   // x3 * 2/3
    movz w7, #0x0019, lsl 16
    movk w7, #0x1919, lsl 00
    bl drawD

    //moverme tamD a la derecha 
    mov x3, x27
    add x25, x25, x3

    // Avanzar para C
    mov x0, x25
    mov x1, x26
    mov w7, w28
    bl drawO  

    //agujero de la C
    mov x0, x25
    mov x1, x26
    mov x3, x27
    movz w7, #0x0019, lsl 16
    movk w7, #0x1919, lsl 00
    bl detailC

    // Avanzar para 2
    mov x3, x27

    add x25, x25, x3
    mov x0, x25
    mov x1, x26
    mov w7, w28
    bl drawdos

    // Avanzar para 2
    mov x3, x27
    mov x9, 5
    mul x3, x9, x3
    mov x9, 6
    udiv x3, x3, x9

    add x25, x25, x3
    mov x0, x25
    mov x1, x26
    mov x3, x27
    mov w7, w28
    bl drawcero

    // 0 interno
    mov x0, x25
    mov x1, x26
    mov x3, x27
    mov x9, 2
    mul x3, x3, x9
    mov x9, 3
    udiv x3, x3, x9 
    movz w7, #0x0019, lsl 16
    movk w7, #0x1919, lsl 00
    bl drawcero

    // Avanzar para 2
    mov x3, x27
    mov x9, 9
    mul x3, x3, x9
    mov x9, 10
    udiv x3, x3, x9
    add x25, x25, x3
    mov x0, x25
    mov x1, x26
    mov x3, x27
    mov w7, w28
    bl drawdos

    // Avanzar para 5
    mov x3, x27
    mov x9, 9
    mul x3, x3, x9
    mov x9, 10
    udiv x3, x3, x9
    add x25, x25, x3
    mov x0, x25
    mov x1, x26
    mov x3, x27
    mov w7, w28
    bl drawcinco

    ldp x29, x30, [sp], #16
    ret
