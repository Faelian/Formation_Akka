#!/bin/sh

pandoc linux_admin.md -o linux_admin.pdf --from markdown --template eisvogel.latex --listings --pdf-engine=xelatex
