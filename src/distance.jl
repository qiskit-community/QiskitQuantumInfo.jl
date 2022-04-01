# We probably won't use this. Prefer Distances.jl

function hellinger_distance!(p_counts::AbstractDict{T,V}, q_counts::AbstractDict{T,V}) where {T, V}
    p_sum = sum(values(p_counts))
    q_sum = sum(values(q_counts))
    total = float(zero(V))
    for (key, val) in p_counts
        if haskey(q_counts, key)
            total += (sqrt(val / p_sum) - sqrt(q_counts[key] / q_sum))^2
            delete!(q_counts, key)
        else
            total += val / p_sum
        end
    end
    total += sum(x -> x / q_sum, values(q_counts))
    dist = sqrt(total / 2)
    return dist
end

hellinger_distance(p_counts::AbstractDict, q_counts::AbstractDict) =
    hellinger_distance!(copy(p_counts), copy(q_counts))
