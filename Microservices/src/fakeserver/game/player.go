package game

import (
	"encoding/json"
	"errors"
	"net/http"
)

const aiNamesURL = "http://localhost:3131/ai/names"

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

type aiNames struct {
	All   []string `json:"all"`
	Count int      `json:"count"`
}

func getAINames() ([]string, error) {
	r, err := http.Get(aiNamesURL)
	if err != nil {
		return nil, err
	}
	defer r.Body.Close()
	names := aiNames{}
	err = json.NewDecoder(r.Body).Decode(&names)
	if err != nil {
		return nil, err
	}
	return names.All, nil
}
