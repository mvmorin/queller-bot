# src_dir="Queller"
# output_dir="QuellerCLI"

# using Pkg
# Pkg.activate(src_dir)
# Pkg.instantiate()

# using PackageCompiler

# name = "Queller"*(Sys.iswindows() ? ".exe" : "")
# path = joinpath("bin", name)
# link = joinpath(output_dir, name)

# create_app(src_dir, output_dir, force=true)

# rm(link)
# symlink(path, link, dir_target=false)

# tar = `tar -czvf $(output_dir).tar.gz $(output_dir)`
# zip = `zip -r $(output_dir).zip $(output_dir)`
# run(tar)
# run(zip)

println("Hello, World")
mkpath("build-output")
write("build-output/test.txt", "hej\n")
write("build-output/test2.txt", "hej\n")
