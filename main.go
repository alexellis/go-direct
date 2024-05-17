package main

import (
	"io"
	"log"
	"net/http"
)

func main() {

	mux := http.NewServeMux()

	mux.HandleFunc("/_/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})
	mux.HandleFunc("/_/ready", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		var body []byte
		if r.Body != nil {
			var err error
			body, err = io.ReadAll(r.Body)
			if err != nil {
				http.Error(w, "Failed to read request body", http.StatusInternalServerError)
				return
			}
		}

		log.Printf("Request: %s %s", r.Method, r.URL.Path)

		for k, v := range r.Header {
			log.Printf("Header: %s = %s", k, v)
		}

		log.Printf("Body: %s", string(body))

		w.WriteHeader(http.StatusAccepted)
	})

	log.Printf("Listening on: 8080")
	s := http.Server{
		Addr:    "0.0.0.0:8080",
		Handler: mux,
	}

	panic(s.ListenAndServe())
}
