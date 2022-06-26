import wollok.game.*
import niveles.*

//moverse
//disparar
//recibir disparo
//destruirse

class Tanque {
	var property salud = 1
	var property image = ""
	var property position = 0
	
	method recibirDisparo() { salud = 0 }
	
}

class TanqueJugador inherits Tanque{
	override method image() = "tanquePrincipal.png"
	override method position() = game.at(4,0)
}

class TanqueEnemigo inherits Tanque {
	override method image() = "enemigo1.png"
	override method position() = game.at(6,12)
}

class TanqueEnemigoRapido inherits Tanque {
	override method image() = "enemigo2.png"
	override method position() = game.at(0,12)
}

class TanqueEnemigoResistente inherits Tanque {
	override method image() = "enemigo3.png"
	override method position() = game.at(12,12)
	override method salud() = 3
}

object aguila {
	var property salud = 1
}
