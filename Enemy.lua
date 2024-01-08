require "vector2"
require "Player"

-- tiled
local foxes
local birds
local stalactites
local DetectionZones = {}

--enemy sounds and associated variables

local foxSound
local birdSound
local birdSoundTimer = 0
local stalactiteSound

--Fox Forces
local inReachX = 4000
local inReachY = 1600

local outsideReachX = 1300
local outsideReachY = 5000

--cheats
local DisplayTriggerZones = false

function LoadEnemies(world, foxsTable, birdTable, stalactitesTable)
    
    foxes = foxsTable
    birds = birdTable
    stalactites = stalactitesTable

    FoxDetectionZone(world)
    BirdDetectionZone(world)
    StalDetectionZone(world)

    StalImg = love.graphics.newImage("Immages/stalactite.png")

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
        local birdZoneWIdth = 1000
        local birdZoneHeight = 500

        CreateDetectionZone(startingX, startingY, birdZoneWIdth, birdZoneHeight, world, CurrentBird)

    end
end

function StalDetectionZone(world)
    for i = 1, #stalactites do
        local CurrentStal = stalactites[i]
    
        local startingX = CurrentStal.body:getX()
        local startingY = CurrentStal.body:getY()
        local stalZoneWIdth = 100
        local stalZoneHeight = 700

        --CreateDetectionZoneStal(startingX, startingY, stalZoneWIdth, stalZoneHeight, world, CurrentStal)
        CreateDetectionZone(startingX, startingY, stalZoneWIdth, stalZoneHeight, world, CurrentStal)

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

function CreateDetectionZoneStal(x, y, w, h, world, CurrentEnemy)

    local DetectionZone = {}

    -- Currently the drawed zone doesn't match the actual zone due to different methods of drawing
    DetectionZone.body = love.physics.newBody(world, x, y/2, "static")
    DetectionZone.shape = love.physics.newRectangleShape(w, 2 * h)
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

function CanStalFall(Stal)
    if Stal.body:isDestroyed() == false then
        Stal.Falling = true
    end
end

function KeyPressedEnemy()

    if love.keyboard.isDown("m") then
        DisplayTriggerZones = true
    end
end

function UpdateEnemies(dt, playerx, playery,ball, world)

    local playerposition = vector2.new(playerx,playery)

    FoxBehaviourTiled(dt) 

    for i = 1, #birds do

        local CurrentBird = birds[i]
        BirdMovementTiled(CurrentBird, playerposition, dt)
    end


   --StalactiteCollision(ball, stalactitetrigger, stalactite)
   FallingStalactite(stalactites, dt)

end

function FallingStalactite(Stal, dt)
    for i = 1, #stalactites do

        local CurrentStal = stalactites[i]
        if CurrentStal.body:isDestroyed() == false and CurrentStal.Falling == true then
            --local vel = CurrentStal.body:getLinearVelocity().y
        
            CurrentStal.body:applyForce(0, 10000)
        end
        --print(CurrentStal.index, " ", CurrentStal.Falling)
    end
end


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

    -- Birds
    love.graphics.setColor(0.2, 0.2, 0.2)
    for i = 1, #birds do

        local CurrentBird = birds[i]
        if CurrentBird.body:isDestroyed() == false then
            love.graphics.polygon("fill", CurrentBird.body:getWorldPoints(CurrentBird.shape:getPoints()))
        end
    end

    -- STALACTITE
    love.graphics.setColor(0, 1, 1)
    for i = 1, #stalactites do

        local CurrentStal = stalactites[i]
        if CurrentStal.body:isDestroyed() == false then
            love.graphics.draw(StalImg, CurrentStal.body:getX()-32, CurrentStal.body:getY()-64)
            --love.graphics.polygon("fill", CurrentStal.body:getWorldPoints(CurrentStal.shape:getPoints()))
        end
    end

    DrawEnemyTriggerZone()
    
end


function DrawEnemyTriggerZone()
    if DisplayTriggerZones then
        --Detection zones
        love.graphics.setColor(1,0,0)
        for i = 1, #DetectionZones do
    
            local CurrentDetectionZone = DetectionZones[i]

                love.graphics.rectangle("line", CurrentDetectionZone.x - CurrentDetectionZone.w/2 , CurrentDetectionZone.y - CurrentDetectionZone.h/2, CurrentDetectionZone.w, CurrentDetectionZone.h)
        end
    end

    DisplayTriggerZones = false

end


function BirdMovementTiled(birb, playerposition, dt)
    if birb.body:isDestroyed() == false then
        birb.direction = vector2.new(math.cos(birb.body:getAngle()), math.sin(birb.body:getAngle()))

        birb.chasing = CanSee(vector2.new(birb.body:getPosition()), birb.direction, playerposition, birb.viewangle)

        if birb.active then

            if birb.chasing then

                birb.soundTimer = birb.soundTimer - dt
                if birb.soundTimer < 0 then
                    love.audio.play(birdSound)
                    birb.soundTimer = 3
                end

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