package main

import (
	"aiservice/ai"
	"aiservice/constants"
	"aiservice/handler"
	"flag"
	"net/http"

	log "github.com/sirupsen/logrus"
)

func main() {
	var addr = flag.String("addr", constants.Address, "address to serve")
	flag.Parse()
	var aiManager = ai.NewManager()
	ai.RegisterAll(aiManager)
	http.Handle("/ai/do", new(handler.DoHandler))
	http.Handle("/ai/names", handler.NewAINamesHandler(aiManager))
	log.Fatal(http.ListenAndServe(*addr, nil))
}
