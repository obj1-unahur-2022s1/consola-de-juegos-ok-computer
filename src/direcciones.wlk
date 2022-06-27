object arriba {
	method mover(position) {return position.up(1)}
	method opuesto() = abajo
}

object abajo {
	method mover(position) {return position.down(1)}
	method opuesto() = arriba
}

object izquierda {
	method mover(position) {return position.left(1)}
	method opuesto() = derecha
}

object derecha {
	method mover(position) {return position.right(1)}
	method opuesto() = izquierda
}


