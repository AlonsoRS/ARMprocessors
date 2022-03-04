.global _start
_start:
	
	//Programa para sumar masas y hallar el momento M=mv
	
	//Los registros fueron inicializados mediante hardcode.
	
	// Masa 1 = R5 = 60 kg = 0x42700000 = 0x4270
	// Masa 2 = R6 = 10.5 kg = 41280000 = 0x4128
	// Velocidad = R7 = 5 m/s =40a00000 = 0x40a0
	
	BL f
	
	B End
	
	f:
	FPADD R0, R5, R6 // Suma de masas FP 32-bits
	FPMUL R1, R5, R7 // Masa 1 * Velocidad FP 32-bits
	FPADD16 R2, R5, R6 // Suma de masas FP 16-bits
	FPMUL16 R3, R5, R7 // Masa 1 * Velocidad FP 16-bits
	
	
	End:
	