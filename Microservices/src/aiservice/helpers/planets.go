package helpers

import "aiservice/model/imodel"

type Planets struct {
	selfPlanets    []imodel.PlanetGetter
	foreignPlanets []imodel.PlanetGetter
}
