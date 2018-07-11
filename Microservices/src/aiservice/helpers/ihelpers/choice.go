package ihelpers

import (
	"aiservice/ai/list/ilist"
	"aiservice/model/imodel"
)

// ChoiceMaker is an interface for PlanetChoiceMaker
type ChoiceMaker interface {
	MakeChoice(planets []imodel.PlanetGetter, main imodel.PlanetGetter,
		factor ilist.FactorGetter) (planet imodel.PlanetGetter, distance int)
}
