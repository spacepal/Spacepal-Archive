package model

import (
	"aiservice/model/imodel"
)

// AINamesOut represents a model of response with all registered AI names
type AINamesOut struct {
	All   []string `json:"all"`
	Count int      `json:"count"`
}
type TasksOut struct {
	Players []PlayerOut `json:"players"`
}

type PlayerOut struct {
	Player int                 `json:"id"`
	Tasks  []imodel.TaskGetter `json:"tasks"`
}
