using MPI
using Test

exename = joinpath(Sys.BINDIR, Base.julia_exename())
testdir = dirname(@__FILE__)

nprocs = 2

for f in ["cusendrecv.jl"]
    run(`mpiexec $extra_args -n $nprocs $exename $(joinpath(testdir, f))`)
end
