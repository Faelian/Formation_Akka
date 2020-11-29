#!/bin/sh

pandoc réseau.md -o réseau.pdf --from markdown --template eisvogel.latex --listings --pdf-engine=xelatex
