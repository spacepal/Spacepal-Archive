package model

// AINamesOut represents a model of response with all registered AI names
type AINamesOut struct {
	All   []string `json:"all"`
	Count int      `json:"count"`
}
