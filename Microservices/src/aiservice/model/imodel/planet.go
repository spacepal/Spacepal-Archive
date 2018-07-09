package imodel

// PlanetGetter has methods for getting main Planet fields
type PlanetGetter interface {
	ID() int
	Owner() int
	Cell() int
	Prod() int
	Kill() float64
	Ships() int
	IsNeutral() bool
	NormalizedPlanetGetter
}

// NormalizedPlanetGetter has methods for getting normalized Planet fields
type NormalizedPlanetGetter interface {
	NormalizedPower() float64
	NormalizedKill() float64
	NormalizedProd() float64
}
