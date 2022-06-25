import wollok.game.*
import tanques.*

object pantallaPrincipal {
	var image = "pantallaPrincipal.png"
	var position = game.center()
	
	method cargar() {
		game.addVisual("pantallaPrincipal.png")
		keyboard.enter().onPressDo({
			game.removeVisual("pantallaPrincipal.png")
			nivel.cargarEscenario() })
	}
}

object nivel {
	const posLadrillos = []
	const posArbustos = []
	const posAgua = []
	
	method cargarEscenario() {
		
		(1..4).forEach({ col => self.dibujarLadrillosEnColumnas(col) })
		(8..11).forEach({ col => self.dibujarLadrillosEnColumnas(col) })
		self.dibujarMasLadrillos()
		self.dibujarArbustos()
		self.cargar(objetoAProteger)
		self.cargar(new TanqueJugador())
		self.cargar(new TanqueEnemigo())
		self.cargar(new TanqueEnemigoRapido())
		self.cargar(new TanqueEnemigoResistente())
		posArbustos.forEach({ p => self.cargar(new Arbusto(position = p)) })
		posLadrillos.forEach({ p => self.cargar(new Ladrillo(position = p)) })
		
		
		
	}
	
	method dibujarLadrillosEnColumnas(col) {
		posLadrillos.addAll([new Position(x=1,y=col), new Position(x=3,y=col), new Position(x=5,y=col),
							 new Position(x=7,y=col), new Position(x=9,y=col), new Position(x=11,y=col)])
	}
	
	method dibujarMasLadrillos() {
		posLadrillos.addAll([new Position(x=5,y=0), new Position(x=7,y=0), new Position(x=6,y=1),
							 new Position(x=2,y=6), new Position(x=3,y=6), new Position(x=4,y=6),
							 new Position(x=8,y=6), new Position(x=9,y=6), new Position(x=10,y=6)])
	}
	
	method dibujarArbustos() {
		posArbustos.addAll([new Position(x=6,y=2),new Position(x=6,y=3), new Position(x=6,y=4)])
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


object objetoAProteger {
	const property position = new Position(x=6,y=0)
	const property image = "proteger.png"
}

object mainMenu {

	method iniciar() {
		game.addVisual("pantallaPrincipal.png")
		self.controles()
	}

	method controles() {
		keyboard.enter().onPressDo({ 
			nivel.cargarEscenario()
		})
	}
}