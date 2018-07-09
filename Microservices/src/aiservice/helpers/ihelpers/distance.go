package ihelpers

// DistanceCalculator has method for calculating distance to any cell
type DistanceCalculator interface {
	Calculate(cell int) int
}
