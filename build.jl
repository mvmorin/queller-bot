src_dir = "Queller"
output_dir = "QuellerCLI"
build_env = "julia_build_env"

using Pkg
Pkg.activate(build_env)
Pkg.instantiate()

using PackageCompiler

create_app(src_dir, output_dir, executables=["Queller"=>"main"], force=true)

# mkpath(output_dir * "/dummy_dir")
# write(output_dir * "/dummy.txt", "Hej")
# write(output_dir * "/dummy_dir/dummy.txt", "Hello")



# name = "Queller"*(Sys.iswindows() ? ".exe" : "")
# path = joinpath("bin", name)
# link = joinpath(output_dir, name)

# tar = `tar -czvf $(output_dir).tar.gz $(output_dir)`
# zip = `zip -r $(output_dir).zip $(output_dir)`
# run(tar)
# run(zip)
