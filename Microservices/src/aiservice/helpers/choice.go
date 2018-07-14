package helpers

import (
	"aiservice/ai/list/ilist"
	"aiservice/constants"
	"aiservice/helpers/ihelpers"
	"aiservice/helpers/norm"
	"aiservice/model/imodel"
	"math"
	"math/rand"
	"sort"
)

type choiceMaker struct {
}

type planetScore struct {
	planet   imodel.PlanetGetter
	score    float64
	distance int
}

func newPlanetScore(
	target imodel.PlanetGetter,
	factor ilist.FactorGetter,
	distanceCalc ihelpers.DistanceCalculator,
	globStat ihelpers.GlobStatGetter,
) planetScore {

	// Calculates score
	var distance = distanceCalc.Calculate(target.Cell())
	var normalizedDistance = norm.Normalize(
		float64(distance), float64(constants.MidDistance))
	var normalizedShips = norm.Normalize(
		float64(target.Ships()), float64(globStat.MidShips()))
	var score = factor.Distance() * float64(normalizedDistance)
	score += factor.Kill() * target.NormalizedKill()
	if !target.IsNeutral() {
		score += factor.PlayerPower() * globStat.PlayerPower(target.Owner())
	}
	score += factor.Power() * target.NormalizedPower()
	score += factor.Prod() * target.NormalizedProd()
	score += factor.Ships() * normalizedShips
	return planetScore{
		planet:   target,
		score:    score,
		distance: distance,
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
	factor ilist.FactorGetter,
) (imodel.PlanetGetter, int) {

	if len(planets) == 0 {
		return nil, 0
	}
	distanceSurface := NewDistanceSurface(main.Cell(), cm.mapSize)
	planetScores := make([]planetScore, len(planets))
	for i, p := range planets {
		planetScores[i] = newPlanetScore(p, factor, distanceSurface, cm.globStat)
	}
	sort.Sort(sort.Reverse(byScore(planetScores)))

	var randomFactor = factor.Random()
	// for a weak player, the random factor is lower
	randomFactor *= cm.globStat.RelatedScore(main.Owner())

	var i = cm.calculateIndex(len(planetScores), randomFactor)
	return planetScores[i].planet, planetScores[i].distance
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
