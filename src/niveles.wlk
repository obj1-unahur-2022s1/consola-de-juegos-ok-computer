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
		game.addVisual(baseMilitar)
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
		keyboard.any().onPressDo{self.ganaste()}
		game.onTick(700, "Mover tanques enemigos", { self.moverTanquesEnemigos() })
		game.onTick(300, "Mover tanque enemigo rapido", { self.moverTanqueEnemigoRapido() })
		game.onTick(4000, "disparo Enemigo Comun", { tanqueEnemigoComun.disparar() })
		game.onTick(2000, "disparo Enemigo Comun", { tanqueEnemigoRapido.disparar() })
		game.onTick(6000, "disparo Enemigo Comun", { tanqueEnemigoResistente.disparar() })
		/*self.canionazoChocandoContra(tanqueEnemigoComun)
		self.canionazoChocandoContra(tanqueEnemigoRapido)
		self.canionazoChocandoContra(tanqueEnemigoResistente)*/
	}
		
	
	method dibujarEscenario() {
		
		self.dibujarLadrillos()
		self.dibujarArbustos()
		self.dibujarLadrillosGris()
		
	}
	
	/// cargamos uno por uno porque sino nos lanzaba error cuando un disparo los chocaba ///
	method dibujarLadrillos() {
		posLadrillos.addAll([new Position(x=1,y=1), new Position(x=3,y=1), new Position(x=5,y=1),
						new Position(x=7,y=1), new Position(x=9,y=1), new Position(x=11,y=1),
						new Position(x=1,y=2), new Position(x=3,y=2), new Position(x=5,y=2),
						new Position(x=7,y=2), new Position(x=9,y=2), new Position(x=11,y=2),
						new Position(x=1,y=3), new Position(x=3,y=3), new Position(x=5,y=3),
						new Position(x=7,y=3), new Position(x=9,y=3), new Position(x=11,y=3),
						new Position(x=1,y=4), new Position(x=3,y=4), new Position(x=5,y=4),
						new Position(x=7,y=4), new Position(x=9,y=4), new Position(x=11,y=4),
						new Position(x=1,y=8), new Position(x=3,y=8), new Position(x=5,y=8),
						new Position(x=7,y=8), new Position(x=9,y=8), new Position(x=11,y=8),
						new Position(x=1,y=9), new Position(x=3,y=9), new Position(x=5,y=9),
						new Position(x=7,y=9), new Position(x=9,y=9), new Position(x=11,y=9),
						new Position(x=1,y=10), new Position(x=3,y=10), new Position(x=5,y=10),
						new Position(x=7,y=10), new Position(x=9,y=10), new Position(x=11,y=10),
						new Position(x=1,y=11), new Position(x=3,y=11), new Position(x=5,y=11),
						new Position(x=7,y=11), new Position(x=9,y=11), new Position(x=11,y=11),
						new Position(x=5,y=0), new Position(x=7,y=0), new Position(x=6,y=1),
						new Position(x=2,y=6), new Position(x=3,y=6), new Position(x=4,y=6),
						new Position(x=8,y=6), new Position(x=9,y=6), new Position(x=10,y=6)]
						.map({p => self.cargar(new Ladrillo(position = p)) }))
	}

	method dibujarArbustos() {
		posArbustos = [new Position(x=6,y=2),new Position(x=6,y=3), new Position(x=6,y=4)].map({p => self.cargar(new Arbusto(position = p)) })
	}
	
	method dibujarLadrillosGris() {
		posLadrilloGris = [new Position(x=1,y=6),new Position(x=5,y=6), new Position(x=7,y=6), new Position(x=11,y=6)].map({p => self.cargar(new LadrilloGris(position = p)) })
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
	
	/*method canionazoChocandoContra(unTanqueEnemigo){
		game.onCollideDo(unTanqueEnemigo,{canionazo =>
			unTanqueEnemigo.destruirse()
			game.removeTickEvent("Disparo canionazo tanque jugador")
			game.removeVisual(canionazo)
		})
	}*/
	
	
	method ganaste(){
		if(not game.hasVisual(tanqueEnemigoComun) and 
		   not game.hasVisual(tanqueEnemigoRapido) and 
		   not game.hasVisual(tanqueEnemigoResistente) ) {
			game.clear()
			game.width(13)
			game.height(13)
			soundGanaste.iniciar()
			keyboard.space().onPressDo{ self.iniciar() }
			keyboard.x().onPressDo{game.stop()}
			game.addVisual(pantGanador)
		}
	}
	
	method gameOver(){
		game.clear()
		game.title("Battle City")
		game.width(13)
		game.height(13)
        soundGameOver.iniciar()
		keyboard.space().onPressDo{ self.iniciar() }
		keyboard.x().onPressDo{game.stop()}
		game.addVisual(gameOver)
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
	
	method recibirDisparo() {}
	
	method recibirDisparoEnemigo() {
		self.destruirse()
	}
}

class Arbusto {
	const property position 
	const property image = "arbusto.png"
	const property puedeDestruirse = true
	
	method destruirse() {
		game.removeVisual(self)
	}
	
	method recibirDisparo() {}
	
	method recibirDisparoEnemigo() {
		self.destruirse()
	}
}

class LadrilloGris {
	const property position 
	const property image = "ladrilloGris.png"
	const property puedeDestruirse = false
	
	method destruirse() {}
	
	method recibirDisparo() {}
	
	method recibirDisparoEnemigo() {
		self.destruirse()
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
