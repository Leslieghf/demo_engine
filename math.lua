local mathLib = {}
mathLib.vec2 = {
    getLength = function(x, y)
        return math.sqrt(x^2 + y^2)
    end,
    getAngle = function(x, y)
        return math.atan2(y, x)
    end,
    withLength = function(x, y, newLength)
        local currentLength = math.sqrt(x^2 + y^2)
        if currentLength == 0 then return 0, 0 end
        local scale = newLength / currentLength
        return x * scale, y * scale
    end,
    getDistance = function(x1, y1, x2, y2)
        local dx = x2 - x1
        local dy = y2 - y1
        return math.sqrt(dx^2 + dy^2)
    end,
    add = function(x1, y1, x2, y2)
        return x1 + x2, y1 + y2
    end,
    subtract = function(x1, y1, x2, y2)
        return x1 - x2, y1 - y2
    end,
    scale = function(x, y, scalar)
        return x * scalar, y * scalar
    end,
    normalize = function(x, y)
        local length = math.sqrt(x^2 + y^2)
        if length == 0 then return 0, 0 end
        return x / length, y / length
    end,
    dot = function(x1, y1, x2, y2)
        return x1 * x2 + y1 * y2
    end,
    rotate = function(x, y, angle)
        local cosAngle = math.cos(angle)
        local sinAngle = math.sin(angle)
        return x * cosAngle - y * sinAngle, x * sinAngle + y * cosAngle
    end,
    perpendicular = function(x, y)
        return -y, x
    end,
    lerp = function(x1, y1, x2, y2, t)
        return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t
    end,
    project = function(x1, y1, x2, y2)
        local dotProduct = x1 * x2 + y1 * y2
        local lengthSquared = x2 * x2 + y2 * y2
        local scale = dotProduct / lengthSquared
        return x2 * scale, y2 * scale
    end,
    reflect = function(x, y, normalX, normalY)
        local dotProduct = x * normalX + y * normalY
        return x - 2 * dotProduct * normalX, y - 2 * dotProduct * normalY
    end,
}
mathLib.vec3 = {
    getLength = function(x, y, z)
        return math.sqrt(x^2 + y^2 + z^2)
    end,
    withLength = function(x, y, z, newLength)
        local currentLength = math.sqrt(x^2 + y^2 + z^2)
        if currentLength == 0 then return 0, 0, 0 end
        local scale = newLength / currentLength
        return x * scale, y * scale, z * scale
    end,
    getDistance = function(x1, y1, z1, x2, y2, z2)
        local dx = x2 - x1
        local dy = y2 - y1
        local dz = z2 - z1
        return math.sqrt(dx^2 + dy^2 + dz^2)
    end,
    add = function(x1, y1, z1, x2, y2, z2)
        return x1 + x2, y1 + y2, z1 + z2
    end,
    subtract = function(x1, y1, z1, x2, y2, z2)
        return x1 - x2, y1 - y2, z1 - z2
    end,
    scale = function(x, y, z, scalar)
        return x * scalar, y * scalar, z * scalar
    end,
    normalize = function(x, y, z)
        local length = math.sqrt(x^2 + y^2 + z^2)
        if length == 0 then return 0, 0, 0 end
        return x / length, y / length, z / length
    end,
    dot = function(x1, y1, z1, x2, y2, z2)
        return x1 * x2 + y1 * y2 + z1 * z2
    end,
    cross = function(x1, y1, z1, x2, y2, z2)
        return y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2
    end,
    rotateX = function(x, y, z, angle)
        local cosAngle = math.cos(angle)
        local sinAngle = math.sin(angle)
        return x, y * cosAngle - z * sinAngle, y * sinAngle + z * cosAngle
    end,
    rotateY = function(x, y, z, angle)
        local cosAngle = math.cos(angle)
        local sinAngle = math.sin(angle)
        return x * cosAngle + z * sinAngle, y, -x * sinAngle + z * cosAngle
    end,
    rotateZ = function(x, y, z, angle)
        local cosAngle = math.cos(angle)
        local sinAngle = math.sin(angle)
        return x * cosAngle - y * sinAngle, x * sinAngle + y * cosAngle, z
    end,
    lerp = function(x1, y1, z1, x2, y2, z2, t)
        return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t, z1 + (z2 - z1) * t
    end,
    project = function(x1, y1, z1, x2, y2, z2)
        local dotProduct = x1 * x2 + y1 * y2 + z1 * z2
        local lengthSquared = x2 * x2 + y2 * y2 + z2 * z2
        local scale = dotProduct / lengthSquared
        return x2 * scale, y2 * scale, z2 * scale
    end,
    reflect = function(x, y, z, normalX, normalY, normalZ)
        local dotProduct = x * normalX + y * normalY + z * normalZ
        return x - 2 * dotProduct * normalX, y - 2 * dotProduct * normalY, z - 2 * dotProduct * normalZ
    end,
}
mathLib.rect = {
    getBounds = function(x, y, width, height)
        local minX = x - width / 2
        local minY = y - height / 2
        local maxX = x + width / 2
        local maxY = y + height / 2

        return minX, minY, maxX, maxY
    end
}

return mathLib