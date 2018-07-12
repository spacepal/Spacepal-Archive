package main

import (
	"fakeserver/game/igame"
	"fmt"
)

func printPlayers(g igame.Game) {
	players := g.Players()
	fmt.Println("\n*** Players")
	for _, p := range players {
		fmt.Printf("player$%d\t%s\tScore: %f\tShips: %d\n",
			p.ID(),
			p.Name(),
			p.Score(),
			p.Ships(),
		)
	}
	fmt.Println()
}

func printPlanets(g igame.Game) {
	planets := g.Planets()
	fmt.Println("\n*** Planets")
	for _, p := range planets {
		fmt.Println(p)
	}
	fmt.Println()
}
