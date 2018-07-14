package ai

import (
	"aiservice/ai/iai"
	"aiservice/ai/list/ilist"
	"aiservice/helpers"
	"aiservice/helpers/ihelpers"
	"aiservice/model/imodel"
)

// Base is a simple AI
type Base struct {
	redistribution ilist.FactorGetter
	attack         ilist.FactorGetter
}

// NewBase is a factory method for Base AI
func NewBase(
	redistribution ilist.FactorGetter,
	attack ilist.FactorGetter,
) iai.MoveMaker {
	if redistribution.Quantity() < 0 || attack.Quantity() < 0 {
		panic("Quantity is negative")
	}
	if redistribution.Quantity()+attack.Quantity() > 1 {
		panic("The sum of the quantities is grater than 1")
	}
	return &Base{
		redistribution: redistribution,
		attack:         attack,
	}
}

// MakeMove : end turn by AI
func (b Base) MakeMove(
	planets ihelpers.PlanetsGetter,
	globStat ihelpers.GlobStatGetter,
	mapSize imodel.MapSizeGetter,
) []imodel.TaskGetter {
	var chooser = helpers.NewPlanetChoiceMaker(globStat, mapSize)
	var tasks = make([]imodel.TaskGetter, 0)
	for _, main := range planets.Self() {
		if main.Ships() == 0 {
			continue
		}
		var planetToAttack, attackDist = chooser.MakeChoice(
			planets.Foreign(), main, b.attack)
		safeCreateTask(main, planetToAttack,
			b.attack.Quantity(), &tasks, attackDist)
		var planetToRedistribute, redisDist = chooser.MakeChoice(
			planets.Self(), main, b.redistribution)
		safeCreateTask(main, planetToRedistribute,
			b.redistribution.Quantity(), &tasks, redisDist)
	}
	return tasks
}
