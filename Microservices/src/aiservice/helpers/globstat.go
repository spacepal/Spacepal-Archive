package helpers

import (
	"aiservice/model"
	"math"
)

// GlobalStatistic stores statistic information about game
type GlobalStatistic struct {
	normalizedPowers map[int]float64 // by player
	midShips         int
}

// PlayerPower returns full power of given player
func (gs GlobalStatistic) PlayerPower(player int) float64 {
	return gs.normalizedPowers[player]
}

// MidShips returns middle value of ships count
func (gs GlobalStatistic) MidShips() int {
	return gs.midShips
}

// NewGlobalStatistic creates store of game statistic
func NewGlobalStatistic(planets []model.Planet) *GlobalStatistic {
	var maxVal = float64(1)
	var powers = make(map[int]float64)
	var maxShips = 1
	for _, p := range planets {
		if power, ok := powers[p.Owner]; ok {
			powers[p.Owner] = power + p.NormalizedPower()
		} else {
			powers[p.Owner] = p.NormalizedPower()
		}
		if maxShips < p.Ships {
			maxShips = p.Ships
		}
		maxVal = math.Max(powers[p.Owner], maxVal)
	}
	for player, power := range powers { // normalize values
		powers[player] = power * 2 / maxVal // maxVal / 2 is a mean value
	}
	return &GlobalStatistic{
		normalizedPowers: powers,
		midShips:         maxShips / 2,
	}
}
