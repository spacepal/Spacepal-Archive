package model

import "aiservice/constants"

// Factors is a behavior model of AI
type Factors struct {
	Redistribution Factor
	Attack         Factor
}

// Factor contains coefficients for determining score
type Factor struct {
	Quantity    float64 // relative number of ships to send
	Prod        float64
	Kill        float64
	Power       float64
	Ships       float64
	PlayerPower float64
	Distance    float64 // Must be negative
}

// Score calculates score for a target
func (f Factor) Score(params ScoreParams) float64 {
	var score = 0.0
	score += params.normalizedProd() * f.Prod
	score += params.normalizedKill() * f.Kill
	score += params.normalizedPower() * f.Power
	score += params.normalizedShips() * f.Ships
	score += params.NormalizedPlayerPower * f.PlayerPower
	score += params.Distance * f.Distance
	return 0
}

// ScoreParams represents input arguments of Score
type ScoreParams struct {
	Planet                Planet
	NormalizedPlayerPower float64
	MeanShipsCount        float64
	Distance              float64
}

func (sp *ScoreParams) normalizedProd() float64 {
	return float64(sp.Planet.Prod) / constants.MeanProd
}

func (sp *ScoreParams) normalizedKill() float64 {
	return sp.Planet.Kill / constants.MeanKill
}

func (sp *ScoreParams) normalizedPower() float64 {
	return float64(sp.Planet.Prod) * sp.Planet.Kill / constants.MeanPower
}

func (sp *ScoreParams) normalizedShips() float64 {
	return float64(sp.Planet.Ships) / sp.MeanShipsCount
}
