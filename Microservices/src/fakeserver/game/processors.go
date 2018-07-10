package game

import "log"

// processShips processes tasks
func (g *Game) processShips() {
	for id, t := range g.tasks {
		log.Print("@todo processShips ", id, t)
	}
}

// processPlanets processes planets
func (g *Game) processPlanets() {
	for id, p := range g.planets {
		log.Print("@todo processPlanets ", id, p)
	}
}
