local gameObjectLib = {
    init = function()
        ghfDemoContext.registryLib.createRegistry("gameObject")

        local GameObject = {}
        GameObject.__index = GameObject

        function GameObject:new()
            local obj = setmetatable({}, self)
            obj.components = {}
            obj.id = ghfDemoContext.registryLib.register("gameObject", obj)
            return obj
        end

        function GameObject:destroy()
            ghfDemoContext.registryLib.unregister("gameObject", self.id)
        end

        function GameObject:addComponent(componentType, component)
            self.components[componentType] = component
        end

        function GameObject:removeComponent(componentType)
            self.components[componentType] = nil
        end

        function GameObject:getComponent(componentType)
            return self.components[componentType]
        end

        function GameObject:hasComponent(componentType)
            return self.components[componentType] ~= nil
        end

        return GameObject
    end
}
local GameObject = gameObjectLib.init()

local coreComponents = {}
coreComponents.Transform = {
    new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.x = data.x
        obj.y = data.y
        return obj
    end
}

local coreInvariants = {}
coreInvariants.transform1 = function(gameObject)
    local transform = gameObject:getComponent("transform")

    if not transform then
        return false
    end
end

local coreGlobalSystems = {}
coreGlobalSystems.mainGameObjectUpdate = function(gameObjects, ghfDemoContext)
    for gameObjectID, gameObject in ipairs(gameObjects) do
        -- Enforce invariants
        for invariantName, invariant in pairs(ghfDemoContext.invariants) do
            if invariant(gameObject) == false then
                error("Invariant '" .. invariantName .. "' violated.")
            end
        end
    
        -- Execute local systems
        for _, localSystem in pairs(ghfDemoContext.localSystems) do
            localSystem(gameObject, ghfDemoContext)
        end
    end
end

return GameObject, coreComponents, coreInvariants, coreGlobalSystems