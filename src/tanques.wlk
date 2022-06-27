import wollok.game.*
import niveles.*
import direcciones.*


//moverse
//disparar
//recibir disparo
//destruirse

object tanqueJugador {
	var property direccion = arriba
	var property position = game.at(4,0)

	method image() = direccion.toString() + "Jugador.png"
	
	method moverse(unaDireccion) {
		if(not self.hayUnObjeto(unaDireccion)) {
			position = unaDireccion.mover(position)
			direccion = unaDireccion
		}
	}
	
	method recibirDisparo() { game.removeVisual(self)}
	
	method disparar() {
		var disparo = new Canionazo()
		
		game.addVisualIn(disparo,direccion.mover(position))
	}
	
	method hayUnObjeto(unaDireccion) {
		const objetoAca = game.getObjectsIn(unaDireccion.mover(position))
		return not objetoAca.isEmpty()
	}
}

class TanquesEnemigos {
	var property position
	var property image 
	var direccion = abajo
	
	method recibirDisparo() { game.removeVisual(self) }
	
	method direccionesPosibles() {
		const direcciones = [arriba,abajo,derecha,izquierda]
		
		if(position.y() == game.height() - 1 or self.hayUnObjeto(arriba)) {
			direcciones.remove(arriba)
		}
		
		if(position.y() == 0  or self.hayUnObjeto(abajo)) {
			direcciones.remove(abajo)
		}
		
		if(position.x() == game.width() - 1 or self.hayUnObjeto(derecha)) {
			direcciones.remove(derecha)
		}
		
		if(position.x() == 0 or self.hayUnObjeto(izquierda)) {
			direcciones.remove(izquierda)
		}
		
		return direcciones
	}
	
	method mover() {
		direccion = self.direccionesPosibles().anyOne()
		position = direccion.mover(position)
	}
	
	method hayUnObjeto(unaDireccion) {
		const objetoAca = game.getObjectsIn(unaDireccion.mover(position))
		return not objetoAca.isEmpty()
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