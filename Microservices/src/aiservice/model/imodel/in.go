package imodel

// InGetter has methods for getting main In fields
type InGetter interface {
	CallbackURL() string
	AIPlayers() []AIPlayerGetter
	MapSize() MapSizeGetter
	Planets() []PlanetGetter
}
