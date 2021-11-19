using QiskitQuantumInfo
using Test

@testset "QiskitQuantumInfo.jl" begin
    for s in ("X", "Y")
        @test string(Pauli(s)) == s
    end
end
