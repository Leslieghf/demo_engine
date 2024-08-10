local registryVars = {}
registryVars.registries = {}

local registryLib = {
    createRegistry = function(type)
        registryVars.registries[type] = {
            nextID = 1,
            recycledIDs = {},
            registeredEntries = {}
        }
    end,
    register = function(type, entry)
        local registry = registryVars.registries[type]
        if not registry then
            error("Registry type '" .. type .. "' does not exist.")
        end

        local id
        if #registry.recycledIDs > 0 then
            id = table.remove(registry.recycledIDs)
        else
            id = registry.nextID
            registry.nextID = registry.nextID + 1
        end

        registry.registeredEntries[id] = entry
        return id
    end,
    unregister = function(type, id)
        local registry = registryVars.registries[type]
        if not registry then
            error("Registry type '" .. type .. "' does not exist.")
        end

        registry.registeredEntries[id] = nil
        table.insert(registry.recycledIDs, id)
    end,
    get = function(type, id)
        local registry = registryVars.registries[type]
        if not registry then
            error("Registry type '" .. type .. "' does not exist.")
        end

        return registry.registeredEntries[id]
    end,
    getAll = function(type)
        local registry = registryVars.registries[type]
        if not registry then
            error("Registry type '" .. type .. "' does not exist.")
        end

        return registry.registeredEntries
    end,
    contains = function(type, id)
        local registry = registryVars.registries[type]
        if not registry then
            error("Registry type '" .. type .. "' does not exist.")
        end

        return registry.registeredEntries[id] ~= nil
    end,
}

return registryLib, registryVars