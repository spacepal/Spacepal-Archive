package ihelpers

import "aiservice/model/imodel"

type PlanetsGetter interface {
	Self() []imodel.PlanetGetter
	Foreign() []imodel.PlanetGetter
}
