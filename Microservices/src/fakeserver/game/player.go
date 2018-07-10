package game

import (
	"errors"
)

// Player is a model of game AI member
type player struct {
	PlayerID int    `json:"playerID"`
	AIName   string `json:"aiName"`
}

// genPlayers generates a list of random players
func (g *Game) genPlayers() error {
	names, err := getAINames()
	if err != nil {
		return err
	}
	if len(names) == 0 {
		return errors.New("AI not found")
	}
	g.players = make([]player, g.params.PlayersCount)
	for i := 0; i < g.params.PlayersCount; i++ {
		g.players[i] = player{
			PlayerID: i + 1,
			AIName:   "name",
		}
	}
	return nil
}
