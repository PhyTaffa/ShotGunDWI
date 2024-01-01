vector2 = {}

function vector2.new(px,py)
    return{x = px, y = py}
end

function vector2.add(vec,inc)
    local result = vector2.new(0,0)
    result.x = vec.x + inc.x
    result.y = vec.y + inc.y
    return result
end

function vector2.sub(vec, dec)
    local result = vector2.new(0,0)
    result.x = vec.x - dec.x
    result.y = vec.y - dec.y
    return result
end

function vector2.mult(vec, n)
    local result = vector2.new(0,0)
    result.x= vec.x * n
    result.y = vec.y * n
    return result
end

function vector2.div(vec, n)
    local result = vector2.new(0,0)
    result.x= vec.x / n
    result.y = vec.y / n
    return result
end

function vector2.magnitude(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y )
end

function vector2.normalize(vec)
    local m = vector2.magnitude(vec)
    if m ~= 0 then
        return vector2.div(vec,m)
    end
        return vec
end

function vector2.Unity(vec)
    local v= vector2.new(math.abs(vec.x), math.abs(vec.y))
    local m = vector2.DivVector(vec, v)
    
    return m
end

function vector2.DivVector(vec,inc)
    local result = vector2.new(0,0)
    result.x= vec.x / inc.x
    result.y = vec.y / inc.y
    return result
    
end

function vector2.dot(vec1, vec2)
    return vec1.x * vec2.x + vec1.y * vec2.y
end


function vector2.rotation(vec, n)
    local result = vector2.new(0,0)
    result.x = vec.x * math.cos(n) - vec.y * math.sin(n)
    result.y = vec.x * math.sin(n) + vec.y * math.cos(n)
    return result
end