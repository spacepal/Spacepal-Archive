package iai

import (
	"aiservice/helpers/ihelpers"
	"aiservice/model/imodel"
)

// MoveMaker is an interface for artificial intelligence end turn
type MoveMaker interface {
	MakeMove(
		planets ihelpers.PlanetsGetter,
		globStat ihelpers.GlobStatGetter,
		mapSize imodel.MapSizeGetter,
	) []imodel.TaskGetter
}
