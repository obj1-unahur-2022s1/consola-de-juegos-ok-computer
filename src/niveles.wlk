import wollok.game.*
import tanques.*
import direcciones.*
import juego.*

object nivel {
	const posLadrillos = []
	var posArbustos = []
	var posLadrilloGris = []
	const tanqueEnemigoComun = new TanqueEnemigoComun(position = game.at(6,12))
	const tanqueEnemigoRapido = new TanqueEnemigoRapido(position = game.at(0,12))
	const tanqueEnemigoResistente = new TanqueEnemigoResistente(position = game.at(12,12))
	const tanques = [tanqueEnemigoComun,tanqueEnemigoResistente]
	
	method iniciar() {
		
		game.clear()
		game.title("Battle City")
		game.height(13)
		game.width(13)
		game.ground("fondo.png")
		game.addVisual(pantPrincipal)
		game.schedule( 100, { => soundPantPrincipal.iniciar() } )
		keyboard.enter().onPressDo({self.cargarEscenario()})
		game.start()
	}
	method cargarEscenario() {
		
		game.removeVisual(pantPrincipal)
		self.dibujarEscenario()
		game.addVisual(aguila)
		game.addVisual(tanqueEnemigoComun)
		game.addVisual(tanqueEnemigoRapido)
		game.addVisual(tanqueEnemigoResistente)
		game.addVisual(tanqueJugador)
		keyboard.up().onPressDo({tanqueJugador.moverseArriba()})
		keyboard.right().onPressDo({tanqueJugador.moverseDerecha()})
		keyboard.left().onPressDo({tanqueJugador.moverseIzquierda()})
		keyboard.down().onPressDo({tanqueJugador.moverseAbajo()})
		keyboard.s().onPressDo({tanqueJugador.disparar()})
		keyboard.x().onPressDo{game.stop()}
		game.onTick(700, "Mover tanques enemigos", { self.moverTanquesEnemigos() })
		game.onTick(300, "Mover tanque enemigo rapido", { self.moverTanqueEnemigoRapido() })
		self.canionazoChocandoContra(tanqueEnemigoComun)
		self.canionazoChocandoContra(tanqueEnemigoRapido)
		self.canionazoChocandoContra(tanqueEnemigoResistente)
	}
		
	
	method dibujarEscenario() {
		
		(1..4).forEach({ col => self.dibujarLadrillos(col) })
		(8..11).forEach({ col => self.dibujarLadrillos(col) })
		posLadrillos.forEach({ p => self.cargar(new Ladrillo(position = p, puedeDestruirse = true)) })
		self.dibujarArbustos()
		self.dibujarLadrillosGris()
		
	}
	
	method dibujarLadrillos(col) {
		posLadrillos.addAll([new Position(x=1,y=col), new Position(x=3,y=col), new Position(x=5,y=col),
						new Position(x=7,y=col), new Position(x=9,y=col), new Position(x=11,y=col),
						new Position(x=5,y=0), new Position(x=7,y=0), new Position(x=6,y=1),
						new Position(x=2,y=6), new Position(x=3,y=6), new Position(x=4,y=6),
						new Position(x=8,y=6), new Position(x=9,y=6), new Position(x=10,y=6)])
	}

	method dibujarArbustos() {
		posArbustos = [new Position(x=6,y=2),new Position(x=6,y=3), new Position(x=6,y=4)].map({p => self.cargar(new Arbusto(position = p, puedeDestruirse = true)) })
	}
	
	method dibujarLadrillosGris() {
		posLadrilloGris = [new Position(x=1,y=6),new Position(x=6,y=6), new Position(x=11,y=6)].map({p => self.cargar(new LadrilloGris(position = p, puedeDestruirse = false)) })
	}
	
	method cargar(imagen) {
		game.addVisual(imagen)
		return imagen
	}
	
	/*method alChocar() {
		tanques.forEach({t =>
			game.whenCollideDo(t, {
				
			})
		})
	}*/
	
	method moverTanquesEnemigos() {
		tanques.forEach { t => t.moverse() }
	}
	
	method moverTanqueEnemigoRapido() {
		tanqueEnemigoRapido.moverse()
	}
	
	method canionazoChocandoContra(unTanqueEnemigo){
		game.onCollideDo(unTanqueEnemigo,{canionazo =>
			unTanqueEnemigo.destruirse()
			game.removeTickEvent("Disparo canionazo tanque jugador")
			game.removeVisual(canionazo)
		})
	}
	
	
	method ganaste(){
		if(not game.hasVisual(tanqueEnemigoComun) and 
		   not game.hasVisual(tanqueEnemigoRapido) and 
		   not game.hasVisual(tanqueEnemigoResistente) ) {
			game.clear()
			game.width(13)
			game.height(13)
			game.addVisual(pantGanador)
			soundGanaste.iniciar()
			keyboard.space().onPressDo{ self.iniciar() }
			keyboard.x().onPressDo{game.stop()}
		}
	}
	
	method gameOver(){
		game.clear()
		game.title("Battle City")
		game.width(13)
		game.height(13)
        game.addVisual(gameOver)
        soundGameOver.iniciar()
		keyboard.space().onPressDo{ self.iniciar() }
		keyboard.x().onPressDo{game.stop()}
	}
}
/// VISUALES ESCENARIO ///
class Ladrillo {
	const property position 
	const property image = "ladrillo.png"
	const property puedeDestruirse = true
	
	method destruirse() {
		game.removeVisual(self)
	}
	
	method recibirDisparo(tanqueEnemigo) {
		game.onCollideDo(tanqueEnemigo, {canionazo =>
			self.destruirse()
			game.removeTickEvent("Disparo canionazo tanque enemigo")
			game.removeVisual(canionazo)
		})
	}
}

class Arbusto {
	const property position 
	const property image = "arbusto.png"
	const property puedeDestruirse = true
	
	method destruirse() {
		game.removeVisual(self)
	}
	
	method puedeDestruirse() = true
}

class LadrilloGris {
	const property position 
	const property image = "ladrilloGris.png"
	const property puedeDestruirse = false
	
	method destruirse() {}
	
}

///
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
	}
}

/*class CanionazosEnemigos {
	var property position 
	var property direccion 
	
	method image() = "canionazoEnemigo.png"
	
	method avanzar() {
		
		position = direccion.mover(position)
		
		if(position.y() > game.height() - 1) {
			game.removeTickEvent("Disparo canionazo tanque enemigo")
			game.removeVisual(self)
		}
		
		if(position.y() < 0) {
			game.removeTickEvent("Disparo canionazo tanque enemigo")
			game.removeVisual(self)
		}
		
		if(position.x() > game.width() - 1) {
			game.removeTickEvent("Disparo canionazo tanque enemigo")
			game.removeVisual(self)
		}
		
		if(position.x() < 0) {
			game.removeTickEvent("Disparo canionazo tanque enemigo")
			game.removeVisual(self)
		}
	}
	
}*/

/// SONIDOS ///
object soundPantPrincipal {
	const sound = game.sound("sonidoPantPrincipal.mp3")
	
	method iniciar() {
		sound.play()
		sound.volume(0.1)
	}
}

object soundGanaste {
	const sound = game.sound("winning.mp3")
	
	method iniciar() {
		sound.play()
		sound.shouldLoop()
		sound.volume(0.1)
	}
}

object soundGameOver {
	const sound = game.sound("gameOver.mp3")
	
	method iniciar() {
		sound.play()
		sound.volume(0.1)
	}
}

object pantPrincipal {
	const property position = game.origin()
	const property image = "pantPrincipal.png"
}

object gameOver {
	const property position = game.origin()
	const property image = "gameOver.png"
}

object pantGanador {
	const property position = game.origin()
	const property image = "pantGanador.png"
}