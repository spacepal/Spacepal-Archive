package imodel

// PlanetGetter has methods for getting main Planet fields
type PlanetGetter interface {
	ID() int
	Owner() int
	Cell() int
	Prod() int
	Kill() int
	Ships() int
}
