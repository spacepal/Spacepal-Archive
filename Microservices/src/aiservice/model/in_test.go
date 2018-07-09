package model

import (
	"aiservice/ai/iai"
	"testing"
)

var inPlayers = []AIPlayer{
	{PlayerID: 1, AIName: "valid1"},
	{PlayerID: 2, AIName: "valid2"},
}

var validPlanets = []Planet{
	{CellID: 1, KillPercentage: 1.0, OwnerID: 1, PlanetID: 1, Production: 1, ShipsCount: 1},
	{CellID: 2, KillPercentage: 1.0, OwnerID: 2, PlanetID: 2, Production: 1, ShipsCount: 1},
}

var invalidPlanets = []Planet{
	{CellID: -1, KillPercentage: -1.0, OwnerID: -1, PlanetID: -1, Production: -1, ShipsCount: -1},
	{CellID: -2, KillPercentage: -1.0, OwnerID: -2, PlanetID: -2, Production: -1, ShipsCount: -1},
}

var validMapGridSize = MapSize{MapWidth: 5, MapHeight: 5}
var invalidMapGridSize = MapSize{MapWidth: -5, MapHeight: -5}

var validChecker = FakeManagerChecker{true}
var invalidChecker = FakeManagerChecker{false}

var testInCheckCases = []struct {
	description string
	in          In
	valid       bool
	checker     iai.ManagerChecker
}{
	{
		checker:     validChecker,
		description: "Empty model",
		in:          In{},
		valid:       false,
	},
	{
		checker:     validChecker,
		description: "Valid",
		in: In{
			ArtIntPlayers: inPlayers,
			MapGridSize:   validMapGridSize,
			AllPlanets:    validPlanets,
		},
		valid: true,
	},
	{
		checker:     validChecker,
		description: "Invalid map",
		in: In{
			ArtIntPlayers: inPlayers,
			MapGridSize:   invalidMapGridSize,
			AllPlanets:    validPlanets,
		},
		valid: false,
	},
	{
		checker:     validChecker,
		description: "Empty AIPlayers slice",
		in: In{
			ArtIntPlayers: []AIPlayer{},
			MapGridSize:   validMapGridSize,
			AllPlanets:    validPlanets,
		},
		valid: false,
	},
	{
		checker:     validChecker,
		description: "Empty Planets slice",
		in: In{
			ArtIntPlayers: inPlayers,
			MapGridSize:   validMapGridSize,
			AllPlanets:    []Planet{},
		},
		valid: false,
	},
	{
		checker:     invalidChecker,
		description: "Invalid players",
		in: In{
			ArtIntPlayers: inPlayers,
			MapGridSize:   validMapGridSize,
			AllPlanets:    validPlanets,
		},
		valid: false,
	},
	{
		checker:     validChecker,
		description: "Invalid players",
		in: In{
			ArtIntPlayers: inPlayers,
			MapGridSize:   validMapGridSize,
			AllPlanets:    invalidPlanets,
		},
		valid: false,
	},
}

func TestInCheck(t *testing.T) {
	for _, c := range testInCheckCases {
		err := c.in.Check(c.checker)
		get := (err == nil)
		want := c.valid
		if get != want {
			t.Log(err)
			t.Error("Invalid case [", c.description,
				"], want: ", want, ", get: ", get)
		}
	}
}
