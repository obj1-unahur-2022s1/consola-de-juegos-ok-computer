import wollok.game.*
import tanques.*
import direcciones.*

object nivel {
	const posLadrillos = []
	var posArbustos = []
	var posLadrilloGris = []
	const tanqueEnemigoComun = new TanquesEnemigos(position = game.at(6,12), image = "abajoEnemigo1.png")
	const tanqueEnemigoRapido = new TanquesEnemigos(position = game.at(0,12), image = "abajoEnemigo2.png")
	const tanqueEnemigoResistente = new TanqueEnemigoResistente(position = game.at(12,12), image = "abajoEnemigo3.png")
	const tanques = [tanqueEnemigoComun,tanqueEnemigoResistente]
	
	method cargarEscenario() {
		
		game.removeVisual(pantPrincipal)
		self.dibujarEscenario()
		game.addVisual(aguila)
		game.addVisual(tanqueEnemigoComun)
		game.addVisual(tanqueEnemigoRapido)
		game.addVisual(tanqueEnemigoResistente)
		game.addVisual(tanqueJugador)
		keyboard.up().onPressDo({tanqueJugador.moverse(arriba)})
		keyboard.right().onPressDo({tanqueJugador.moverse(derecha)})
		keyboard.left().onPressDo({tanqueJugador.moverse(izquierda)})
		keyboard.down().onPressDo({tanqueJugador.moverse(abajo)})
		keyboard.s().onPressDo({tanqueJugador.disparar()})
		game.onTick(1000, "Mover tanques enemigos", { self.moverTanquesEnemigos() })
		game.onTick(300, "Mover tanque enemigo rapido", { self.moverTanqueEnemigoRapido() })
		
	}
	
	method dibujarEscenario() {
		
		(1..4).forEach({ col => self.dibujarLadrillos(col) })
		(8..11).forEach({ col => self.dibujarLadrillos(col) })
		posLadrillos.forEach({ p => self.cargar(new Ladrillo(position = p)) })
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
		posArbustos = [new Position(x=6,y=2),new Position(x=6,y=3), new Position(x=6,y=4)].map({p => self.cargar(new Arbusto(position = p)) })
	}
	
	method dibujarLadrillosGris() {
		posLadrilloGris = [new Position(x=1,y=6),new Position(x=6,y=6), new Position(x=11,y=6)].map({p => self.cargar(new LadrilloGris(position = p)) })
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
		tanques.forEach { t => t.mover() }
	}
	
	method moverTanqueEnemigoRapido() {
		tanqueEnemigoRapido.mover()
	}
}

class Ladrillo {
	const property position 
	const property image = "ladrillo.png"
	
}

class Arbusto {
	const property position 
	const property image = "arbusto.png"
}

class Agua {
	const property position 
	const property image = "agua.png"
}

class LadrilloGris {
	const property position 
	const property image = "ladrilloGris.png"
	
}

class Canionazo {
	var position = tanqueJugador.position()
	const direccion = tanqueJugador.direccion()
	const property image = "canionazo.png"
	
	method avanzar() {
		position = direccion.mover(position)
	}
	
	method position() = position
}

object pantPrincipal {
	const property position = game.at(1,2)
	const property image = "pantPrincipal.png"
}