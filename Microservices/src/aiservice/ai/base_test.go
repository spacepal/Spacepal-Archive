package ai

import (
	"aiservice/helpers"
	"aiservice/model"
	"aiservice/model/imodel"
	"testing"
)

type FakeFactor struct{}

func (f FakeFactor) Quantity() float64    { return +0.5 }
func (f FakeFactor) Random() float64      { return +3.0 }
func (f FakeFactor) Prod() float64        { return +1.0 }
func (f FakeFactor) Kill() float64        { return +1.0 }
func (f FakeFactor) Power() float64       { return +1.0 }
func (f FakeFactor) Ships() float64       { return +1.0 }
func (f FakeFactor) PlayerPower() float64 { return +1.0 }
func (f FakeFactor) Distance() float64    { return -2.0 }

var baseTestPlanets = []imodel.PlanetGetter{
	model.Planet{
		PlanetID:       1,
		Production:     100,
		KillPercentage: 1.0,
		OwnerID:        2,
		ShipsCount:     10,
		CellID:         1,
	}, model.Planet{
		PlanetID:       2,
		Production:     100,
		KillPercentage: 1.0,
		OwnerID:        2,
		ShipsCount:     10,
		CellID:         2,
	}, model.Planet{
		PlanetID:       3,
		Production:     100,
		KillPercentage: 1.0,
		OwnerID:        1,
		ShipsCount:     10,
		CellID:         3,
	}, model.Planet{
		PlanetID:       4,
		Production:     100,
		KillPercentage: 1.0,
		OwnerID:        1,
		ShipsCount:     10,
		CellID:         4,
	}, model.Planet{
		PlanetID:       5,
		Production:     100,
		KillPercentage: 1.0,
		OwnerID:        2,
		ShipsCount:     10,
		CellID:         5,
	},
}

var baseTestMapSize = model.MapSize{
	MapHeight: 100,
	MapWidth:  100,
}

func TestBase(t *testing.T) {
	base := NewBase(FakeFactor{}, FakeFactor{})
	if base == nil {
		t.Fatal("NewBase returns nil")
	}
	globstat := helpers.NewGlobStat(baseTestPlanets)
	planets := helpers.NewPlanets(baseTestPlanets, 2)

	var allPlanets = map[int]bool{}
	for _, p := range baseTestPlanets {
		allPlanets[p.ID()] = true
	}
	var selfPlanetShips = map[int]int{}
	for _, selfP := range planets.Self() {
		selfPlanetShips[selfP.ID()] = selfP.Ships()
	}

	tasks := base.MakeMove(planets, globstat, baseTestMapSize)
	if tasks == nil {
		t.Fatal("The Base AI doesn't make a turn")
	}
	if len(tasks) != len(planets.Self())*2 { // *2 - attach and redistribution
		t.Fatalf("Invalid count of returned tasks, get: %d, want: %d",
			len(tasks), len(planets.Self())*2)
	}
	for _, task := range tasks {
		from := task.From()
		if _, ok := selfPlanetShips[from]; !ok {
			t.Fatal("The player doesn't own planet [", task, "]")
		}
		selfPlanetShips[from] -= task.Count()
		if selfPlanetShips[from] < 0 {
			t.Fatal("Lack of ships [", task, "]")
		}
		if _, ok := allPlanets[task.To()]; !ok {
			t.Fatal("Invalid target planet [", task, "]")
		}
	}
}
