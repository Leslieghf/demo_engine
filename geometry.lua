local geometryLib = {
    generateCircleVertices = function(x, y, radius, segments)
        local vertices = {}
        table.insert(vertices, { x = x, y = y })

        for i = 0, segments do
            local angle = (i / segments) * math.pi * 2
            local vx = x + radius * math.cos(angle)
            local vy = y + radius * math.sin(angle)
            table.insert(vertices, { x = vx, y = vy })
        end

        return vertices
    end,
    generateRectangleVertices = function(x, y, width, height)
        local halfWidth = width / 2
        local halfHeight = height / 2

        local vertices = {}
        table.insert(vertices, { x = x - halfWidth, y = y - halfHeight })  -- Top-left
        table.insert(vertices, { x = x + halfWidth, y = y - halfHeight })  -- Top-right
        table.insert(vertices, { x = x + halfWidth, y = y + halfHeight })  -- Bottom-right
        table.insert(vertices, { x = x - halfWidth, y = y + halfHeight })  -- Bottom-left

        return vertices
	end
}

return geometryLib