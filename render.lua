local renderComponents = {}
renderComponents.RenderMaterial = {
	new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.color = data.color
        return obj
    end
}
renderComponents.CircleShape = {
    new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.radius = data.radius
        obj.segments = data.segments
        obj.filled = data.filled
        return obj
    end
}
renderComponents.RectangleShape = {
    new = function(self, data)
        local obj = setmetatable({}, { __index = self })
        obj.width = data.width
        obj.height = data.height
        obj.filled = data.filled
        return obj
    end
}

local renderInvariants = {}
renderInvariants.renderMaterial1 = function(gameObject)
    local circleShape = gameObject:getComponent("circleShape")
    local rectangleShape = gameObject:getComponent("rectangleShape")
    local renderMaterial = gameObject:getComponent("renderMaterial")

	if renderMaterial then 
		if not circleShape and not rectangleShape then
			return false
		end
	end
end

renderInvariants.shape1 = function(gameObject)
    local circleShape = gameObject:getComponent("circleShape")
    local rectangleShape = gameObject:getComponent("rectangleShape")

	if circleShape and rectangleShape then
		return false
	end
end
renderInvariants.shape2 = function(gameObject)
    local circleShape = gameObject:getComponent("circleShape")
    local rectangleShape = gameObject:getComponent("rectangleShape")
    local renderMaterial = gameObject:getComponent("renderMaterial")

	if circleShape or rectangleShape then
		if not renderMaterial then
			return false
		end
	end
end

local renderGlobalSystems = {}
renderGlobalSystems.mainBackgroundRendering = function(gameObjects, ghfDemoContext)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, ghfDemoContext.screenStatics.maxX, ghfDemoContext.screenStatics.maxY)
end

local renderLocalSystems = {}
renderLocalSystems.updateDynamicCircleColor = function(gameObject, ghfDemoContext)
    local dynamicRigidbody = gameObject:getComponent("dynamicRigidbody")
    local circleShape = gameObject:getComponent("circleShape")
    local renderMaterial = gameObject:getComponent("renderMaterial")
    local getVecLength = ghfDemoContext.mathLib.vec2.getLength
    local maxSpeed = ghfDemoContext.physicsStatics.maxSpeed
    
    if dynamicRigidbody and circleShape then
        local speedNormalized = getVecLength(dynamicRigidbody.velocity.x, dynamicRigidbody.velocity.y) / maxSpeed
        local r = 255 * speedNormalized
        local g = 255 * (1 - speedNormalized)
        local b = 0
        local a = 255
        
        renderMaterial.color = { r = r, g = g, b = b, a = a }
    end
end
renderLocalSystems.mainShapeRendering = function(gameObject, ghfDemoContext)
    local transform = gameObject:getComponent("transform")
    local circleShape = gameObject:getComponent("circleShape")
    local rectangleShape = gameObject:getComponent("rectangleShape")
    local renderMaterial = gameObject:getComponent("renderMaterial")
    local color = renderMaterial.color
    
    if circleShape then
        surface.SetDrawColor(color.r, color.g, color.b, color.a)
        draw.NoTexture()

        if circleShape.filled then
            local vertices = ghfDemoContext.geometryLib.generateCircleVertices(transform.x, transform.y, circleShape.radius, circleShape.segments)
            surface.DrawPoly(vertices)
        else
            surface.DrawCircle(transform.x, transform.y, circleShape.radius)
        end
    elseif rectangleShape then
        surface.SetDrawColor(color.r, color.g, color.b, color.a)
        draw.NoTexture()
		
        if rectangleShape.filled then
            local vertices = ghfDemoContext.geometryLib.generateRectangleVertices(transform.x, transform.y, rectangleShape.width, rectangleShape.height)
            surface.DrawPoly(vertices)
        else
            surface.DrawRect(transform.x, transform.y, rectangleShape.width, rectangleShape.height)
        end
    end
end

return renderComponents, renderInvariants, renderGlobalSystems, renderLocalSystems