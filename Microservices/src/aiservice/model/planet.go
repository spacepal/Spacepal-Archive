package model

// Planet is a model of map main cell
type Planet struct {
	ID    int     `json:"id"`
	Owner int     `json:"ownerID"`
	Cell  int     `json:"cellID"`
	Prod  int     `json:"production"`
	Kill  float32 `json:"killPerc"`
	Ships float32 `json:"ships"`
}
