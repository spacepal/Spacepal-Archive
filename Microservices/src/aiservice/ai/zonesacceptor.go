package ai

import (
	"aiservice/ai/iai"
	"aiservice/ai/list/ilist"
	"aiservice/helpers"
	"aiservice/helpers/ihelpers"
	"aiservice/model/imodel"
	"math"
)

const noviceScore = 0.3

// ZonesAcceptor : planets collect ships on the one main planet
// main planet attacks one foreign planet
type ZonesAcceptor struct {
	redistribution ilist.FactorGetter
	attack         ilist.FactorGetter
	initialAttack  ilist.FactorGetter
}

// NewZonesAcceptor is a factory method for Acceptor AI
func NewZonesAcceptor(
	redistribution ilist.FactorGetter,
	attack ilist.FactorGetter,
	initialAttack ilist.FactorGetter,
) iai.MoveMaker {
	if redistribution.Quantity() < 0 ||
		attack.Quantity() < 0 ||
		initialAttack.Quantity() < 0 {
		panic("Quantity is negative")
	}
	return &ZonesAcceptor{
		redistribution: redistribution,
		attack:         attack,
		initialAttack:  initialAttack,
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
		var lastPlanet = main
		for i, current := range group {
			if current.ID() == main.ID() {
				continue
			}
			remotnessFactor := float64(i) / float64(len(group))
			quantity := math.Max(b.redistribution.Quantity()*remotnessFactor, 0.1)
			dist := distanceSurface.Calculate(current.Cell())
			safeCreateTask(current, lastPlanet, quantity, &tasks, dist)
			lastPlanet = current
		}
		var attackFactor = b.attack
		if globStat.RelatedScore(main.Owner()) < noviceScore {
			attackFactor = b.initialAttack
		}
		var planetToAttack, attackDist = chooser.MakeChoice(
			planets.Foreign(), main, attackFactor)
		safeCreateTask(main, planetToAttack,
			attackFactor.Quantity(), &tasks, attackDist)
	}
	return tasks
}
