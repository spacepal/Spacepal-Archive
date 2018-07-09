package model

// Factor contains coefficients for determining score
type Factor struct {
	quantity    float64
	random      float64
	prod        float64
	kill        float64
	power       float64
	ships       float64
	playerPower float64
	distance    float64
}

// Quantity of available ships
func (f Factor) Quantity() float64 {
	return f.quantity
}

// Random is a deviation of normal distribution
// is used for selecting index
func (f Factor) Random() float64 {
	return f.random
}

// Prod is a factor of production importance
func (f Factor) Prod() float64 {
	return f.prod
}

// Kill is a factor of kill percentage importance
func (f Factor) Kill() float64 {
	return f.kill
}

// Power is a factor of planet power importance
func (f Factor) Power() float64 {
	return f.power
}

// Ships is a factor of ships count importance
func (f Factor) Ships() float64 {
	return f.ships
}

// PlayerPower is a factor of player-power importance
func (f Factor) PlayerPower() float64 {
	return f.playerPower
}

// Distance is a factor of distance between planet importance
func (f Factor) Distance() float64 {
	return f.distance
}
