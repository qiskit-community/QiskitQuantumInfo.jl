#### Pauli

mutable struct Pauli{T, B}
    x::B
    z::B
    phase::T
end

Base.length(p::Pauli) = length(p.x)

"""
    symplectic_to_char(x::Integer, z::Integer)

Return a character in the set `IXYZ` given by the symplectic representation `x, z`,
where `x` and `z` are typically `Bool`s.
"""
function symplectic_to_char(x::Integer, z::Integer)
    (x & z == 1) && return 'Y'
    x == 1 && return 'X'
    z == 1 && return 'Z'
    return 'I'
end

function Base.show(io::IO, p::Pauli)
    phase_strings = ("", "-i", "-", "i")
    print(io, phase_strings[p.phase + 1])
    for (x, z) in zip(p.x, p.z)
        print(io, symplectic_to_char(x, z))
    end
end

Pauli(n::Integer) = Pauli(Vector{Bool}(undef, n), Vector{Bool}(undef, n), 0)
#Pauli(n::Integer) = Pauli(BitVector(undef, n), BitVector(undef, n), 0)

function Base.setindex!(p::Pauli, (x, z), i::Integer)
    p.x[i] = x
    p.z[i] = z
    return (x, z)
end

function symplectic(c::AbstractChar)
    c == 'I' && return (false, false)
    c == 'X' && return (true, false)
    c == 'Y' && return (true, true)
    c == 'Z' && return (false, true)
    throw(ArgumentError("Expecting one of IXYZ"))
end

function symplectic(s::AbstractString)
    p = Pauli(length(s))
    for (i, c) in enumerate(s)
        p[i] = symplectic(c)
    end
    return p
end

function Pauli(s::AbstractString)
    phase = 0
    offset = 0
    if s[1] == '+'
        if s[2] == 'i'
            phase = 3
            offset = 2
        else
            phase = 0
            offset = 1
        end
    elseif s[1] == '-'
        if s[2] == 'i'
            phase = 1
            offset = 2
        else
            phase = 2
            offset = 1
        end
    elseif s[1] == 'i'
        phase = 3
        offset = 1
    end
    if offset == 0 # There is an overhead for SubString :(
        p = symplectic(s)
    else
        p = symplectic(SubString(s, offset + 1, length(s)))
    end
    p.phase = phase
    return p
end
