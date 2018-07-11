package model

import (
	"aiservice/model/imodel"
)

// Task represents an action per turn
type Task struct {
	PlayerID   int `json:"player"`
	FromID     int `json:"from"`
	ToID       int `json:"to"`
	ShipsCount int `json:"count"`
	Distance   int `json:"steps"`
}

// NewTask is the Task-factory method
func NewTask(player, from, to, ships, distance int) imodel.TaskGetter {
	return &Task{PlayerID: player, FromID: from, ToID: to,
		ShipsCount: ships, Distance: distance}
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
