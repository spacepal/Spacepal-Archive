package game

import (
	"encoding/json"
	"net/http"
)

const aiNamesURL = "http://localhost:3131/ai/names"

// Player is a model of game AI member
type Player struct {
	PlayerID int    `json:"playerID"`
	AIName   string `json:"aiName"`
}

// GenPlayers returns a list of random players
func GenPlayers(count int) ([]Player, error) {
	if count <= 0 {
		return nil, nil
	}
	names, err := getAINames()
	if err != nil {
		return nil, err
	}
	if len(names) == 0 {
		return nil, nil
	}
	players := make([]Player, count)
	for i := 0; i < count; i++ {
		players[i] = Player{
			PlayerID: i + 1,
			AIName:   "name",
		}
	}
	return players, nil
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
