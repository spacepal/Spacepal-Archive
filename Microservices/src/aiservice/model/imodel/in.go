package imodel

// InGetter has methods for getting main In fields
type InGetter interface {
	AIPlayers() []AIPlayerGetter
	MapSize() MapSizeGetter
	Planets() []PlanetGetter
}
