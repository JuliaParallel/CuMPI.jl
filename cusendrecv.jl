using Test
using MPI

MPI.Init()

comm = MPI.COMM_WORLD
size = MPI.Comm_size(comm)
rank = MPI.Comm_rank(comm)

dst = mod(rank+1, size)
src = mod(rank-1, size)

N = 32

send_mesg = CuArray{Float32}(undef,N)
recv_mesg = CuArray{Float32}(undef,N)
recv_mesg_expected = CuArray{Float32}(undef,N)

fill!(send_mesg, Float32(rank))
fill!(recv_mesg_expected, Float32(src))

rreq = MPI.Irecv!(recv_mesg, src,  src+32, comm)
sreq = MPI.Isend(send_mesg, dst, rank+32, comm)

stats = MPI.Waitall!([sreq, rreq])
@test isequal(typeof(rreq), typeof(MPI.REQUEST_NULL))
@test isequal(typeof(sreq), typeof(MPI.REQUEST_NULL))
@test MPI.Get_source(stats[2]) == src
@test MPI.Get_tag(stats[2]) == src+32
@test recv_mesg == recv_mesg_expected

done, stats = MPI.Testall!([sreq, rreq])
@test done

MPI.Finalize()
