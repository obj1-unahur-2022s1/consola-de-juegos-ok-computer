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
			self.sonidoPorMovimiento()
		}
	}
	
	method moverseAbajo() {
		if(position.y() != 0 and (not self.hayUnObjeto(abajo))) {
			direccion = abajo
			position = direccion.mover(position)
			self.sonidoPorMovimiento()
		}
	}
	
	method moverseDerecha() {
		if(position.x() != game.width() - 1 and (not self.hayUnObjeto(derecha))) {
			direccion = derecha
			position = direccion.mover(position)
			self.sonidoPorMovimiento()
		}
	}
	
	method moverseIzquierda() {
		if(position.x() != 0 and (not self.hayUnObjeto(izquierda))) {
			direccion = izquierda
			position = direccion.mover(position)
			self.sonidoPorMovimiento()
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
		game.onTick(50, "Disparo canionazo tanque jugador", { 
			canionazo.avanzar()
			self.sonidoDisparo()
		})
	}
	
	method hayUnObjeto(unaDireccion) {
		const objetoAca = game.getObjectsIn(unaDireccion.mover(position))
		return not objetoAca.isEmpty()
	}
	
	method destruirse() {
		game.removeVisual(self)
		self.sonidoMuerte()
		nivel.gameOver()
	}
	
	method sonidoPorMovimiento(){
		const mov = game.sound("tanqueJugadorMovimiento.mp3")
		mov.volume(0.1)
		mov.play()
	}
	
	method sonidoDisparo() {
		const disparo = game.sound("disparoTanqueJugador.mp3")
		disparo.volume(0.1)
		disparo.play()
	}
	
	method sonidoMuerte() {
		const muerte = game.sound("tanqueJugadorMuere.mp3")
		muerte.volume(0.1)
		muerte.play()
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
		self.sonidoMuerteEnemigo()
		game.removeVisual(self)
		nivel.ganaste()
	}
	
	method image()
	
	method sonidoMuerteEnemigo() {
		const muerte = game.sound("muerteTanqueEnemigo.mp3")
		muerte.volume(0.1)
		muerte.play()
	}
}

class TanqueEnemigoComun inherits TanquesEnemigos{
	
	override method image() = direccion.toString() + "Enemigo1.png"
	
	/*override method disparar() {
		const canionazoComun = new CanionazosEnemigos(position=self.position(),direccion=self.position())
		
		game.addVisual(canionazoComun)
		canionazoComun.position(self.position())
		canionazoComun.direccion(self.direccion())
		game.onTick(500, "Disparo canionazo tanque enemigo", { canionazoComun.avanzar() })
	}*/
}

class TanqueEnemigoRapido inherits TanquesEnemigos {
	
	override method image() = direccion.toString() + "Enemigo2.png"
	
	/*override method disparar() {
		const canionazoRapido = new CanionazosEnemigos(position=self.position(),direccion=self.position())
		
		game.addVisual(canionazoRapido)
		canionazoRapido.position(self.position())
		canionazoRapido.direccion(self.direccion())
		game.onTick(500, "Disparo canionazo tanque enemigo", { canionazoRapido.avanzar() })
	}*/
}

class TanqueEnemigoResistente inherits TanquesEnemigos {

	var property salud = 3
	
	override method image() = direccion.toString() + "Enemigo3.png"
	
	override method destruirse() { 
		salud = 0.max(salud - 1)

		if(salud == 0) {
			game.removeVisual(self)
			self.sonidoMuerteEnemigo()
		}
	}
	
	/*override method disparar() {
		const canionazoResistente = new CanionazosEnemigos(position=self.position(),direccion=self.position())
		
		game.addVisual(canionazoResistente)
		canionazoResistente.position(self.position())
		canionazoResistente.direccion(self.direccion())
		game.onTick(500, "Disparo canionazo tanque enemigo", { canionazoResistente.avanzar() })
	}*/
}

object aguila {
	const property position = game.at(6,0)
	const property image = "proteger.png"
	
	method destruirse() { game.removeVisual(self) }
}