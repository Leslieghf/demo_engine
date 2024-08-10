local physicsStatics = {}
physicsStatics.gravity = { x = 0, y = 0 }
physicsStatics.collisionTolerance = 0.001
physicsStatics.collisionIterations = 5
physicsStatics.maxSpeed = 250

local physicsVars = {}

local physicsLib = {
    resolveCircleCircleCollision = function(
        transformA,
        transformB,
        circleColliderA,
        circleColliderB,
        staticRigidbodyA,
        staticRigidbodyB,
        kinematicRigidbodyA,
        kinematicRigidbodyB,
        dynamicRigidbodyA,
        dynamicRigidbodyB
    )
        if staticRigidbodyA and staticRigidbodyB then
            return
        elseif staticRigidbodyA and kinematicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif staticRigidbodyA and dynamicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif kinematicRigidbodyA and staticRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif kinematicRigidbodyA and kinematicRigidbodyB then
            return
        elseif kinematicRigidbodyA and dynamicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif dynamicRigidbodyA and staticRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif dynamicRigidbodyA and kinematicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif dynamicRigidbodyA and dynamicRigidbodyB then
            local tolerance = physicsStatics.collisionTolerance
            local dx = transformB.x - transformA.x
            local dy = transformB.y - transformA.y
            local distance = math.sqrt(dx * dx + dy * dy)
        
            if distance <= circleColliderA.radius + circleColliderB.radius then
                -- Normalize the normal vector
                local nx = dx / distance
                local ny = dy / distance
        
                -- Calculate the tangential vector
                local tx = -ny
                local ty = nx
        
                -- Decompose velocities into normal and tangential components
                local v1n = dynamicRigidbodyA.velocity.x * nx + dynamicRigidbodyA.velocity.y * ny
                local v1t = dynamicRigidbodyA.velocity.x * tx + dynamicRigidbodyA.velocity.y * ty
                local v2n = dynamicRigidbodyB.velocity.x * nx + dynamicRigidbodyB.velocity.y * ny
                local v2t = dynamicRigidbodyB.velocity.x * tx + dynamicRigidbodyB.velocity.y * ty
        
                -- Calculate the effective coefficient of restitution
                local elasticity = dynamicRigidbodyA.elasticity * dynamicRigidbodyB.elasticity
        
                -- Calculate new normal velocities after collision
                local v1n_new = ((v1n * (dynamicRigidbodyA.mass - dynamicRigidbodyB.mass) + 2 * dynamicRigidbodyB.mass * v2n) / (dynamicRigidbodyA.mass + dynamicRigidbodyB.mass)) * elasticity
                local v2n_new = ((v2n * (dynamicRigidbodyB.mass - dynamicRigidbodyA.mass) + 2 * dynamicRigidbodyA.mass * v1n) / (dynamicRigidbodyA.mass + dynamicRigidbodyB.mass)) * elasticity
        
                -- Recompose velocities
                dynamicRigidbodyA.velocity.x = v1n_new * nx + v1t * tx
                dynamicRigidbodyA.velocity.y = v1n_new * ny + v1t * ty
                dynamicRigidbodyB.velocity.x = v2n_new * nx + v2t * tx
                dynamicRigidbodyB.velocity.y = v2n_new * ny + v2t * ty
        
                -- Optional: Separate overlapping circles to prevent sticking
                local overlap = circleColliderA.radius + circleColliderB.radius - distance
                local separationX = overlap * nx / 2
                local separationY = overlap * ny / 2
                transformA.x = transformA.x - separationX - (tolerance / 2)
                transformA.y = transformA.y - separationY - (tolerance / 2)
                transformB.x = transformB.x + separationX + (tolerance / 2)
                transformB.y = transformB.y + separationY + (tolerance / 2)
            end
        end        
    end,
    resolveCircleRectangleCollision = function(
        transformA,
        transformB,
        circleColliderA,
        rectangleColliderB,
        staticRigidbodyA,
        staticRigidbodyB,
        kinematicRigidbodyA,
        kinematicRigidbodyB,
        dynamicRigidbodyA,
        dynamicRigidbodyB
    )
        local minX = ghfDemoContext.screenStatics.minX
        local minY = ghfDemoContext.screenStatics.minY
        local maxX = ghfDemoContext.screenStatics.maxX
        local maxY = ghfDemoContext.screenStatics.maxY

        if staticRigidbodyA and staticRigidbodyB then
            return
        elseif staticRigidbodyA and kinematicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif staticRigidbodyA and dynamicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif kinematicRigidbodyA and staticRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif kinematicRigidbodyA and kinematicRigidbodyB then
            return
        elseif kinematicRigidbodyA and dynamicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif dynamicRigidbodyA and staticRigidbodyB then
            local effectiveElasticity = dynamicRigidbodyA.elasticity * staticRigidbodyB.elasticity
            local tolerance = physicsStatics.collisionTolerance
        
            -- Collision with left boundary
            if transformA.x <= minX + circleColliderA.radius then
                transformA.x = minX + circleColliderA.radius + tolerance
                dynamicRigidbodyA.velocity.x = -dynamicRigidbodyA.velocity.x * effectiveElasticity
            -- Collision with right boundary
            elseif transformA.x >= maxX - circleColliderA.radius then
                transformA.x = maxX - circleColliderA.radius - tolerance
                dynamicRigidbodyA.velocity.x = -dynamicRigidbodyA.velocity.x * effectiveElasticity
            end
            
            -- Collision with bottom boundary
            if transformA.y <= minY + circleColliderA.radius then
                transformA.y = minY + circleColliderA.radius + tolerance
                dynamicRigidbodyA.velocity.y = -dynamicRigidbodyA.velocity.y * effectiveElasticity
            -- Collision with top boundary
            elseif transformA.y >= maxY - circleColliderA.radius then
                transformA.y = maxY - circleColliderA.radius - tolerance
                dynamicRigidbodyA.velocity.y = -dynamicRigidbodyA.velocity.y * effectiveElasticity
            end
        elseif dynamicRigidbodyA and kinematicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif dynamicRigidbodyA and dynamicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        end
    end,
    resolveRectangleRectangleCollision = function(
        transformA,
        transformB,
        rectangleColliderA,
        rectangleColliderB,
        staticRigidbodyA,
        staticRigidbodyB,
        kinematicRigidbodyA,
        kinematicRigidbodyB,
        dynamicRigidbodyA,
        dynamicRigidbodyB
    )
        if staticRigidbodyA and staticRigidbodyB then
            return
        elseif staticRigidbodyA and kinematicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif staticRigidbodyA and dynamicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif kinematicRigidbodyA and staticRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif kinematicRigidbodyA and kinematicRigidbodyB then
            return
        elseif kinematicRigidbodyA and dynamicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif dynamicRigidbodyA and staticRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif dynamicRigidbodyA and kinematicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        elseif dynamicRigidbodyA and dynamicRigidbodyB then
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            -- NOT IMPLEMENTED YET
            error("NOT IMPLEMENTED YET")
        end
    end,
}

local physicsComponents = {}
physicsComponents.StaticRigidbody = {
    new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.mass = inf
        obj.elasticity = data.elasticity
        return obj
    end
}
physicsComponents.KinematicRigidbody = {
    new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.mass = data.mass
        obj.elasticity = data.elasticity
        obj.velocity = data.velocity
        return obj
    end
}
physicsComponents.DynamicRigidbody = {
    new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.mass = data.mass
        obj.elasticity = data.elasticity
        obj.velocity = data.velocity
        obj.linearAcceleration = data.linearAcceleration
        obj.linearDrag = data.linearDrag
        return obj
    end
}
physicsComponents.CircleCollider = {
    new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.radius = data.radius
        return obj
    end
}
physicsComponents.RectangleCollider = {
    new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.width = data.width
        obj.height = data.height
        return obj
    end
}

local physicsInvariants = {}
physicsInvariants.rigidbody1 = function(gameObject)
    local staticRigidbody = gameObject:getComponent("staticRigidbody")
    local kinematicRigidbody = gameObject:getComponent("kinematicRigidbody")

	if staticRigidbody and kinematicRigidbody then
		return false
	end
end
physicsInvariants.rigidbody2 = function(gameObject)
    local staticRigidbody = gameObject:getComponent("staticRigidbody")
    local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")

	if staticRigidbody and dynamicRigidbody then
		return false
	end
end
physicsInvariants.rigidbody3 = function(gameObject)
    local kinematicRigidbody = gameObject:getComponent("kinematicRigidbody")
    local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")

	if kinematicRigidbody and dynamicRigidbody then
		return false
	end
end
physicsInvariants.rigidbody4 = function(gameObject)
    local staticRigidbody = gameObject:getComponent("staticRigidbody")
    local kinematicRigidbody = gameObject:getComponent("kinematicRigidbody")
    local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")

	if staticRigidbody and kinematicRigidbody and dynamicRigidbody then
		return false
	end
end
physicsInvariants.rigidbody5 = function(gameObject)
    local circleCollider = gameObject:getComponent("circleCollider")
    local rectangleCollider = gameObject:getComponent("rectangleCollider")
    local staticRigidbody = gameObject:getComponent("staticRigidbody")
    local kinematicRigidbody = gameObject:getComponent("kinematicRigidbody")
    local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")

	if staticRigidbody or kinematicRigidbody or dynamicRigidbody then
		if not circleCollider and not rectangleCollider then
			return false
		end
	end
end

physicsInvariants.collider1 = function(gameObject)
    local circleCollider = gameObject:getComponent("circleCollider")
    local rectangleCollider = gameObject:getComponent("rectangleCollider")

	if circleCollider and rectangleCollider then
		return false
	end
end
physicsInvariants.collider2 = function(gameObject)
    local circleCollider = gameObject:getComponent("circleCollider")
    local rectangleCollider = gameObject:getComponent("rectangleCollider")
    local staticRigidbody = gameObject:getComponent("staticRigidbody")
    local kinematicRigidbody = gameObject:getComponent("kinematicRigidbody")
    local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")

	if circleCollider or rectangleCollider then
		if not staticRigidbody and not kinematicRigidbody and not dynamicRigidbody then
			return false
		end
	end
end

local physicsGlobalSystems = {}
physicsGlobalSystems.mainCollisionResolution = function(gameObjects)
	local potentialCollisions = {}
	for i = 1, #gameObjects do
		for j = i + 1, #gameObjects do
			if gameObjects[i].id ~= gameObjects[j].id then
				table.insert(potentialCollisions, { gameObjects[i], gameObjects[j] })
			end
		end
	end
        
    for i = 1, ghfDemoContext.physicsStatics.collisionIterations do
        for _, pair in ipairs(potentialCollisions) do
            local objectA = pair[1]
            local objectB = pair[2]
            
            local transformA = objectA:getComponent("transform")
            local transformB = objectB:getComponent("transform")

            local circleColliderA = objectA:getComponent("circleCollider")
            local circleColliderB = objectB:getComponent("circleCollider")

            local rectangleColliderA = objectA:getComponent("rectangleCollider")
            local rectangleColliderB = objectB:getComponent("rectangleCollider")
            
            local staticRigidbodyA = objectA:getComponent("staticRigidbody")
            local staticRigidbodyB = objectB:getComponent("staticRigidbody")

            local kinematicRigidbodyA = objectA:getComponent("kinematicRigidbody")
            local kinematicRigidbodyB = objectB:getComponent("kinematicRigidbody")

            local dynamicRigidbodyA = objectA:getComponent("dynamicRigidbody")
            local dynamicRigidbodyB = objectB:getComponent("dynamicRigidbody")
    
            if circleColliderA and circleColliderB then
                ghfDemoContext.physicsLib.resolveCircleCircleCollision(
                    transformA,
                    transformB,
                    circleColliderA,
                    circleColliderB,
                    staticRigidbodyA,
                    staticRigidbodyB,
                    kinematicRigidbodyA,
                    kinematicRigidbodyB,
                    dynamicRigidbodyA,
                    dynamicRigidbodyB
                )
            elseif circleColliderA and rectangleColliderB then
                ghfDemoContext.physicsLib.resolveCircleRectangleCollision(
                    transformA,
                    transformB,
                    circleColliderA,
                    rectangleColliderB,
                    staticRigidbodyA,
                    staticRigidbodyB,
                    kinematicRigidbodyA,
                    kinematicRigidbodyB,
                    dynamicRigidbodyA,
                    dynamicRigidbodyB
                )
            elseif rectangleColliderA and circleColliderB then
                ghfDemoContext.physicsLib.resolveCircleRectangleCollision(
                    transformB,
                    transformA,
                    circleColliderB,
                    rectangleColliderA,
                    staticRigidbodyB,
                    staticRigidbodyA,
                    kinematicRigidbodyB,
                    kinematicRigidbodyA,
                    dynamicRigidbodyB,
                    dynamicRigidbodyA
                )
            elseif rectangleColliderA and rectangleColliderB then
                ghfDemoContext.physicsLib.resolveRectangleRectangleCollision(
                    transformA,
                    transformB,
                    rectangleColliderA,
                    rectangleColliderB,
                    staticRigidbodyA,
                    staticRigidbodyB,
                    kinematicRigidbodyA,
                    kinematicRigidbodyB,
                    dynamicRigidbodyA,
                    dynamicRigidbodyB
                )
            end
        end
    end
end

local physicsLocalSystems = {}
physicsLocalSystems.applyGravity = function(gameObject, ghfDemoContext)
	local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")
	local gravity = ghfDemoContext.physicsStatics.gravity
	local delta = ghfDemoContext.deltaTime
	
    if dynamicRigidbody then
        dynamicRigidbody.velocity.x = dynamicRigidbody.velocity.x + gravity.x * delta
        dynamicRigidbody.velocity.y = dynamicRigidbody.velocity.y + gravity.y * delta
    end
end
physicsLocalSystems.applyLinearDrag = function(gameObject, ghfDemoContext)
	local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")
	
    if dynamicRigidbody then
        dynamicRigidbody.velocity.x = dynamicRigidbody.velocity.x * (1 - dynamicRigidbody.linearDrag)
        dynamicRigidbody.velocity.y = dynamicRigidbody.velocity.y * (1 - dynamicRigidbody.linearDrag)
    end
end
physicsLocalSystems.mainVelocityUpdate = function(gameObject, ghfDemoContext)
	local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")
	local delta = ghfDemoContext.deltaTime
	
    if dynamicRigidbody then
        dynamicRigidbody.velocity.x = dynamicRigidbody.velocity.x + dynamicRigidbody.linearAcceleration.x * delta
        dynamicRigidbody.velocity.y = dynamicRigidbody.velocity.y + dynamicRigidbody.linearAcceleration.y * delta
    end
end
physicsLocalSystems.applyMaxSpeed = function(gameObject, ghfDemoContext)
	local kinematicRigidbody = gameObject:getComponent("kinematicRigidbody")
	local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")
	local getVecLength = ghfDemoContext.mathLib.vec2.getLength
	local vecWithLength = ghfDemoContext.mathLib.vec2.withLength
	local maxSpeed = ghfDemoContext.physicsStatics.maxSpeed
	
    if kinematicRigidbody then
        if getVecLength(kinematicRigidbody.velocity.x, kinematicRigidbody.velocity.y) > maxSpeed then
            kinematicRigidbody.velocity.x, kinematicRigidbody.velocity.y = vecWithLength(
                kinematicRigidbody.velocity.x,
                kinematicRigidbody.velocity.y,
                maxSpeed
            )
        end
    elseif dynamicRigidbody then
        if getVecLength(dynamicRigidbody.velocity.x, dynamicRigidbody.velocity.y) > maxSpeed then
            dynamicRigidbody.velocity.x, dynamicRigidbody.velocity.y = vecWithLength(
                dynamicRigidbody.velocity.x,
                dynamicRigidbody.velocity.y,
                maxSpeed
            )
        end
    end
end
physicsLocalSystems.mainPositionUpdate = function(gameObject, ghfDemoContext)
	local transform = gameObject:getComponent("transform")
	local kinematicRigidbody = gameObject:getComponent("kinematicRigidbody")
	local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")
	local delta = ghfDemoContext.deltaTime
	
    if kinematicRigidbody then
        transform.x = transform.x + kinematicRigidbody.velocity.x * delta
        transform.y = transform.y + kinematicRigidbody.velocity.y * delta
    elseif dynamicRigidbody then
        transform.x = transform.x + dynamicRigidbody.velocity.x * delta
        transform.y = transform.y + dynamicRigidbody.velocity.y * delta
    end
end

return physicsLib, physicsVars, physicsStatics, physicsComponents, physicsInvariants, physicsGlobalSystems, physicsLocalSystems