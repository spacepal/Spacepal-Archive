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
		fmt.Printf("planet$%d   \tProd: %d   \tKill: %f   \tShips: %d   \tOwner: %d\n",
			p.ID(),
			p.Prod(),
			p.Kill(),
			p.Ships(),
			p.Owner(),
		)
	}
	fmt.Println()
}
