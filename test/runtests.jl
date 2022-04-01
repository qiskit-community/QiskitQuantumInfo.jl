import QiskitQuantumInfo
using Test

@testset "QiskitQuantumInfo.jl" begin
    for s in ("X", "Y", "Z", "I")
        @test string(QiskitQuantumInfo.Pauli(s)) == s
    end
end

@testset "util" begin
    @test length(QiskitQuantumInfo.find_registry("QuantumRegistry")) >= 0
    @test QiskitQuantumInfo.find_installed_package("QuantumOps") isa Bool
end
