package model

import "testing"

var planetCheckMapSize = MapSize{MapWidth: 4, MapHeight: 4}
var planetCheckCases = []struct {
	description string
	planet      Planet
	isValid     bool
}{
	{
		description: "empty struct",
		planet:      Planet{},
		isValid:     false,
	},
	{
		description: "valid data",
		planet: Planet{
			PlanetID:       1,
			OwnerID:        1,
			CellID:         1,
			Production:     1,
			KillPercentage: 1,
			ShipsCount:     1,
		},
		isValid: true,
	},
	{
		description: "cellID < 1",
		planet: Planet{
			PlanetID:       1,
			OwnerID:        1,
			CellID:         0,
			Production:     1,
			KillPercentage: 1,
			ShipsCount:     1,
		},
		isValid: false,
	},
	{
		description: "cellID > mapWidth * mapHeight",
		planet: Planet{
			PlanetID:       1,
			OwnerID:        1,
			CellID:         planetCheckMapSize.LastCellID() + 1,
			Production:     1,
			KillPercentage: 1,
			ShipsCount:     1,
		},
		isValid: false,
	},
	{
		description: "negative production",
		planet: Planet{
			PlanetID:       1,
			OwnerID:        1,
			CellID:         1,
			Production:     -1,
			KillPercentage: 1,
			ShipsCount:     1,
		},
		isValid: false,
	},
	{
		description: "negative shipsCount",
		planet: Planet{
			PlanetID:       1,
			OwnerID:        1,
			CellID:         1,
			Production:     1,
			KillPercentage: 1,
			ShipsCount:     -1,
		},
		isValid: false,
	},
	{
		description: "negative kill percentage",
		planet: Planet{
			PlanetID:       1,
			OwnerID:        1,
			CellID:         1,
			Production:     1,
			KillPercentage: -1,
			ShipsCount:     1,
		},
		isValid: false,
	},
	{
		description: "kill percentage > 1",
		planet: Planet{
			PlanetID:       1,
			OwnerID:        1,
			CellID:         1,
			Production:     1,
			KillPercentage: 1.1,
			ShipsCount:     1,
		},
		isValid: false,
	},
}

func TestPlanetCheck(t *testing.T) {
	for _, c := range planetCheckCases {
		err := c.planet.check(planetCheckMapSize)
		get := (err == nil)
		want := c.isValid
		if get != want {
			t.Log(c.description)
			t.Log("Err: ", err)
			t.Errorf("Invalid case, want: %t, get: %t", want, get)
		}
	}
}
