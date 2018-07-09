package main

import (
	"aiservice/constants"
	"aiservice/handler"
	"flag"
	"net/http"

	log "github.com/sirupsen/logrus"
)

func main() {
	var addr = flag.String("addr", constants.Address, "address to serve")
	flag.Parse()
	http.Handle("/ai/do", new(handler.DoHandler))
	http.Handle("/ai/names", new(handler.AINamesHandler))
	log.Fatal(http.ListenAndServe(*addr, nil))
}
