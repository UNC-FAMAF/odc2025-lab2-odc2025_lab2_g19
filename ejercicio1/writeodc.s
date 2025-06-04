
//IDEA GENERAL: CREAR ETIQUETA WRITE-ODC QUE DADA UNA X EN Y CALCULE DONDE VA CADA LETRA.
// WRITE ODC SE CALCULA DESDE LA ESQUINA SUPERIOR IZQUIERDA E INTERNAMENTE
// CALCULA EL CENTRO DE CADA LETRA


    .extern hacer_rectangulo    //.extern se "complementa" con .globl
                                // trae la etiqueta desde un codigo, 
                                // tiene que ser globl en el archivo que lo contiene
    .globl drawO
drawO:    
    // X0 centro en x 
    // X1 centro en y
    // X3 Tamaño (en Y), tamaño en X (X2) es fixed 85% el tamaño en y (dios me bendiga haciendolo)
    // el ancho de la o esta fixeado

    //Dimensiones 
    //Rectangulo horizontal: [85% Y, 80% Y] 
    //Rectangulo vertical: [75% Y, Y]

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

    sub x1, x1, x9  //c_y = borde superior, ya que el centro seria una posicion en y y le reste tam/2

    mov x11, x2
    udiv x11, x11, x10 //x9 = (tam-25%)/2    

    sub x0, x0, x11
    
    bl hacer_rectangulo

    add x0, x0, x11
    add x1, x1, x9
