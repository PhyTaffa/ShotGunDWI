require "vector2"
require "Player"

-- tiled
local foxes
local birds
local DetectionZones = {}

--enemy sounds and associated variables

local foxSound
local birdSound
local birdSoundTimer = 0.1
local stalactiteSound

--Fox Forces
local inReachX = 4000
local inReachY = 1600

local outsideReachX = 1300
local outsideReachY = 5000


function LoadEnemies(world, foxsTable, birdTable)
    
    foxes = foxsTable
    birds = birdTable
    FoxDetectionZone(world)
    BirdDetectionZone(world)

end

function LoadEnemySounds()

    foxSound = love.audio.newSource("/sounds/foxtrim.wav","static")
    birdSound = love.audio.newSource("/sounds/crow.wav","static")
    stalactiteSound = love.audio.newSource("/sounds/crack.wav","static")

end

function FoxBehaviourTiled(dt)

    for i = 1, #foxes do

        local CurrentFox = foxes[i]

        if CurrentFox.body:isDestroyed() == false and CurrentFox.uncovered == true then
        --if foxnoticed == true then
        
            if CurrentFox.Readytimer > 0 then --timer function for idle animation. Future-proofing for after the prototyping delivery

            CurrentFox.Readytimer = CurrentFox.Readytimer - dt

                if CurrentFox.Readytimer < 0 then

                    if CurrentFox.attackTimer > 0 then
                        CurrentFox.attackTimer = CurrentFox.attackTimer - dt

                        love.audio.play(foxSound)
                        local Xplayer, YPlayer = PlayerPosition()
                        local playerPos = vector2.new(Xplayer - CurrentFox.body:getX(), YPlayer - CurrentFox.body:getY())
                        local playerMag = vector2.magnitude(playerPos)

                        --making the fox jump to the player if in reach or with a precise trajectory
                        if playerMag > 10*64 then
                        -- if player is outside of reach

                            --fox pounces right
                            if Xplayer >= CurrentFox.body:getX() then
                                CurrentFox.body:applyLinearImpulse(outsideReachX, outsideReachY)
                                CurrentFox.Readytimer = 2.5
                                CurrentFox.attackTimer = 1
                            else --fox pounces left
                                CurrentFox.body:applyLinearImpulse(-outsideReachX, -outsideReachY)
                                CurrentFox.Readytimer = 2.33
                                CurrentFox.attackTimer = 1
                            end

                        else -- if player is in reach

                            -- fox puonces right
                            if Xplayer >= CurrentFox.body:getX() then
                                CurrentFox.body:applyLinearImpulse(inReachX, -inReachY)
                                CurrentFox.Readytimer = 2.5
                                CurrentFox.attackTimer = 1
                            else-- fox puonces left
                                CurrentFox.body:applyLinearImpulse(-inReachX, -inReachY)
                                CurrentFox.Readytimer = 2.33
                                CurrentFox.attackTimer = 1
                            end

                        end
                    end
                end
            end
        end
    end
end

function FoxDetectionZone(world)

    for i = 1, #foxes do
        local CurrentFox = foxes[i]
    
        local startingX = CurrentFox.body:getX()
        local startingY = CurrentFox.body:getY()
        local foxZoneWIdth = 300
        local foxZoneHeight = 300

        CreateDetectionZone(startingX, startingY, foxZoneWIdth, foxZoneHeight, world, CurrentFox)

    end
end

function BirdDetectionZone(world)
    for i = 1, #birds do
        local CurrentBird = birds[i]
    
        local startingX = CurrentBird.body:getX()
        local startingY = CurrentBird.body:getY()
        local foxZoneWIdth = 1000
        local foxZoneHeight = 500

        CreateDetectionZone(startingX, startingY, foxZoneWIdth, foxZoneHeight, world, CurrentBird)

    end
end

function CreateDetectionZone(x, y, w, h, world, CurrentEnemy)

    local DetectionZone = {}

    -- Currently the drawed zone doesn't match the actual zone due to different methods of drawing
    DetectionZone.body = love.physics.newBody(world, x, y, "static")
    DetectionZone.shape = love.physics.newRectangleShape(w, h)
    DetectionZone.fixture = love.physics.newFixture(DetectionZone.body, DetectionZone.shape, 1)
    DetectionZone.fixture:setUserData(DetectionZone)
    DetectionZone.fixture:setSensor(true)
    DetectionZone.name = "detectionZone"
    DetectionZone.attachment = CurrentEnemy.fixture:getUserData()
    DetectionZone.typeOfEnemy = DetectionZone.attachment.name
    -- --values used for rappresentation in the draw
    -- DetectionZone.x = x - w/2
    -- DetectionZone.y = y - h/2
    
    DetectionZone.x = x 
    DetectionZone.y = y 
    DetectionZone.w = w
    DetectionZone.h = h


    table.insert(DetectionZones, DetectionZone)

end

function FoxUncovering(fox)
    fox.uncovered = true
end

function BirdActivating(bird)
    bird.active = true
end

function BirdDeactivating(bird)
    bird.active = false
end

-- function love.keypressed(key)
--     if key == "f" then
--         for i = 1, #foxes do

--             local CurrentFox = foxes[i]
--             if CurrentFox.body:isDestroyed() == false then
--                 CurrentFox.body:applyLinearImpulse(0,-10000)
--             end
--         end
--     end
-- end


function UpdateEnemies(dt, playerx, playery,ball, world)

    local playerposition = vector2.new(playerx,playery)

    FoxBehaviourTiled(dt) 
    for i = 1, #birds do

        local CurrentBird = birds[i]
        BirdMovementTiled(CurrentBird, playerposition)
    end

   --StalactiteCollision(ball, stalactitetrigger, stalactite)
   --FallingStalactite(stalactite, dt)

end

-- function FallingStalactite(stalactite,dt)
--     if stalactite.body:isDestroyed() == false then
--         if  stalactite.canFall == true and stalactite.groundContact ~= true then
--             stalactite.body:setY(stalactite.body:getY() +550 *dt)
--         end
--     end
-- end

function CanSee(pl, pllookdir, p2, viewangle)
    local direction = vector2.normalize(vector2.sub(p2, pl))
    local angle = math.acos (vector2.dot(pllookdir, direction))
    if (math.deg(angle) > viewangle) then
        return true
    end
    return false
end

function DrawEnemy()
    
    --TIled

    -- Foxes
    love.graphics.setColor(1, 0.5,0)
    for i = 1, #foxes do

        local CurrentFox = foxes[i]
        if CurrentFox.body:isDestroyed() == false and CurrentFox.uncovered == true then
            love.graphics.polygon("fill", CurrentFox.body:getWorldPoints(CurrentFox.shape:getPoints()))
        end
    end

    --Detection zones
    love.graphics.setColor(1,0,0)
    for i = 1, #DetectionZones do

        local CurrentDetectionZone = DetectionZones[i]
        if CurrentDetectionZone.attachment.uncovered == false then
            love.graphics.rectangle("line", CurrentDetectionZone.x - CurrentDetectionZone.w/2 , CurrentDetectionZone.y - CurrentDetectionZone.h/2, CurrentDetectionZone.w, CurrentDetectionZone.h)
        end
    end

    -- Birds
    love.graphics.setColor(0.2, 0.2, 0.2)
    for i = 1, #birds do

        local CurrentBird = birds[i]
        if CurrentBird.body:isDestroyed() == false then
            love.graphics.polygon("fill", CurrentBird.body:getWorldPoints(CurrentBird.shape:getPoints()))
        end
    end

end


function BirdMovementTiled(birb, playerposition)
    if birb.body:isDestroyed() == false then
        birb.direction = vector2.new(math.cos(birb.body:getAngle()), math.sin(birb.body:getAngle()))

        birb.chasing = CanSee(vector2.new(birb.body:getPosition()), birb.direction, playerposition, birb.viewangle)

        if birb.active then  

            if birb.chasing then
                local playerdirection = vector2.normalize(vector2.sub(playerposition, vector2.new(birb.body:getPosition())))
                local engineForce = vector2.mult(playerdirection,1800)
                birb.body:applyForce(engineForce.x, engineForce.y)

                if birb.x > 50 + birb.range then
                    birb.direction = -1
                elseif birb.x < 50 - birb.range then
                    birb.direction = 1
                end
            end
        else
            local vector2Home = vector2.new(birb.x, birb.y)
            local homeDirection = vector2.normalize(vector2.sub(vector2Home, vector2.new(birb.body:getPosition())))
                local engineForce = vector2.mult(homeDirection,1400)
                birb.body:applyForce(engineForce.x, engineForce.y)

                if birb.x > 50 + birb.range then
                    birb.direction = -1
                elseif birb.x < 50 - birb.range then
                    birb.direction = 1
                end
        end

    end
end

-- function StalactiteCollision(player, StalactiteTriggerZone, stalactite)
--     if stalactite.body:isDestroyed() == false then 
--         if  CheckCollision(player, StalactiteTriggerZone) then

--             stalactite.canFall = true
--         end
--     end
-- end