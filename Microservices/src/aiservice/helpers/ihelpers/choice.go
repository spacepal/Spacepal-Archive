package ihelpers

import "aiservice/model/imodel"

// ChoiceMaker is an interface for PlanetChoiceMaker
type ChoiceMaker interface {
	MakeChoice(planets []imodel.PlanetGetter, main imodel.PlanetGetter,
		factor imodel.FactorGetter) imodel.PlanetGetter
}
