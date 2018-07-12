package igame

// Planet is a main game object:
//   Player can own planet
//   Planet has strategic parameters such as:
//     Kill: is a power of one ship that is send from this planet
//     Production: The number of ships increases by production every game-turn
type Planet interface {
	ID() int
	Owner() int
	Cell() int
	Prod() int
	InitalProd() int
	Kill() float64
	Ships() int
	IsNeutral() bool
	String() string
}
