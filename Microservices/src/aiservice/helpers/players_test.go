package helpers

import (
	"aiservice/model"
	"testing"
)

type playersPowerCase struct {
	id     int
	player int
	power  float64
}

type Planet struct {
	ID    int     `json:"id"`
	Owner int     `json:"ownerID"`
	Cell  int     `json:"cellID"`
	Prod  int     `json:"production"`
	Kill  float64 `json:"killPerc"`
	Ships float64 `json:"ships"`
}

var playersPowerCases = struct {
	planets []model.Planet
	cases   []playersPowerCase
}{
	planets: []model.Planet{
		model.Planet{Prod: 100, Kill: 1.0, Owner: 1},
		model.Planet{Prod: 100, Kill: 1.0, Owner: 1},
		model.Planet{Prod: 100, Kill: 1.0, Owner: 1},
		model.Planet{Prod: 100, Kill: 1.0, Owner: 1},
		model.Planet{Prod: 100, Kill: 0.5, Owner: 2},
	},
	cases: []playersPowerCase{
		{id: 1, player: 0, power: 0},
		{id: 2, player: -1, power: 0},
		{id: 3, player: 1000, power: 0},
		{id: 4, player: 1, power: 2.0},
		{id: 5, player: 2, power: 0.25},
	},
}

func TestPlayersPower(t *testing.T) {
	var pp = NewPlayersPower(playersPowerCases.planets)
	for _, c := range playersPowerCases.cases {
		get := pp.NormalizedPowerOf(c.player)
		want := c.power
		if get != want {
			t.Errorf("Invalid power for case: %d; want: %f, get: %f", c.id, want, get)
		}
	}
}
