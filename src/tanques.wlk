import wollok.game.*
import niveles.*
import direcciones.*

//moverse
//disparar
//recibir disparo
//destruirse

object tanqueJugador{
	var property position = game.at(4,0)
	var property image = "tanquePrincipal.png"
	
	method recibirDisparo() { game.removeVisual(self)}
	
}

class TanquesEnemigos {
	var property position
	var property image
	
	method recibirDisparo() { game.removeVisual(self)}
	
	method direccionesPosibles() {
		const direcciones = [arriba,abajo,derecha,izquierda]
		
		if(position.y() == game.height() - 1) {
			direcciones.remove(arriba)
		}
		
		if(position.y() == 0) {
			direcciones.remove(abajo)
		}
		
		if(position.x() == game.width() - 1) {
			direcciones.remove(derecha)
		}
		
		if(position.x() == 0) {
			direcciones.remove(izquierda)
		}
		return direcciones
	}
	
	method mover() {
		position = self.direccionesPosibles().anyOne().mover(position)
	}
}

class TanqueEnemigoResistente inherits TanquesEnemigos{
	var property salud = 3
	
	override method recibirDisparo() { 
		salud = 0.max(salud - 1)
		
		if(salud == 0) {
			game.removeVisual(self)
		}
	}
	
}

object aguila {
	const property position = game.at(6,0)
	const property image = "proteger.png"
	
	method recibirDisparo() { game.removeVisual(self) }
}