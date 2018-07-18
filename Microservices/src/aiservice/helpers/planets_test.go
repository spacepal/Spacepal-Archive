package helpers

import (
	"aiservice/constants"
	"aiservice/model"
	"aiservice/model/imodel"
	"testing"
)

func TestPlanets(t *testing.T) {
	var ownerID = 1
	var planets = []imodel.PlanetGetter{
		model.Planet{OwnerID: 3},
		model.Planet{OwnerID: 1},
		model.Planet{OwnerID: 1},
		model.Planet{OwnerID: 2},
		model.Planet{OwnerID: constants.NeutralOwnerID},
	}
	var mapSize = model.MapSize{
		MapHeight: 10,
		MapWidth:  10,
	}
	selfPlanetsCount := 2
	foreignPlanetsCount := 3

	planetsHelper := NewPlanets(planets, mapSize, ownerID)
	if planetsHelper == nil {
		t.Fatal("planetsHelper == nil")
	}

	if len(planetsHelper.Foreign()) != foreignPlanetsCount {
		t.Errorf("Invalid foreign planets count. Want: %d, get: %d",
			foreignPlanetsCount, len(planetsHelper.Foreign()))
	}
	if len(planetsHelper.Self()) != selfPlanetsCount {
		t.Errorf("Invalid self planets count. Want: %d, get: %d",
			selfPlanetsCount, len(planetsHelper.Self()))
	}
	for _, p := range planetsHelper.Self() {
		if p.Owner() != ownerID {
			t.Errorf("Self planet do not belongs to player! PlanetID, want: %d, get: %d",
				ownerID, p.Owner())
		}
	}
	for _, p := range planetsHelper.Foreign() {
		if p.Owner() == ownerID {
			t.Errorf("Foreign planet belongs to current player! PlanetID, get: %d",
				p.Owner())
		}
	}

	planetsHelper = NewPlanets([]imodel.PlanetGetter{}, mapSize, ownerID)
	if len(planetsHelper.Foreign()) != 0 {
		t.Log("Foreign planet, for empty collection, exists")
		t.Errorf("len(planetsHelper.Foreign()) != 0")
	}
	if len(planetsHelper.Self()) != 0 {
		t.Log("Self planet, for empty collection, exists")
		t.Errorf("len(planetsHelper.Self()) != 0")
	}
}
