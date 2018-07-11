package model

import (
	"aiservice/model/imodel"
)

// AINamesOut represents a model of response with all registered AI names
type AINamesOut struct {
	All   []string `json:"all"`
	Count int      `json:"count"`
}

// TasksOut represents a model of response with moves of players
type TasksOut struct {
	Tasks []imodel.TaskGetter `json:"tasks"`
}
