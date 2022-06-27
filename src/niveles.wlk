import wollok.game.*
import tanques.*
import direcciones.*

object nivel {
	const posLadrillos = []
	var posArbustos = []
	var posLadrilloGris = []
	const tanqueEnemigoComun = new TanqueEnemigoComun(position = game.at(6,12))
	const tanqueEnemigoRapido = new TanqueEnemigoRapido(position = game.at(0,12))
	const tanqueEnemigoResistente = new TanqueEnemigoResistente(position = game.at(12,12))
	const tanques = [tanqueEnemigoComun,tanqueEnemigoResistente]
	
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
		game.onTick(1000, "Mover tanques enemigos", { self.moverTanquesEnemigos() })
		game.onTick(500, "Mover tanque enemigo rapido", { self.moverTanqueEnemigoRapido() })
		
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
	
	method ganaste(){
		game.clear()
		game.width(13)
		game.height(13)
		game.addVisual(pantGanador)
		keyboard.space().onPressDo{self.cargarEscenario()}
		keyboard.x().onPressDo{game.stop()}
	}
	
	method gameOver(){
		game.clear()
		game.title("Battle City")
		game.width(13)
		game.height(13)
        game.addVisual(gameOver)
		keyboard.space().onPressDo{self.cargarEscenario()}
		keyboard.x().onPressDo{game.stop()}
		
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

object canionazoJugador {
	var property position = tanqueJugador.position()
	const property direccion = tanqueJugador.direccion()
	
	method image() = "canionazo.png"
	
	method avanzar() {
		position = direccion.mover(position)
	}
}

object pantPrincipal {
	const property position = game.origin()
	const property image = "pantPrincipal2.png"
}

object gameOver {
	const property position = game.origin()
	const property image = "gameOver.png"
}

object pantGanador {
	const property position = game.origin()
	const property image = "pantGanador.png"
}