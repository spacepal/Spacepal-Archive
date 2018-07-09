package helpers

import (
	"testing"
)

func TestCalculateIndex(t *testing.T) {
	var c = PlanetChoiceMaker{}
	for i := 1; i < 100; i++ {
		val := c.calculateIndex(i, 2)
		if val < 0 {
			t.Error("Calculated index is negative!")
		} else if val >= i {
			t.Error("Calculated index is out of range!")
		}
	}
}
