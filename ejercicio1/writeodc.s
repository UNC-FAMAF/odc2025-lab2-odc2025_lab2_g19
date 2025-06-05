
//IDEA GENERAL: CREAR ETIQUETA WRITE-ODC QUE DADA UNA X EN Y CALCULE DONDE VA CADA LETRA.
// WRITE ODC SE CALCULA DESDE LA ESQUINA SUPERIOR IZQUIERDA E INTERNAMENTE
// CALCULA EL CENTRO DE CADA LETRA


    .extern hacer_rectangulo    //.extern se "complementa" con .globl
                                // trae la etiqueta desde un codigo, 
                                // tiene que ser globl en el archivo que lo contiene
    .extern hacer_circulo
    .globl drawO

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

    mov x9, #5
    mov x10, #100
    mul x4, x3, x9
    udiv x4, x4, x10 //x4 = 5% de tam

    mov x2, x3
    sub x2, x2, x4  //x2 (ancho) = 75% X3
    sub x2, x2, x4
    sub x2, x2, x4
    sub x2, x2, x4
    sub x2, x2, x4 //kjjjjjjj

    // Muevo el centro en y de la o a la esquina superior izquerda del rectangulo parado (seria 5%
    // del ancho de la figura)
    mov x9, x3
    mov x10, #2
    udiv x9, x9, x10 //x9 = tam/2

    sub x1, x1, x9  //centro_y = borde superior, ya que el centro seria una posicion en y y le reste tam/2

    mov x11, x2
    udiv x11, x11, x10 //x11 = (tam-25%)/2    

    sub x0, x0, x11 //centro_x = punta superior izquierda


    //AJUSTE--- MEJORO UN POCO LA PROPORCION DE LA O
    sub x3, x3, x4


    bl hacer_rectangulo

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
    sub x2, x2, x4 // x2 = ancho

    mov x3, x2 // también usamos el mismo para alto
    sub x3, x3, x4
    sub x3, x3, x4

    // Recalcular esquina superior izquierda
    mov x9, x2
    mov x10, #2
    udiv x9, x9, x10
    sub x0, x0, x9

    udiv x9, x3, x10
    sub x1, x1, x9
    
    bl hacer_rectangulo

    //Volver a los valores iniciales
    mov x0, x21
    mov x1, x22
    mov x3, x23
    
	movz w7, #0x0019, lsl 16 // color del tele
	movk w7, #0x1919, lsl 00

    //hacer rectangulo en el medio
    mov x9, #5
    mov x10, #100
    mul x4, x3, x9
    udiv x4, x4, x10
    //x2 el ancho del rect interior 60% x3
    mov x9, #60
    mul x2, x3, x9
    udiv x2, x2, x10 

    //x3 el alto del rectangulo interior 65% x3
    mov x9, #65
    mul x3, x3, x9
    udiv x3, x3, x10

    //mover el centro (x) a la esq sup izq
    mov x9, x2
    mov x10, #2
    udiv x9, x9, x10
    sub x0, x0, x9 

    //mover el centro (y) a la esq sup izq
    mov x9, x3
    udiv x9, x9, x10
    sub x1, x1, x9

    bl hacer_rectangulo

    ldp x29, x30, [sp], #16 //Restaurar para hacer el ret como la gente
    ret

.globl drawD
drawD:
    stp x29, x30, [sp, #-16]!

    //guardo los valores iniciales
    mov x21, x0
    mov x22, x1
    mov x23, x3


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

    //Volver a los valores iniciales
    mov x0, x21
    mov x1, x22
    mov x3, x23
    
	movz w7, #0x0019, lsl 16 // color del tele
	movk w7, #0x1919, lsl 00

    //hacer rectangulo en el medio
    mov x9, #5
    mov x10, #100
    mul x4, x3, x9
    udiv x4, x4, x10
    //x2 el ancho del rect interior 60% x3
    mov x9, #60
    mul x2, x3, x9
    udiv x2, x2, x10 

    //x3 el alto del rectangulo interior 65% x3
    mov x9, #65
    mul x3, x3, x9
    udiv x3, x3, x10

    //mover el centro (x) a la esq sup izq
    mov x9, x2
    mov x10, #2
    udiv x9, x9, x10
    sub x0, x0, x9 

    //mover el centro (y) a la esq sup izq
    mov x9, x3
    udiv x9, x9, x10
    sub x1, x1, x9

    bl hacer_rectangulo

    ldp x29, x30, [sp], #16

    ret

