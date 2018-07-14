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
		planets.Self(), planets.Self()[0], b.redistribution)
	var distanceSurface = helpers.NewDistanceSurface(
		main.Cell(), mapSize)
	var tasks = make([]imodel.TaskGetter, 0)
	for _, current := range planets.Self() {
		// collect all ships on the main planet
		if current.ID() == main.ID() {
			continue
		}
		if current.Ships() == 0 {
			continue
		}
		dist := distanceSurface.Calculate(current.Cell())
		safeCreateTask(current, main,
			b.redistribution.Quantity(), &tasks, dist)
	}
	var planetToAttack, attackDist = chooser.MakeChoice(
		planets.Foreign(), main, b.attack)
	safeCreateTask(main, planetToAttack,
		b.attack.Quantity(), &tasks, attackDist)
	return tasks
}
