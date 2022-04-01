using Pkg: Pkg

"""
    find_registry(registry_name::AbstractString = "QuantumRegistry")

Return the registry `registry_name`. If the registry is not installed, return
`nothing`.
"""
function find_registry(registry_name::AbstractString = "QuantumRegistry")::Union{Pkg.Registry.RegistryInstance,Nothing}
    result = Pkg.Registry.find_installed_registries(stdout, [Pkg.RegistrySpec(registry_name)])
    isempty(result) && return nothing
    return only(result)
end


"""
    is_dependency_installed(package_name::AbstractString)

Return `true` if the direct dependency `package_name` of the current project is found
in the current dependency graph. There is no check made that `package_name` is
actually a dependency.
"""
is_dependency_installed(package_name::AbstractString)::Bool =
    any(x -> x.name == package_name && x.is_direct_dep, values(Pkg.dependencies()))
