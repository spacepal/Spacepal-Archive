package norm

import "math"

// Normalize returns normalized value in range of 0.0 to 1.0
func Normalize(val, mid float64) float64 {
	if mid == 0 {
		return 0
	}
	val /= mid
	return 1/(-math.Abs(val)-1.0) + 1
}
