package model

import "errors"

// Task is a
type Task struct {
	Player int `json:"player"`
	From   int `json:"from"`
	To     int `json:"to"`
	Count  int `json:"count"`
	Steps  int `json:"steps"`
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
