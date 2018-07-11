package helpers

import (
	"aiservice/model"
	"aiservice/model/imodel"
	"testing"
)

func TestCalculateIndex(t *testing.T) {
	var c = PlanetChoiceMaker{}
	for i := 1; i < 100; i++ {
		val := c.calculateIndex(i, 2)
		if val < 0 {
			t.Error("Calculated index is negative!")
		} else if val >= i {
			t.Error("Calculated index is out of range!")
		}
	}
}

type FakeFactor struct {
}

func (f FakeFactor) Quantity() float64 {
	return 1.0
}
func (f FakeFactor) Random() float64 {
	return 3.0
}
func (f FakeFactor) Prod() float64 {
	return 1.0
}
func (f FakeFactor) Kill() float64 {
	return 1.0
}
func (f FakeFactor) Power() float64 {
	return 1.0
}
func (f FakeFactor) Ships() float64 {
	return 1.0
}
func (f FakeFactor) PlayerPower() float64 {
	return 1.0
}
func (f FakeFactor) Distance() float64 {
	return -1.0
}

func TestPlanetChoiceMaker(t *testing.T) {
	mapSize := model.MapSize{MapWidth: 4, MapHeight: 4}
	planets := make([]imodel.PlanetGetter, 0)
	for i := 1; i <= mapSize.LastCellID()/2.0; i++ {
		planets = append(planets, model.Planet{
			PlanetID:       i,
			Production:     100,
			KillPercentage: 1.0,
			OwnerID:        i,
			ShipsCount:     10,
			CellID:         i,
		})
	}
	globStat := NewGlobStat(planets)

	chooser := NewPlanetChoiceMaker(globStat, mapSize)
	if chooser == nil {
		t.Error("chooser == nil")
	}

	for i, p := range planets {
		planet, _ := chooser.MakeChoice(planets, p, FakeFactor{})
		if planet == nil {
			t.Log("The PlanetChoiceMaker doesn't make a choice")
			t.Error("planet[", i, "] == nil")
		}
	}

	empty, _ := chooser.MakeChoice([]imodel.PlanetGetter{}, planets[0], FakeFactor{})
	if empty != nil {
		t.Log("The planet from empty collection is not equal to nil")
		t.Error("empty != nil")
	}

	one, _ := chooser.MakeChoice(planets[:1], planets[1], FakeFactor{})
	if one != planets[0] {
		t.Log("The planet from collection with only one planet is not selected")
		t.Error("one != planets[0]")
	}

}
