package main

import "embed"

//go:embed all:resources/package
var embeddedPackageFS embed.FS

//go:embed all:resources/template
var embeddedTemplateFS embed.FS
