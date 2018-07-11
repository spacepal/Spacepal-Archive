package igame

// Player is a member of the game
type Player interface {
	Score() float64
	Ships() int
	Name() string
	ID() int
}
