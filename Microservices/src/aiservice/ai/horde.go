package ai

import (
	"aiservice/ai/iai"
	"aiservice/ai/list/ilist"
	"aiservice/helpers"
	"aiservice/helpers/ihelpers"
	"aiservice/model/imodel"
)

// Horde : planets attack one planet
// redistribution is used for getting main planet
// over which distance'll be calculated
type Horde struct {
	redistribution ilist.FactorGetter
	attack         ilist.FactorGetter
}

// NewHorde is a factory method for Horde AI
func NewHorde(
	redistribution ilist.FactorGetter,
	attack ilist.FactorGetter,
) iai.MoveMaker {
	if redistribution.Quantity() < 0 || attack.Quantity() < 0 {
		panic("Quantity is negative")
	}
	return &Horde{
		redistribution: redistribution,
		attack:         attack,
	}
}

// MakeMove : end turn by AI
func (b Horde) MakeMove(
	planets ihelpers.PlanetsGetter,
	globStat ihelpers.GlobStatGetter,
	mapSize imodel.MapSizeGetter,
) []imodel.TaskGetter {
	if len(planets.Self()) == 0 {
		return nil
	}
	var chooser = helpers.NewPlanetChoiceMaker(globStat, mapSize)
	var main, _ = chooser.MakeChoice(
		planets.Self(), planets.Self()[0], b.redistribution)
	var planetToAttack, _ = chooser.MakeChoice(
		planets.Foreign(), main, b.attack)
	var distanceSurface = helpers.NewDistanceSurface(
		planetToAttack.Cell(), mapSize)
	var tasks = make([]imodel.TaskGetter, 0)
	for _, current := range planets.Self() {
		if current.Ships() == 0 {
			continue
		}
		dist := distanceSurface.Calculate(current.Cell())
		safeCreateTask(current, planetToAttack,
			b.attack.Quantity(), &tasks, dist)
	}
	return tasks
}
