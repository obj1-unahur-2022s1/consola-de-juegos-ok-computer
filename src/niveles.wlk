import wollok.game.*

object nivel {
	const posLadrillos = []
	
	method cargarEscenario() {
		
		(1..4).forEach({ col => self.dibujarLadrillosEnColumnas(col)})
		(7..11).forEach({ col => self.dibujarLadrillosEnColumnas(col)})
		self.dibujarMasLadrillos()
		posLadrillos.forEach({ p => self.cargar(new Ladrillo(position = p))})
	}
	
	method dibujarLadrillosEnColumnas(col) {
		posLadrillos.addAll([new Position(x=1,y=col),new Position(x=3,y=col), new Position(x=5,y=col),
							 new Position(x=7,y=col), new Position(x=9,y=col), new Position(x=11,y=col)])
	}
	
	method dibujarMasLadrillos() {
		posLadrillos.addAll([new Position(x=5,y=0),new Position(x=7,y=0), new Position(x=6,y=1)])
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
