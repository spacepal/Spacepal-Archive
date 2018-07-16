package ihelpers

import "aiservice/model/imodel"

// PlanetsGetter has methods for planets listing by some conditions
type PlanetsGetter interface {
	Self() []imodel.PlanetGetter
	Foreign() []imodel.PlanetGetter
	SelfGroups(int) map[int][]imodel.PlanetGetter
}
