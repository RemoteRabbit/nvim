;; go
package main

import (
    "flag"
    "fmt"
    "log"
    "os"
)

var (
    verbose = flag.Bool("verbose", false, "Enable verbose output")
    config  = flag.String("config", "", "Path to config file")
)

func main() {
    flag.Parse()

    if *verbose {
        log.SetFlags(log.LstdFlags | log.Lshortfile)
        log.Println("Verbose mode enabled")
    }

    args := flag.Args()
    if len(args) == 0 {
        fmt.Fprintf(os.Stderr, "Usage: %s [options] <command>\n", os.Args[0])
        flag.PrintDefaults()
        os.Exit(1)
    }

    command := args[0]

    switch command {
    case "{{_input_:command_name_}}":
        if err := {{_input_:function_name_}}(args[1:]); err != nil {
            log.Fatalf("Error: %v", err)
        }
    default:
        fmt.Fprintf(os.Stderr, "Unknown command: %s\n", command)
        os.Exit(1)
    }
}

func {{_input_:function_name_}}(args []string) error {
    {{_cursor_}}
    return nil
}
