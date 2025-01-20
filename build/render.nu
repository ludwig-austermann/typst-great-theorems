#!/bin/nu

def main [input_file: path, render_file = "build/render_template.typ"] {
    let output_file = $input_file | str replace ".typ" ".png"

    # open input_file | str replace "@preview/great-theorems:0.2.0" "lib.typ"

    typst compile --root . --input file=$"($input_file)" $render_file $output_file
}