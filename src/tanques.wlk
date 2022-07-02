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
	 
	method recibirDisparoEnemigo() { 
		self.destruirse()
	}
	
	method recibirDisparo() {}
	
	method disparar() {
		
		game.addVisual(canionazo)
		canionazo.position(self.position())
		canionazo.direccion(self.direccion())
		game.onTick(50, "Disparo canionazo tanque jugador", { 
			canionazo.avanzar()
			self.sonidoDisparo()
		})
		
		game.onCollideDo(canionazo, { objeto =>
			if(objeto != self) {
				objeto.recibirDisparo() 
				game.removeTickEvent("Disparo canionazo tanque jugador")
				game.removeVisual(canionazo)}
		} )
	}
	
	method hayUnObjeto(unaDireccion) {
		const objetoAca = game.getObjectsIn(unaDireccion.mover(position))
		return not objetoAca.isEmpty()
	}
	
	method destruirse() {
		game.removeVisual(self)
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
	
	/*method sonidoMuerte() { 
		const muerte = game.sound("tanqueJugadorMuere.mp3")
		muerte.volume(0.1)
		muerte.play()
	}
	/// Lo saqué porque queda mejor el sonido del game over directamente.
	*/ 
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
	
	method disparar() {}
	
	method recibirDisparo() { 
		self.destruirse()
	}
	
	method recibirDisparoEnemigo() {}
	
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
	
	override method disparar() {
		const canionazoEnemigo = new CanionazoComun(position = self.position(), direccion=self.direccion())
		
		game.addVisual(canionazoEnemigo)
		canionazoEnemigo.position(self.position())
		canionazoEnemigo.direccion(self.direccion())
		game.onTick(50, "Disparo canionazo tanque enemigo comun", { canionazoEnemigo.avanzar() })
		
		game.onCollideDo(canionazoEnemigo, { objeto =>
			if(objeto != self) {
				objeto.recibirDisparoEnemigo() 
				game.removeTickEvent("Disparo canionazo tanque enemigo comun")
				game.removeVisual(canionazoEnemigo)}
		} )
	}
}

class TanqueEnemigoRapido inherits TanquesEnemigos {
	
	override method image() = direccion.toString() + "Enemigo2.png"
	
	override method disparar() {
		const canionazoEnemigo = new CanionazoRapido(position = self.position(), direccion=self.direccion())
		
		game.addVisual(canionazoEnemigo)
		canionazoEnemigo.position(self.position())
		canionazoEnemigo.direccion(self.direccion())
		game.onTick(50, "Disparo canionazo tanque enemigo rapido", { canionazoEnemigo.avanzar() })
		
		game.onCollideDo(canionazoEnemigo, { objeto =>
			if(objeto != self) {
				objeto.recibirDisparoEnemigo() 
				game.removeTickEvent("Disparo canionazo tanque enemigo rapido")
				game.removeVisual(canionazoEnemigo) }
		} )
	}
}

class TanqueEnemigoResistente inherits TanquesEnemigos {

	var property salud = 3
	
	override method image() = direccion.toString() + "Enemigo3.png"
	
	override method destruirse() { 
		salud = 0.max(salud - 1)
		game.say(self,"me queda " + salud + " de vida")
		if(salud == 0) {
			game.removeVisual(self)
			self.sonidoMuerteEnemigo()
		}
	}
	
	override method disparar() {
		const canionazoEnemigo = new CanionazoResistente(position = self.position(), direccion=self.direccion())
		
		game.addVisual(canionazoEnemigo)
		canionazoEnemigo.position(self.position())
		canionazoEnemigo.direccion(self.direccion())
		game.onTick(50, "Disparo canionazo tanque enemigo resistente", { canionazoEnemigo.avanzar() })
		
		game.onCollideDo(canionazoEnemigo, { objeto =>
			objeto.recibirDisparoEnemigo() 
			game.removeTickEvent("Disparo canionazo tanque enemigo resistente")
			game.removeVisual(canionazoEnemigo)
		} )
	}
}
/// CAÑONAZOS ///
object canionazo {
	var property position = tanqueJugador.position()
	var property direccion = tanqueJugador.direccion()
	
	method image() = "canionazo.png"
	
	method avanzar() {
		
		position = direccion.mover(position)
		
		if(position.y() > game.height() - 1) {
			game.removeTickEvent("Disparo canionazo tanque jugador")
			game.removeVisual(self)
		}
		
		if(position.y() < 0) {
			game.removeTickEvent("Disparo canionazo tanque jugador")
			game.removeVisual(self)
		}
		
		if(position.x() > game.width() - 1) {
			game.removeTickEvent("Disparo canionazo tanque jugador")
			game.removeVisual(self)
		}
		
		if(position.x() < 0) {
			game.removeTickEvent("Disparo canionazo tanque jugador")
			game.removeVisual(self)
		}
		
		/*game.onCollideDo(self, { objeto =>
			objeto.recibirDisparo() 
			game.removeTickEvent("Disparo canionazo tanque jugador")
			game.removeVisual(self)}
		)*/
	}
	
	method recibirDisparoEnemigo() {}
	
	method recibirDisparo() {}
}

class CanionazoComun {
	var property position 
	var property direccion 
	
	method image() = "canionazoEnemigo.png"
	
	method avanzar() {
		
		position = direccion.mover(position)
		
		if(position.y() > game.height() - 1) {
			game.removeTickEvent("Disparo canionazo tanque enemigo comun")
			game.removeVisual(self)
		}
		
		if(position.y() < 0) {
			game.removeTickEvent("Disparo canionazo tanque enemigo comun")
			game.removeVisual(self)
		}
		
		if(position.x() > game.width() - 1) {
			game.removeTickEvent("Disparo canionazo tanque enemigo comun")
			game.removeVisual(self)
		}
		
		if(position.x() < 0) {
			game.removeTickEvent("Disparo canionazo tanque enemigo comun")
			game.removeVisual(self)
		}
		
		/*game.onCollideDo(self, { objeto =>
			objeto.recibirDisparoEnemigo() 
			game.removeTickEvent("Disparo canionazo tanque enemigo comun")
			game.removeVisual(self)} ) */
	}
	
	method recibirDisparoEnemigo() {}	
	
	method recibirDisparo() {}
}

class CanionazoRapido {
	var property position 
	var property direccion 
	
	method image() = "canionazoEnemigo.png"
	
	method avanzar() {
		
		position = direccion.mover(position)
		
		if(position.y() > game.height() - 1) {
			game.removeTickEvent("Disparo canionazo tanque enemigo rapido")
			game.removeVisual(self)
		}
		
		if(position.y() < 0) {
			game.removeTickEvent("Disparo canionazo tanque enemigo rapido")
			game.removeVisual(self)
		}
		
		if(position.x() > game.width() - 1) {
			game.removeTickEvent("Disparo canionazo tanque enemigo rapido")
			game.removeVisual(self)
		}
		
		if(position.x() < 0) {
			game.removeTickEvent("Disparo canionazo tanque enemigo rapido")
			game.removeVisual(self)
		}
		
		/*game.onCollideDo(self, { objeto =>
			objeto.recibirDisparoEnemigo() 
			game.removeTickEvent("Disparo canionazo tanque enemigo rapido")
			game.removeVisual(self)} ) */
	}
	
	method recibirDisparoEnemigo() {}	
}

class CanionazoResistente {
	var property position 
	var property direccion 
	
	method image() = "canionazoEnemigo.png"
	
	method avanzar() {
		
		position = direccion.mover(position)
		
		if(position.y() > game.height() - 1) {
			game.removeTickEvent("Disparo canionazo tanque enemigo resistente")
			game.removeVisual(self)
		}
		
		if(position.y() < 0) {
			game.removeTickEvent("Disparo canionazo tanque enemigo resistente")
			game.removeVisual(self)
		}
		
		if(position.x() > game.width() - 1) {
			game.removeTickEvent("Disparo canionazo tanque enemigo resistente")
			game.removeVisual(self)
		}
		
		if(position.x() < 0) {
			game.removeTickEvent("Disparo canionazo tanque enemigo resistente")
			game.removeVisual(self)
		}
		
		/*game.onCollideDo(self, { objeto =>
			objeto.recibirDisparoEnemigo() 
			game.removeTickEvent("Disparo canionazo tanque enemigo resistente")
			game.removeVisual(self)} ) */
	}
	
	method recibirDisparoEnemigo() {}	
}

object baseMilitar {
	const property position = game.at(6,0)
	const property image = "proteger.png"
	
	method destruirse() { game.removeVisual(self) nivel.gameOver() }
	
	method recibirDisparo() {}
	
	method recibirDisparoEnemigo() {
		self.destruirse()
	}
}