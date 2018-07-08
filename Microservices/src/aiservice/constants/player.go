package constants

// AI types
const (
	AggressiveType = "AgressiveAI"
	DefensiveType  = "DefensiveAI"
)

// AITypes is a map of registered AI types
var AITypes = map[string]bool{
	AggressiveType: true,
	DefensiveType:  true,
}
