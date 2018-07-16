package ilist

// FactorGetter is an interface for getting main factor fields
type FactorGetter interface {
	Quantity() float64 // relative number of ships to send
	Random() float64   // is a deviation in normal distribution
	Prod() float64
	Kill() float64
	Power() float64
	Ships() float64
	PlayerPower() float64
	Distance() float64 // Must be negative
	WithoutDistance() FactorGetter
}
