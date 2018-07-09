package imodel

// AIPlayerGetter has methods for getting main AIPlyers fields
type AIPlayerGetter interface {
	Name() string
	Player() int
}
