# markdown-html
Translate markdown to html using the John Gruber's perl script with pluggable style (default is Ethan Schoonover's Solarized)

## Usage

`./markdown-html markdown_files_directory [style_name]`

- `markdown_files_source_directory`: absolute path to directory containing markdown files to trnaslate
- `style_name`: a name of the style to include. Styles are stored as css files in /path/to/markdown-html_dir/styles

The output is a directory with the "-html" suffix that contains the generated html files.
The generated output preserves the original directory tree.

## Requirements
It requires perl >= 5.6.0 for the John Gruber's perl script to run.
