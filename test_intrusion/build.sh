#!/bin/sh

pandoc pentest.md -o pentest.pdf --from markdown --template eisvogel.latex --listings --pdf-engine=xelatex
