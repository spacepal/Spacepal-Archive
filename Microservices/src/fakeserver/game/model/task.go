package model

import (
	"errors"
	"fmt"
)

// Task is a
type Task struct {
	Player int `json:"player"`
	From   int `json:"from"`
	To     int `json:"to"`
	Count  int `json:"count"`
	Steps  int `json:"steps"`
}

func (t Task) String() string {
	return fmt.Sprintf("{Task player$%d from %d to %d ships %d steps %d }",
		t.Player, t.From, t.To, t.Count, t.Steps)
}

// Check validates Task
func (t *Task) Check() error {
	if t.From < 0 {
		return errors.New("Task: From id is negative")
	}
	if t.To < 0 {
		return errors.New("Task: To id is negative")
	}
	if t.Count < 0 {
		return errors.New("Task: Ships count is negative")
	}
	if t.Steps <= 0 {
		return errors.New("Task: Steps count must be greater than 0")
	}
	return nil
}
