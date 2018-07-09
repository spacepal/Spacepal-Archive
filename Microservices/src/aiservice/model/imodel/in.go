package imodel

// InGetter has methods for getting main In fields
type InGetter struct {
	AIPlayers []AIPlayerGetter
	MapSize   MapSizeGetter
	Planets   []PlanetGetter
}
