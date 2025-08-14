;; go
package {{_input_:package_name_}}

import (
    "testing"
)

func Test{{_input_:function_name_}}(t *testing.T) {
    tests := []struct {
        name     string
        input    {{_input_:input_type_}}
        expected {{_input_:output_type_}}
        wantErr  bool
    }{
        {
            name:     "{{_input_:test_case_name_}}",
            input:    {{_input_:test_input_}},
            expected: {{_input_:test_expected_}},
            wantErr:  false,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result, err := {{_input_:function_name_}}(tt.input)

            if (err != nil) != tt.wantErr {
                t.Errorf("{{_input_:function_name_}}() error = %v, wantErr %v", err, tt.wantErr)
                return
            }

            if result != tt.expected {
                t.Errorf("{{_input_:function_name_}}() = %v, expected %v", result, tt.expected)
            }
        })
    }
}

func Benchmark{{_input_:function_name_}}(b *testing.B) {
    input := {{_input_:benchmark_input_}}

    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        {{_input_:function_name_}}(input)
    }
}

{{_cursor_}}
