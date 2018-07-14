package ai

import (
	"aiservice/ai/iai"
	"aiservice/ai/list/ilist"
	"aiservice/helpers"
	"aiservice/helpers/ihelpers"
	"aiservice/model/imodel"
)

// Acceptor is a simple AI
type Acceptor struct {
	redistribution ilist.FactorGetter
	attack         ilist.FactorGetter
}

// NewAcceptor is a factory method for Base AI
func NewAcceptor(
	redistribution ilist.FactorGetter,
	attack ilist.FactorGetter,
) iai.MoveMaker {
	if redistribution.Quantity() < 0 || attack.Quantity() < 0 {
		panic("Quantity is negative")
	}
	if redistribution.Quantity()+attack.Quantity() > 1 {
		panic("The sum of the quantities is grater than 1")
	}
	return &Acceptor{
		redistribution: redistribution,
		attack:         attack,
	}
}

// MakeMove : end turn by AI
func (b Acceptor) MakeMove(
	planets ihelpers.PlanetsGetter,
	globStat ihelpers.GlobStatGetter,
	mapSize imodel.MapSizeGetter,
) []imodel.TaskGetter {
	if len(planets.Self()) == 0 {
		return nil
	}
	var chooser = helpers.NewPlanetChoiceMaker(globStat, mapSize)
	var main, _ = chooser.MakeChoice(
		planets.Foreign(), planets.Self()[0], b.redistribution)
	var tasks = make([]imodel.TaskGetter, 0)
	for _, current := range planets.Self() {
		if current.ID() == main.ID() {
			continue
		}
		if current.Ships() == 0 {
			continue
		}
		var planetToAttack, attackDist = chooser.MakeChoice(
			planets.Foreign(), main, b.attack)
		safeCreateTask(current, planetToAttack,
			b.attack.Quantity(), &tasks, attackDist)
	}
	return tasks
}
