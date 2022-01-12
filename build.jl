src_dir = "Queller"
output_dir = "QuellerCLI"
build_env = "julia_build_env"

using Pkg
Pkg.activate(build_env)
Pkg.instantiate()

using PackageCompiler

create_app(src_dir, output_dir, executables=["Queller"=>"main"], force=true)
