import wollok.game.*
import tanques.*

object nivel {
	const posLadrillos = []
	var posArbustos = []
	var posLadrilloGris = []
	const tanqueJugador = new TanqueJugador()
	const tanqueEnemigo = new TanqueEnemigo()
	const tanqueEnemigoRapido = new TanqueEnemigoRapido()
	const tanqueEnemigoResistente = new TanqueEnemigoResistente()
	
	method cargarEscenario() {
		
		game.clear()
		game.boardGround("fondo.png")
		game.title("Battle City")
		game.width(13)
		game.height(13)
		self.dibujarEscenario()
		game.addVisual(objetoAProteger)
		game.addVisual(tanqueJugador)
		game.addVisual(tanqueEnemigo)
		game.addVisual(tanqueEnemigoRapido)
		game.addVisual(tanqueEnemigoResistente)
		game.start()
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
	const property position
	const property image = "canionazo.png"
}

object objetoAProteger {
	const property position = new Position(x=6,y=0)
	const property image = "proteger.png"
}


class Direccion {
	method siguiente(position)
}

object izquierda inherits Direccion { 
	override method siguiente(position) = position.left(1) 
	method opuesto() = derecha
}

object derecha inherits Direccion { 
	override method siguiente(position) = position.right(1) 
	method opuesto() = izquierda
}

object abajo inherits Direccion { 
	override method siguiente(position) = position.down(1) 
	method opuesto() = arriba
}

object arriba inherits Direccion { 
	override method siguiente(position) = position.up(1) 
	method opuesto() = abajo
}

