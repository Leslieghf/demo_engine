
		            


-- Initialize context
ghfDemoContext = {}
ghfDemoContext.alpha = alpha
ghfDemoContext.deltaTime = nil
ghfDemoContext.invariants = {}
ghfDemoContext.globalSystems = {}
ghfDemoContext.localSystems = {}

ghfDemoContext.screenStatics = include("projects/demo_engine/screen.lua")

ghfDemoContext.registryLib,
ghfDemoContext.registryVars = include("projects/demo_engine/registry.lua")

ghfDemoContext.mathLib = include("projects/demo_engine/math.lua")

ghfDemoContext.geometryLib = include("projects/demo_engine/geometry.lua")

ghfDemoContext.GameObject,
ghfDemoContext.coreComponents,
ghfDemoContext.coreInvariants,
ghfDemoContext.coreGlobalSystems = include("projects/demo_engine/ecs.lua")

ghfDemoContext.inputLib,
ghfDemoContext.inputVars,
ghfDemoContext.inputGlobalSystems = include("projects/demo_engine/input.lua")

ghfDemoContext.physicsLib, 
ghfDemoContext.physicsVars,
ghfDemoContext.physicsStatics,
ghfDemoContext.physicsComponents,
ghfDemoContext.physicsInvariants,
ghfDemoContext.physicsGlobalSystems,
ghfDemoContext.physicsLocalSystems = include("projects/demo_engine/physics.lua")

ghfDemoContext.renderComponents,
ghfDemoContext.renderInvariants,
ghfDemoContext.renderGlobalSystems,
ghfDemoContext.renderLocalSystems = include("projects/demo_engine/render.lua")

-- Collect invariants from context
ghfDemoContext.invariants["transform1"] = ghfDemoContext.coreInvariants.transform1

ghfDemoContext.invariants["rigidbody1"] = ghfDemoContext.physicsInvariants.rigidbody1
ghfDemoContext.invariants["rigidbody2"] = ghfDemoContext.physicsInvariants.rigidbody2
ghfDemoContext.invariants["rigidbody3"] = ghfDemoContext.physicsInvariants.rigidbody3
ghfDemoContext.invariants["rigidbody4"] = ghfDemoContext.physicsInvariants.rigidbody4
ghfDemoContext.invariants["rigidbody5"] = ghfDemoContext.physicsInvariants.rigidbody5

ghfDemoContext.invariants["collider1"] = ghfDemoContext.physicsInvariants.collider1
ghfDemoContext.invariants["collider2"] = ghfDemoContext.physicsInvariants.collider2

ghfDemoContext.invariants["renderMaterial1"] = ghfDemoContext.renderInvariants.renderMaterial1

ghfDemoContext.invariants["shape1"] = ghfDemoContext.renderInvariants.shape1
ghfDemoContext.invariants["shape2"] = ghfDemoContext.renderInvariants.shape2

-- Collect global systems from context
ghfDemoContext.globalSystems[#ghfDemoContext.globalSystems + 1] = ghfDemoContext.renderGlobalSystems.mainBackgroundRendering
ghfDemoContext.globalSystems[#ghfDemoContext.globalSystems + 1] = ghfDemoContext.physicsGlobalSystems.mainCollisionResolution
ghfDemoContext.globalSystems[#ghfDemoContext.globalSystems + 1] = ghfDemoContext.coreGlobalSystems.mainGameObjectUpdate
ghfDemoContext.globalSystems[#ghfDemoContext.globalSystems + 1] = ghfDemoContext.inputGlobalSystems.mainInputHandler
ghfDemoContext.globalSystems[#ghfDemoContext.globalSystems + 1] = ghfDemoContext.inputGlobalSystems.toggleInputFocus

-- Collect local systems from context
ghfDemoContext.localSystems[#ghfDemoContext.localSystems + 1] = ghfDemoContext.physicsLocalSystems.applyGravity
ghfDemoContext.localSystems[#ghfDemoContext.localSystems + 1] = ghfDemoContext.physicsLocalSystems.applyLinearDrag
ghfDemoContext.localSystems[#ghfDemoContext.localSystems + 1] = ghfDemoContext.physicsLocalSystems.mainVelocityUpdate
ghfDemoContext.localSystems[#ghfDemoContext.localSystems + 1] = ghfDemoContext.physicsLocalSystems.applyMaxSpeed
ghfDemoContext.localSystems[#ghfDemoContext.localSystems + 1] = ghfDemoContext.physicsLocalSystems.mainPositionUpdate
ghfDemoContext.localSystems[#ghfDemoContext.localSystems + 1] = ghfDemoContext.renderLocalSystems.updateDynamicCircleColor
ghfDemoContext.localSystems[#ghfDemoContext.localSystems + 1] = ghfDemoContext.renderLocalSystems.mainShapeRendering

-- Temporary util functions
local function createExampleObject(self, segments, minRadius, maxRadius, minSpeed, maxSpeed, minAcceleration, maxAcceleration, elasticity, linearDrag, color)
    local example = ghfDemoContext.GameObject:new()

	local function isValid(x, y, radius, selfID)
        for _, exampleObject in ipairs(self.exampleObjects) do
            if exampleObject.id == example.id then
                continue
            end

            local transform = exampleObject:getComponent("transform")
            local circleCollider = exampleObject:getComponent("circleCollider")

            local dist = ghfDemoContext.mathLib.vec2.getDistance(transform.x, transform.y, x, y)
            if dist < circleCollider.radius + radius then
                return false
            end
        end
        return true
    end
	
    local x, y
    local angle = math.rad(math.random(0, 360))
	local radius = math.random(minRadius, maxRadius)
    local speed = math.random(minSpeed, maxSpeed)
    local acceleration = math.random(minAcceleration, maxAcceleration)
    local velocity = { x = speed * math.cos(angle), y = speed * math.sin(angle) }
    local linearAcceleration = { x = acceleration * math.cos(angle), y = acceleration * math.sin(angle) }
    local mass = (2 * 3.14159265358 * radius) ^ 2

    local attempts = 0
    repeat
        if attempts > 100 then
            error("Failed to find a valid position for the example object.")
        end

        x = math.random(radius, ghfDemoContext.screenStatics.maxX - radius)
        y = math.random(radius, ghfDemoContext.screenStatics.maxY - radius)
        attempts = attempts + 1
    until isValid(x, y, radius, example.id)
        
    local transform = ghfDemoContext.coreComponents.Transform:new({ x = x, y = y })
    local rigidbody = ghfDemoContext.physicsComponents.DynamicRigidbody:new({
        mass = mass,
		elasticity = elasticity,
		velocity = velocity,
		linearAcceleration = linearAcceleration,
		linearDrag = linearDrag
    })
    local collider = ghfDemoContext.physicsComponents.CircleCollider:new({ radius = radius })
    local shape = ghfDemoContext.renderComponents.CircleShape:new({ radius = radius, segments = segments, filled = true })
    local renderMaterial = ghfDemoContext.renderComponents.RenderMaterial:new({ color = color })
    
    example:addComponent("transform", transform)
    example:addComponent("dynamicRigidbody", rigidbody)
    example:addComponent("circleCollider", collider)
    example:addComponent("circleShape", shape)
    example:addComponent("renderMaterial", renderMaterial)
    
    return example
end

local function createWorldBorder(thickness, elasticity)
    local halfThickness = thickness / 2

	local minX = ghfDemoContext.screenStatics.minX
	local minY = ghfDemoContext.screenStatics.minY
    local maxX = ghfDemoContext.screenStatics.maxX
    local maxY = ghfDemoContext.screenStatics.maxY
    
    local northX = maxX - ((maxX - minX) / 2)
    local northY = minY - halfThickness
    local eastX = maxX + halfThickness
    local eastY = maxY - ((maxY - minY) / 2)
    local southX = maxX - ((maxX - minX) / 2)
    local southY = maxY + halfThickness
    local westX = minX - halfThickness
    local westY = maxY - ((maxY - minY) / 2)

    local northWidth = maxX - minX + (thickness * 2)
    local northHeight = thickness
    local eastWidth = thickness
    local eastHeight = maxY - minY
    local southWidth = maxX - minX + (thickness * 2)
    local southHeight = thickness
    local westWidth = thickness
    local westHeight = maxY - minY

    --local northColor = { r = 255, g = 0, b = 0, a = 63 }
    --local eastColor = { r = 255, g = 255, b = 0, a = 63 }
    --local southColor = { r = 0, g = 255, b = 0, a = 63 }
    --local westColor = { r = 0, g = 0, b = 255, a = 63 }
    local northColor = { r = 255, g = 255, b = 255, a = 0 }
    local eastColor = { r = 255, g = 255, b = 255, a = 0 }
    local southColor = { r = 255, g = 255, b = 255, a = 0 }
    local westColor = { r = 255, g = 255, b = 255, a = 0 }

    local worldBorderNorth = ghfDemoContext.GameObject:new()
    local worldBorderEast = ghfDemoContext.GameObject:new()
    local worldBorderSouth = ghfDemoContext.GameObject:new()
    local worldBorderWest = ghfDemoContext.GameObject:new()
    
    local transformNorth = ghfDemoContext.coreComponents.Transform:new({ x = northX, y = northY })
    local transformEast = ghfDemoContext.coreComponents.Transform:new({ x = eastX, y = eastY })
    local transformSouth = ghfDemoContext.coreComponents.Transform:new({ x = southX, y = southY })
    local transformWest = ghfDemoContext.coreComponents.Transform:new({ x = westX, y = westY })
    
    local rigidbodyNorth = ghfDemoContext.physicsComponents.StaticRigidbody:new({ elasticity = elasticity})
    local rigidbodyEast = ghfDemoContext.physicsComponents.StaticRigidbody:new({ elasticity = elasticity})
    local rigidbodySouth = ghfDemoContext.physicsComponents.StaticRigidbody:new({ elasticity = elasticity})
    local rigidbodyWest = ghfDemoContext.physicsComponents.StaticRigidbody:new({ elasticity = elasticity})
    
    local colliderNorth = ghfDemoContext.physicsComponents.RectangleCollider:new({ width = northWidth, height = northHeight })
    local colliderEast = ghfDemoContext.physicsComponents.RectangleCollider:new({ width = eastWidth, height = eastHeight })
    local colliderSouth = ghfDemoContext.physicsComponents.RectangleCollider:new({ width = southWidth, height = southHeight })
    local colliderWest = ghfDemoContext.physicsComponents.RectangleCollider:new({ width = westWidth, height = westHeight })
    
	local shapeNorth = ghfDemoContext.renderComponents.RectangleShape:new({ width = northWidth, height = northHeight, color = northColor, filled = true })
	local shapeEast = ghfDemoContext.renderComponents.RectangleShape:new({ width = eastWidth, height = eastHeight, color = eastColor, filled = true })
	local shapeSouth = ghfDemoContext.renderComponents.RectangleShape:new({ width = southWidth, height = southHeight, color = southColor, filled = true })
	local shapeWest = ghfDemoContext.renderComponents.RectangleShape:new({ width = westWidth, height = westHeight, color = westColor, filled = true })
	
	local renderMaterialNorth = ghfDemoContext.renderComponents.RenderMaterial:new({ color = northColor })
    local renderMaterialEast = ghfDemoContext.renderComponents.RenderMaterial:new({ color = eastColor })
    local renderMaterialSouth = ghfDemoContext.renderComponents.RenderMaterial:new({ color = southColor })
    local renderMaterialWest = ghfDemoContext.renderComponents.RenderMaterial:new({ color = westColor })

    worldBorderNorth:addComponent("transform", transformNorth)
    worldBorderEast:addComponent("transform", transformEast)
    worldBorderSouth:addComponent("transform", transformSouth)
    worldBorderWest:addComponent("transform", transformWest)

    worldBorderNorth:addComponent("staticRigidbody", rigidbodyNorth)
    worldBorderEast:addComponent("staticRigidbody", rigidbodyEast)
    worldBorderSouth:addComponent("staticRigidbody", rigidbodySouth)
    worldBorderWest:addComponent("staticRigidbody", rigidbodyWest)

    worldBorderNorth:addComponent("rectangleCollider", colliderNorth)
    worldBorderEast:addComponent("rectangleCollider", colliderEast)
    worldBorderSouth:addComponent("rectangleCollider", colliderSouth)
    worldBorderWest:addComponent("rectangleCollider", colliderWest)

	worldBorderNorth:addComponent("rectangleShape", shapeNorth)
	worldBorderEast:addComponent("rectangleShape", shapeEast)
	worldBorderSouth:addComponent("rectangleShape", shapeSouth)
	worldBorderWest:addComponent("rectangleShape", shapeWest)

    worldBorderNorth:addComponent("renderMaterial", renderMaterialNorth)
    worldBorderEast:addComponent("renderMaterial", renderMaterialEast)
    worldBorderSouth:addComponent("renderMaterial", renderMaterialSouth)
    worldBorderWest:addComponent("renderMaterial", renderMaterialWest)

    return worldBorderNorth, worldBorderEast, worldBorderSouth, worldBorderWest
end

-- Initialize demo
local main = {}
main.Title = "Demo Engine"
main.Author = "Leslieghf"

function main:OnStart()
	print("Demo Engine: Starting...")
	
	-- Randomize the RNG seed
    local rngSeed = RealTime() % 16
    for i = 1, rngSeed do
        math.random(0, i)
    end

	-- Create world border
	local worldBorderThickness = 16
	local worldBorderElasticity = 0.9
	
	createWorldBorder(worldBorderThickness, worldBorderElasticity)
    
    -- Create balls
	local exampleObjectCount = 25
	local exampleObjectSegments = 16
	local exampleObjectMinRadius = 15
	local exampleObjectMaxRadius = 30
	local exampleObjectMinSpeed = 15
	local exampleObjectMaxSpeed = 50
	local exampleObjectMinAcceleration = 0
	local exampleObjectMaxAcceleration = 0
	local exampleObjectElasticity = 0.9
	local exampleObjectLinearDrag = -0.01
	local exampleObjectColor = { r = 255, g = 255, b = 255, a = 255 }
	
    self.exampleObjects = {}
	for i = 1, exampleObjectCount do
		table.insert(self.exampleObjects, createExampleObject(
			self,
			exampleObjectSegments,
			exampleObjectMinRadius,
			exampleObjectMaxRadius,
			exampleObjectMinSpeed,
			exampleObjectMaxSpeed,
			exampleObjectMinAcceleration,
			exampleObjectMaxAcceleration,
			exampleObjectElasticity,
			exampleObjectLinearDrag,
			exampleObjectColor
		))
	end
end

function main:OnStop()
	print("Demo Engine: Stopping...")
end

function main:OnThink(delta)
end

function main:OnDraw(w, h, alpha, delta, ent, mpos)
	ghfDemoContext.alpha = alpha
	ghfDemoContext.deltaTime = delta
	
    local gameObjects = ghfDemoContext.registryLib.getAll("gameObject")
    
	-- Execute global systems
    for _, globalSystem in pairs(ghfDemoContext.globalSystems) do
        globalSystem(gameObjects, ghfDemoContext)
    end
end

-- Register demo
demoman.AddDemo(main, true)