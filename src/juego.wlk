import wollok.game.*
import consola.*
import niveles.*

class Juego {
	var property position = null
	var property color 
	
	method iniciar(){
        game.addVisual(object{method position()= game.center() method text() = "Juego "+color + " - <q> para salir"})		
	}
	
	method terminar(){

	}
	method image() = "juego" + color + ".png"
	

}

object battleCity {
	var property position
	
	method iniciar(){
       game.schedule(1000,{ nivel.iniciar() })	
	}
	method terminar(){
		
	}
	method image() = "proteger.png"
}