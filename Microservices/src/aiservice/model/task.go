package model

// Task represents an action per turn
type Task struct {
	FromID     int `json:"from"`
	ToID       int `json:"to"`
	ShipsCount int `json:"count"`
}

// From returns id of planet from where ships are sent
func (t Task) From() int {
	return t.FromID
}

// To returns id of planet where ships are sent
func (t Task) To() int {
	return t.ToID
}

// Count returns count of ships
func (t Task) Count() int {
	return t.ShipsCount
}
