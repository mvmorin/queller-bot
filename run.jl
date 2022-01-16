using Pkg
Pkg.activate("Queller", io=devnull)
Pkg.instantiate(io=devnull)

using Queller
main()
