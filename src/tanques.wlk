import wollok.game.*
import niveles.*
import direcciones.*

//moverse
//disparar
//recibir disparo
//destruirse

object tanqueJugador{
	var property salud = 1
	var property position = game.at(4,0)
	var property image = "tanquePrincipal.png"
	
	method recibirDisparo() { salud = 0 }
	
}

object tanqueEnemigo {
	var property salud = 1
	var property position = game.at(6,12)
	var property image = "enemigo1.png"
	
	method recibirDisparo() { salud = 0 }
	
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

object tanqueEnemigoRapido {
	var property salud = 1
	var property position = game.at(0,12)
	var property image = "enemigo2.png"
	
	method recibirDisparo() { salud = 0 }
	
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

object tanqueEnemigoResistente {
	var property salud = 3
	var property position = game.at(12,12)
	var property image = "enemigo3.png"
	
	method recibirDisparo() { salud = 0.max(salud - 1) }
	
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

object aguila {
	var property salud = 1
	const property position = game.at(6,0)
	const property image = "proteger.png"
	
	method recibirDisparo() { salud = 0 }
}