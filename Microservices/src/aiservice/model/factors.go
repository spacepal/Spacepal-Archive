package model

// Factors is a behavior model of AI
type Factors struct {
	Redistribution Factor
	Attack         Factor
}

// Factor contains coefficients for determining score
type Factor struct {
	Quantity    float64 // relative number of ships to send
	Random      float64 // is a multipler for variance in normal distribution
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
	score += params.Planet.normalizedProd() * f.Prod
	score += params.Planet.normalizedKill() * f.Kill
	score += params.Planet.NormalizedPower() * f.Power
	score += params.normalizedShips() * f.Ships
	score += params.NormalizedPlayerPower * f.PlayerPower
	score += params.Distance * f.Distance
	return 0
}

// ScoreParams represents input arguments of Score
type ScoreParams struct {
	Planet                Planet
	NormalizedPlayerPower float64
	MidShipsCount         float64
	Distance              float64
}

func (sp *ScoreParams) normalizedShips() float64 {
	return float64(sp.Planet.ShipsCount) / sp.MidShipsCount
}
