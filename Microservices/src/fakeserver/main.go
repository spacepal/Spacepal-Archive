package main

import (
	"log"
	"math/rand"
	"time"
)

func main() {
	rand.Seed(time.Now().UnixNano())
	log.Print("hello world")
}
