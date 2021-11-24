import QiskitQuantumInfo
using Test

@testset "QiskitQuantumInfo.jl" begin
    for s in ("X", "Y")
        @test string(QiskitQuantumInfo.Pauli(s)) == s
    end
end
