package main

import (
	"fakeserver/game/igame"
	"fmt"
)

func printPlayers(g igame.Game) {
	players := g.Players()
	fmt.Println("\n", color("=== Players ===").Blue())
	fmt.Printf("% 10s   % 20s   % 8s   % 8s\n",
		"ID", "Name", "Score", "Ships")
	for _, p := range players {
		fmt.Printf("% 10s   % 20s   % 8f   % 8d\n",
			scolor("player$", p.ID()).Green(),
			p.Name(),
			p.Score(),
			p.Ships(),
		)
	}
}
