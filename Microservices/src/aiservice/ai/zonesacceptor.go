package ai

import (
	"aiservice/ai/iai"
	"aiservice/ai/list/ilist"
	"aiservice/helpers"
	"aiservice/helpers/ihelpers"
	"aiservice/model/imodel"
)

// Acceptor : planets collect ships on the one main planet
// main planet attacks one foreign planet
type ZonesAcceptor struct {
	redistribution ilist.FactorGetter
	attack         ilist.FactorGetter
}

// NewZonesAcceptor is a factory method for Acceptor AI
func NewZonesAcceptor(
	redistribution ilist.FactorGetter,
	attack ilist.FactorGetter,
) iai.MoveMaker {
	if redistribution.Quantity() < 0 || attack.Quantity() < 0 {
		panic("Quantity is negative")
	}
	return &ZonesAcceptor{
		redistribution: redistribution,
		attack:         attack,
	}
}

// MakeMove : end turn by AI
func (b ZonesAcceptor) MakeMove(
	planets ihelpers.PlanetsGetter,
	globStat ihelpers.GlobStatGetter,
	mapSize imodel.MapSizeGetter,
) []imodel.TaskGetter {
	if len(planets.Self()) == 0 {
		return nil
	}
	var chooser = helpers.NewPlanetChoiceMaker(globStat, mapSize)
	groups := planets.SelfGroups(int(b.redistribution.Distance()))
	var tasks = make([]imodel.TaskGetter, 0)
	for _, group := range groups {
		var main, _ = chooser.MakeChoice(
			group, group[0], b.redistribution.WithoutDistance())
		var distanceSurface = helpers.NewDistanceSurface(
			main.Cell(), mapSize)
		for _, current := range group {
			if current.ID() == main.ID() {
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
	}
	return tasks
}
