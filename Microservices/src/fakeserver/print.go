package main

import (
	"fakeserver/game/igame"
	"fmt"
)

func printPlayers(g igame.Game) {
	players := g.Players()
	fmt.Println("\n\n*** Players")
	for _, p := range players {
		fmt.Printf("%s%d\t%s\tScore: %f\tShips: %d\n",
			"player$",
			p.ID(),
			p.Name(),
			p.Score(),
			p.Ships(),
		)
	}
	fmt.Println()
}
