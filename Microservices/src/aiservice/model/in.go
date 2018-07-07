package model

// In is a model of microservice-input data
type In struct {
	Player int    `json:"playerID"`
	Type   string `json:"aiType"`
	Map    struct {
		Width  int `json:"width"`
		Height int `json:"height"`
	} `json:"map"`
	Planets []Planet `json:"planets"`
}
