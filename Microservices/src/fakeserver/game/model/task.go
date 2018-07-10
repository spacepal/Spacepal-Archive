package model

// Task is a
type Task struct {
	Player int `json:"playerID"`
	From   int `json:"from"`
	To     int `json:"to"`
	Count  int `json:"count"`
	Steps  int `json:"-"`
}
