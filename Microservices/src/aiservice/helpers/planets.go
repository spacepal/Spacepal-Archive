package helpers

import (
	"aiservice/model/imodel"
)

// Planets stores player & opponents planets
type Planets struct {
	selfPlanets    []imodel.PlanetGetter
	foreignPlanets []imodel.PlanetGetter
	mapSize        imodel.MapSizeGetter
}

// NewPlanets creates new planets store
func NewPlanets(
	planets []imodel.PlanetGetter,
	mapSize imodel.MapSizeGetter,
	player int,
) *Planets {
	var foreignPlanets = make([]imodel.PlanetGetter, 0)
	var selfPlanets = make([]imodel.PlanetGetter, 0)
	for _, p := range planets {
		if p.Owner() == player {
			selfPlanets = append(selfPlanets, p)
		} else {
			foreignPlanets = append(foreignPlanets, p)
		}
	}
	return &Planets{
		selfPlanets:    selfPlanets,
		foreignPlanets: foreignPlanets,
		mapSize:        mapSize,
	}
}

// SelfGroups returns planets seperated by zones
func (p Planets) SelfGroups(radius int) map[int][]imodel.PlanetGetter {
	usedPlanets := make(map[int]bool)
	zones := make(map[int][]imodel.PlanetGetter)
	for _, self := range p.selfPlanets {
		if _, ok := usedPlanets[self.ID()]; ok {
			continue
		}
		usedPlanets[self.ID()] = true
		distSurf := NewDistanceSurface(self.Cell(), p.mapSize)
		zoneID := self.ID()
		zones[zoneID] = make([]imodel.PlanetGetter, 1)
		zones[zoneID][0] = self
		for _, union := range p.selfPlanets {
			if _, ok := usedPlanets[union.ID()]; ok {
				continue
			}
			if dist := distSurf.Calculate(union.Cell()); dist > radius {
				continue
			}
			usedPlanets[union.ID()] = true
			zones[zoneID] = append(zones[zoneID], union)
		}
	}
	// log.Print("Zones: ", len(zones), " R: ", radius)
	return zones
}

// Self returns planets of current player
func (p Planets) Self() []imodel.PlanetGetter {
	return p.selfPlanets
}

// Foreign returns planets of opponents
func (p Planets) Foreign() []imodel.PlanetGetter {
	return p.foreignPlanets
}
