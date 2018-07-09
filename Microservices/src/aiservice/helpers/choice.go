package helpers

import (
	"aiservice/helpers/ihelpers"
	"aiservice/model/imodel"
	"math"
	"math/rand"
	"sort"
)

type choiceMaker struct {
}

type planetScore struct {
	planet imodel.PlanetGetter
	score  float64
}

func newPlanetScore(
	target imodel.PlanetGetter,
	factor imodel.FactorGetter,
	distanceCalc ihelpers.DistanceCalculator,
	globStat ihelpers.GlobStatGetter,
) planetScore {

	// Calculates score
	var distance = float64(distanceCalc.Calculate(target.Cell()))
	var normalizedShips = float64(target.Ships()) / float64(globStat.MidShips())
	var score = factor.Distance() * distance
	score += factor.Kill() * target.NormalizedKill()
	if !target.IsNeutral() {
		score += factor.PlayerPower() * globStat.PlayerPower(target.Owner())
	}
	score += factor.Power() * target.NormalizedPower()
	score += factor.Prod() * target.NormalizedProd()
	score += factor.Ships() * normalizedShips
	return planetScore{
		planet: target,
		score:  score,
	}
}

type byScore []planetScore

func (planets byScore) Len() int {
	return len(planets)
}
func (planets byScore) Swap(i, j int) {
	planets[i], planets[j] = planets[j], planets[i]
}
func (planets byScore) Less(i, j int) bool {
	return planets[i].score < planets[j].score
}

// PlanetChoiceMaker determines the target planet сonsidering to factors
type PlanetChoiceMaker struct {
	globStat ihelpers.GlobStatGetter
	mapSize  imodel.MapSizeGetter
}

// NewPlanetChoiceMaker is a fabrication method of PlanetChoiceMaker
func NewPlanetChoiceMaker(
	globStat ihelpers.GlobStatGetter,
	mapSize imodel.MapSizeGetter,
) ihelpers.ChoiceMaker {
	return &PlanetChoiceMaker{
		globStat: globStat,
		mapSize:  mapSize,
	}
}

// MakeChoice choices one planet сonsidering to factors
func (cm PlanetChoiceMaker) MakeChoice(
	planets []imodel.PlanetGetter,
	main imodel.PlanetGetter,
	factor imodel.FactorGetter,
) imodel.PlanetGetter {

	if len(planets) == 0 {
		return nil
	}
	distanceSurface := NewDistanceSurface(main.Cell(), cm.mapSize)
	planetScores := make([]planetScore, len(planets))
	for i, p := range planets {
		planetScores[i] = newPlanetScore(p, factor, distanceSurface, cm.globStat)
	}
	sort.Sort(sort.Reverse(byScore(planetScores)))
	var i = cm.calculateIndex(len(planetScores), factor.Random())
	return planetScores[i].planet
}

// calculateIndex gets the count of planets and random factor (that is deviation)
// and returns the normally distributed index
func (cm PlanetChoiceMaker) calculateIndex(
	count int, randFactor float64) int {
	max := float64(count)
	if max != 0 {
		max--
	}
	var norm = math.Abs(rand.NormFloat64() * randFactor)
	return int(math.Min(math.Floor(norm), float64(max)))
}
