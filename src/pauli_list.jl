#### PauliList

"""
    PauliList{T, B}

A Pauli list
"""
struct PauliList{T, B}
    x::B
    z::B
    phase::Vector{T}
end

PauliList(n_strings::Integer, n_qubits::Integer) =
    PauliList(Array{Bool}(undef, (n_strings, n_qubits)), Array{Bool}(undef, (n_strings, n_qubits)), zeros(Int, n_strings))

Base.length(pauli_list::PauliList) = first(size(pauli_list.x))

"""
    PauliList(paulis::Vector{<:Pauli})

Return a `PauliList` constructed from a vector of `Pauli`s.
"""
function PauliList(paulis::Vector{<:Pauli})
    pauli_list = PauliList(length(paulis), length(first(paulis)))
    @inbounds for i in eachindex(paulis)
        pauli_list.x[i,:] .= paulis[i].x
        pauli_list.z[i,:] .= paulis[i].z
        pauli_list.phase[i] = paulis[i].phase
    end
    return pauli_list
end

Base.getindex(pl::PauliList, i::Integer) = Pauli(getindex(pl.x, i,:), getindex(pl.z, i, :), pl.phase[i])
Base.view(pl::PauliList, i::Integer) = Pauli(view(pl.x, i,:), view(pl.z, i, :), pl.phase[i])

#### SparsePauliOp

struct SparsePauliOp{P, C}
    pauli_list::P
    coeffs::C
end

SparsePauliOp(pauli_list::PauliList) = SparsePauliOp(pauli_list, ones(Complex{Float64}, length(pauli_list)))

function SparsePauliOp(pauli_sum::QuantumOps.PauliSum)
    num_terms = length(pauli_sum)
    num_qubits = length(first(pauli_sum))
    pauli_list = PauliList(num_terms, num_qubits)
    # Determining when threads are faster is a chore
#    @inbounds Threads.@threads for i in eachindex(pauli_sum.strings)
    @inbounds for i in eachindex(pauli_sum.strings)
        for j in eachindex(pauli_sum.strings[i])
            (x, z) = QuantumOps.Paulis.symplectic(pauli_sum.strings[i][j])
            pauli_list.x[i, j] = x
            pauli_list.z[i, j] = z
        end
    end
    return SparsePauliOp(pauli_list, copy(pauli_sum.coeffs))
end
