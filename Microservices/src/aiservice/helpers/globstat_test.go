package helpers

import (
	"aiservice/model"
	"testing"
)

type statCase struct {
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

var globStatCases = struct {
	planets  []model.Planet
	cases    []statCase
	midShips int
}{
	planets: []model.Planet{
		model.Planet{Prod: 100, Kill: 1.0, Owner: 1, Ships: 1},
		model.Planet{Prod: 100, Kill: 1.0, Owner: 1, Ships: 2},
		model.Planet{Prod: 100, Kill: 1.0, Owner: 1, Ships: 4},
		model.Planet{Prod: 100, Kill: 1.0, Owner: 1, Ships: 8},
		model.Planet{Prod: 100, Kill: 0.5, Owner: 2, Ships: 16},
	},
	cases: []statCase{
		{id: 1, player: 0, power: 0},
		{id: 2, player: -1, power: 0},
		{id: 3, player: 1000, power: 0},
		{id: 4, player: 1, power: 2.0},
		{id: 5, player: 2, power: 0.25},
	},
	midShips: 8,
}

func TestGlobalStatistic(t *testing.T) {
	var gs = NewGlobalStatistic(globStatCases.planets)
	if gs == nil {
		t.Fatal("NewGlobalStatistic(globStatCases.planets) == nil")
	}
	if gs.MidShips() != globStatCases.midShips {
		t.Errorf("Invalid middle value of ships: want: %d, get: %d",
			globStatCases.midShips, gs.MidShips())
	}
	for _, c := range globStatCases.cases {
		get := gs.PlayerPower(c.player)
		want := c.power
		if get != want {
			t.Errorf("Invalid power for case: %d; want: %f, get: %f", c.id, want, get)
		}
	}
}
