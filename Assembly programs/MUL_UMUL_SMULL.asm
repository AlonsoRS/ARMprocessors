.global _start
_start:
	
	// Función para hallar la Fuerza ejercida sobre un objeto

    // Fuerza = Masa * Aceleración

    SUB R0, R15, R15 //Asignando 0 a los valores
	SUB R1, R15, R15
	SUB R2, R15, R15
	
	ADD R0, R0, #50 // Masa
    ADD R1, R1, #10 //Aceleración 1
    ADD R2, R2, #-5 //Aceleración 2
	
	BL FUERZA
	B END
	
	FUERZA:

    UMULL R3, R4, R0, R1 //  Fuerza 1 = Masa * Aceleración  1
	MUL  R5, R0, R1 //Fuerza 1 = Masa * Aceleración 1
    SMULL R6, R7, R0, R2 // Fuerza 2 = Masa * Aceleración 2
	
	MOV PC, LR
	
	END: