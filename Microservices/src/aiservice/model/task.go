package model

// Task represents an action per turn
type Task struct {
	From  int `json:"from"`
	To    int `json:"to"`
	Count int `json:"count"`
}
