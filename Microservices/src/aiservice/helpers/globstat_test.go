package helpers

import (
	"aiservice/model"
	"aiservice/model/imodel"
	"math"
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
	planets  []imodel.PlanetGetter
	cases    []statCase
	midShips int
}{
	planets: []imodel.PlanetGetter{
		model.Planet{Production: 100, KillPercentage: 1.0, OwnerID: 1, ShipsCount: 1},
		model.Planet{Production: 100, KillPercentage: 1.0, OwnerID: 1, ShipsCount: 2},
		model.Planet{Production: 100, KillPercentage: 1.0, OwnerID: 1, ShipsCount: 4},
		model.Planet{Production: 100, KillPercentage: 1.0, OwnerID: 1, ShipsCount: 8},
		model.Planet{Production: 100, KillPercentage: 0.5, OwnerID: 2, ShipsCount: 16},
	},
	cases: []statCase{
		{id: 1, player: 0, power: 0},
		{id: 2, player: -1, power: 0},
		{id: 3, player: 1000, power: 0},
		{id: 4, player: 1, power: 0.67},
		{id: 5, player: 2, power: 0.27},
	},
	midShips: 8,
}

func TestGlobStat(t *testing.T) {
	var gs = NewGlobStat(globStatCases.planets)
	if gs == nil {
		t.Fatal("NewGlobStat(globStatCases.planets) == nil")
	}
	if gs.MidShips() != globStatCases.midShips {
		t.Errorf("Invalid middle value of ships: want: %d, get: %d",
			globStatCases.midShips, gs.MidShips())
	}
	for _, c := range globStatCases.cases {
		get := gs.PlayerPower(c.player)
		want := c.power
		if math.Abs(get-want) > 0.1 {
			t.Errorf("Invalid power for case: %d; want: %f, get: %f", c.id, want, get)
		}
	}
}
