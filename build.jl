src_dir = "Queller"
output_dir = "QuellerCLI"
build_env = "julia_build_env"

using Pkg
Pkg.activate(build_env)
Pkg.instantiate()

# Create build dir
mkpath(output_dir)

# Build program
using PackageCompiler
create_app(src_dir, output_dir, executables=["Queller"=>"main"], force=true)

# Create a shortcuts to program
shortcut = joinpath(output_dir, "QuellerCLI")

if Sys.iswindows()
	exe = joinpath("bin", "Queller.exe")
	shortcut *= ".lnk"

	create_sc = "\$s=(New-Object -COM WScript.Shell).CreateShortcut('$shortcut');"
	set_sc_target = "\$s.TargetPath='%windir%\\explorer.exe';"
	set_sc_argument = "\$s.Arguments='$exe';"
	set_sc_icon = "\$s.IconLocation='Winver.exe,0';"
	save_sc = "\$s.Save()"
	cmd = `powershell "$create_sc $set_sc_target $set_sc_argument $set_sc_icon $save_sc"`

	run(cmd)
else
	symlink("bin/Queller", shortcut)
end
