;; go
package {{_input_:package_name_}}

import (
    "encoding/json"
    "net/http"
    "log"
)

type {{_input_:struct_name_}}Request struct {
    {{_input_:field_name_}} string `json:"{{_input_:json_field_}}"`
}

type {{_input_:struct_name_}}Response struct {
    Message string `json:"message"`
    Data    any    `json:"data,omitempty"`
}

func {{_input_:handler_name_}}Handler(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")

    if r.Method != http.Method{{_input_:http_method_}} {
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }

    var req {{_input_:struct_name_}}Request
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid JSON", http.StatusBadRequest)
        return
    }

    {{_cursor_}}

    response := {{_input_:struct_name_}}Response{
        Message: "Success",
        Data:    nil,
    }

    w.WriteHeader(http.StatusOK)
    if err := json.NewEncoder(w).Encode(response); err != nil {
        log.Printf("Failed to encode response: %v", err)
    }
}
