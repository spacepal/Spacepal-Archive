package helpers

import (
	"aiservice/helpers/ihelpers"
	"aiservice/helpers/norm"
	"aiservice/model/imodel"
	"math"
)

// GlobStat stores statistic information about game
type GlobStat struct {
	normalizedPowers    map[int]float64 // by player
	midShips            int
	meanNormalizedPower float64
}

// PlayerPower returns full power of given player
func (gs GlobStat) PlayerPower(player int) float64 {
	return gs.normalizedPowers[player]
}

// MidShips returns middle value of ships count
func (gs GlobStat) MidShips() int {
	return gs.midShips
}

// RelatedScore returns score that is divided by mean value
func (gs GlobStat) RelatedScore(player int) float64 {
	return gs.normalizedPowers[player] / gs.meanNormalizedPower
}

// NewGlobStat creates store of game statistic
func NewGlobStat(planets []imodel.PlanetGetter) ihelpers.GlobStatGetter {
	var maxVal = float64(1)
	var powers = make(map[int]float64)
	var maxShips = 1 // safe for dividing by zero
	var normalizedSum = 1.0
	for _, p := range planets {
		if power, ok := powers[p.Owner()]; ok {
			powers[p.Owner()] = power + p.NormalizedPower()
		} else {
			powers[p.Owner()] = p.NormalizedPower()
		}
		if maxShips < p.Ships() {
			maxShips = p.Ships()
		}
		maxVal = math.Max(powers[p.Owner()], maxVal)
	}
	for player, power := range powers { // normalize values
		powers[player] = norm.Normalize(power, maxVal/2.0)
		normalizedSum += powers[player]
	}
	return &GlobStat{
		normalizedPowers:    powers,
		midShips:            maxShips / 2,
		meanNormalizedPower: normalizedSum / float64(len(powers)),
	}
}
