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
	
	method moverseArriba() {
		if(position.y() != game.height() - 1 and (not self.hayUnObjeto(arriba))) {
			direccion = arriba
			position = direccion.mover(position)
		}
	}
	
	method moverseAbajo() {
		if(position.y() != 0 and (not self.hayUnObjeto(abajo))) {
			direccion = abajo
			position = direccion.mover(position)
		}
	}
	
	method moverseDerecha() {
		if(position.x() != game.width() - 1 and (not self.hayUnObjeto(derecha))) {
			direccion = derecha
			position = direccion.mover(position)
		}
	}
	
	method moverseIzquierda() {
		if(position.x() != 0 and (not self.hayUnObjeto(izquierda))) {
			direccion = izquierda
			position = direccion.mover(position)
		}
	}
	/* 
	method recibirDisparo() { 
		if (canionazoJugador.position() == self.position())
			self.destruirse()
			game.removeVisual(canionazoJugador)
	}
	*/
	method disparar() {
		
		game.addVisual(canionazo)
		canionazo.position(self.position())
		canionazo.direccion(self.direccion())
		game.onTick(100, "Disparo canionazo tanque jugador", { 
			canionazo.avanzar()
		})
	}
	
	method hayUnObjeto(unaDireccion) {
		const objetoAca = game.getObjectsIn(unaDireccion.mover(position))
		return not objetoAca.isEmpty()
	}
	
	method destruirse() {
		game.removeVisual(self)
	}
}

class TanquesEnemigos {
	var property position
	var property direccion = abajo
	
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
	
	method moverse() {
		direccion = self.direccionesPosibles().anyOne()
		position = direccion.mover(position)
	}
	
	method hayUnObjeto(unaDireccion) {
		const objetoAca = game.getObjectsIn(unaDireccion.mover(self.position()))
		return not objetoAca.isEmpty()
	}
	
	method disparar() {
		
		game.addVisual(canionazo)
		canionazo.position(self.position())
		canionazo.direccion(self.direccion())
		game.onTick(500, "Disparo canionazo tanque enemigo", { canionazo.avanzar() })
	}
	
	/* 
	method recibirDisparo() { 
		if (canionazoJugador.position() == self.position()) {
			self.destruirse()
			game.removeVisual(canionazoJugador)
		}
	}
	*/
	method destruirse() {
		game.removeVisual(self)
	}
	
	method image()
}

class TanqueEnemigoComun inherits TanquesEnemigos{
	
	override method image() = direccion.toString() + "Enemigo1.png"
	
	
}

class TanqueEnemigoRapido inherits TanquesEnemigos {
	
	override method image() = direccion.toString() + "Enemigo2.png"
	
}

class TanqueEnemigoResistente inherits TanquesEnemigos {

	var property salud = 3
	
	override method image() = direccion.toString() + "Enemigo3.png"
	
	override method destruirse() { 
		salud = 0.max(salud - 1)

		if(salud == 0) {
			game.removeVisual(self)
		}
	}
}

object aguila {
	const property position = game.at(6,0)
	const property image = "proteger.png"
	
	method destruirse() { game.removeVisual(self) }
}