src_dir = "Queller"
output_dir = "QuellerCLI"
build_env = "julia_build_env"

using Pkg
Pkg.activate(build_env)
Pkg.instantiate()

using PackageCompiler

create_app(src_dir, output_dir, executables=["Queller"=>"main"], force=true)

if Sys.iswindows()
	startup_body = """
	@echo off
	start ./bin/Queller.exe
	"""
	startup_file_name = "QuellerCLI.bat"
else
	startup_body = """
	#!/bin/sh
	./bin/Queller
	"""
	startup_file_name = "QuellerCLI"
end
write(output_dir*"/"*startup_file_name, startup_body)
