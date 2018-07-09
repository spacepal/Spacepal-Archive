package helpers

import (
	"aiservice/model/imodel"
	"math"
)

// GlobStat stores statistic information about game
type GlobStat struct {
	normalizedPowers map[int]float64 // by player
	midShips         int
}

// PlayerPower returns full power of given player
func (gs GlobStat) PlayerPower(player int) float64 {
	return gs.normalizedPowers[player]
}

// MidShips returns middle value of ships count
func (gs GlobStat) MidShips() int {
	return gs.midShips
}

// NewGlobStat creates store of game statistic
func NewGlobStat(planets []imodel.PlanetGetter) *GlobStat {
	var maxVal = float64(1)
	var powers = make(map[int]float64)
	var maxShips = 1
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
		powers[player] = power * 2 / maxVal // maxVal / 2 is a mean value
	}
	return &GlobStat{
		normalizedPowers: powers,
		midShips:         maxShips / 2,
	}
}
