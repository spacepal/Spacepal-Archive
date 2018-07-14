package ihelpers

// GlobStatGetter has methods for getting stat information
type GlobStatGetter interface {
	PlayerPower(player int) float64
	MidShips() int
	RelatedScore(player int) float64
}
