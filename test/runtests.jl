import QiskitQuantumInfo
using Test
import Pkg

@testset "QiskitQuantumInfo.jl" begin
    for s in ("X", "Y", "Z", "I")
        @test string(QiskitQuantumInfo.Pauli(s)) == s
    end
end

@testset "util" begin
    reg = QiskitQuantumInfo.find_registry("QuantumRegistry")
    @test any(t -> reg isa t, (Pkg.Registry.RegistryInstance, Nothing))
    @test QiskitQuantumInfo.is_dependency_installed("QuantumOps") isa Bool
end
