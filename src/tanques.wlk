import wollok.game.*

//moverse
//disparar
//recibir disparo
//destruirse

class Tanque {
	var property salud = 1
	var property image
	var property position = game.origin()
	
	method recibirDisparo() { salud = 0}
}

class TanqueJugador inherits Tanque{
	
}

class TanqueEnemigo inherits Tanque {
	
}

class TanqueEnemigoRapido inherits Tanque {
	
}

class TanqueEnemigoResistente inherits Tanque {
	override method salud() = 3
	
	override method recibirDisparo(){ 0.max(salud - 1) } 
}

object estrella {
	var property salud = 1
}
