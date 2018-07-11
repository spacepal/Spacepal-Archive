package main

import "fmt"

const redColor = "\033[31 "
const blueColor = "\033[34 "
const greenColor = "\033[32 "
const purpleColor = "\033[35 "
const resetAll = "\033[0m"

type color string

func scolor(strs ...interface{}) color {
	return color(fmt.Sprint(strs))
}

func (c color) Red() string {
	return redColor + string(c) + resetAll
}

func (c color) Blue() string {
	return blueColor + string(c) + resetAll
}

func (c color) Green() string {
	return greenColor + string(c) + resetAll
}

func (c color) Purple() string {
	return purpleColor + string(c) + resetAll
}
