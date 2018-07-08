package helpers

import (
	"aiservice/model"
	"math"
)

// PlayersPower stores powers of all player planets
type PlayersPower struct {
	normalizedPowers map[int]float64 // by player
}

// NormalizedPowerOf returns full power of given player
func (pp PlayersPower) NormalizedPowerOf(player int) float64 {
	return pp.normalizedPowers[player]
}

// NewPlayersPower creates store of player powers
func NewPlayersPower(planets []model.Planet) *PlayersPower {
	var maxVal = float64(0)
	var powers = make(map[int]float64)
	for _, p := range planets {
		if power, ok := powers[p.Owner]; ok {
			powers[p.Owner] = power + p.NormalizedPower()
		} else {
			powers[p.Owner] = p.NormalizedPower()
		}
		maxVal = math.Max(powers[p.Owner], maxVal)
	}
	for player, power := range powers { // normalize values
		powers[player] = power * 2 / maxVal // maxVal / 2 is a mean value
	}
	return &PlayersPower{powers}
}
