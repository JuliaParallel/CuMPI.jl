module CuMPI

import MPI
using CuArrays

function MPI.Isend(buf::CuArray{T}, dest::Integer, tag::Integer,
                            comm::MPI.Comm) where T
    _buf = CuArrays.buffer(buf)
    GC.@preserve _buf begin
        cuptr = reinterpret(Ptr{T}, pointer(buf))
        MPI.Isend(cuptr, length(buf), dest, tag, comm)
    end
end

function MPI.Irecv!(buf::CuArray{T}, src::Integer, tag::Integer,
    comm::MPI.Comm) where T
    _buf = CuArrays.buffer(buf)
    GC.@preserve _buf begin
        cuptr = reinterpret(Ptr{T}, pointer(buf))
        MPI.Irecv!(cuptr, length(buf), src, tag, comm)
    end
end

end # module
