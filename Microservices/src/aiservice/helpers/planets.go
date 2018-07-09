package helpers

import "aiservice/model/imodel"

// Planets stores player & opponents planets
type Planets struct {
	selfPlanets    []imodel.PlanetGetter
	foreignPlanets []imodel.PlanetGetter
}

// NewPlanets creates new planets store
func NewPlanets(planets []imodel.PlanetGetter, player int) *Planets {
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
	}
}

// Self returns planets of current player
func (p Planets) Self() []imodel.PlanetGetter {
	return p.selfPlanets
}

// Foreign returns planets of opponents
func (p Planets) Foreign() []imodel.PlanetGetter {
	return p.foreignPlanets
}
