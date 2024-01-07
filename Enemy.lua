require "vector2"
require "Player"

local bird, bird2
local foxhurttriggerright, foxhurttriggerleft, birdhurttriggerleft, birdhurttriggerright, stalactitehurttriggerleft, stalactitehurttriggerright
local stalactite,  stalactitetrigger
local fox
local birdtrigger,bird2trigger
local foxnotice

local bird2hurttriggerleft,bird2hurttriggerright


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
    Direction = 1
    bird = {}
    bird.body = love.physics.newBody(world, 1400,  50, "dynamic")
    bird.shape = love.physics.newRectangleShape(100,50)
    bird.fixture = love.physics.newFixture(bird.body, bird.shape, 1)
    bird.body:setFixedRotation(true)
    bird.body:setLinearDamping(3)
    bird.fixture:setUserData(bird)
    bird.name = "enemy1"
    bird.type = "enemy"
    bird.x, bird.y = bird.body:getPosition()
    bird.speedX = 1
    bird.speedY = 1
    bird.direction = 1
    bird.OriginalX = 1300
    bird.OriginalY = 250
    bird.body:setGravityScale(0)
    bird.viewangle = 0
    bird.chasing = false
    bird.range = 2
    bird.killed = false
    bird.distance = 0
    bird.Origin = vector2.new(1300, 250)

    birdtrigger = {
        x = 1200,  -- x-coordinate of the trigger area
        y = 160,  -- y-coordinate of the trigger area
        width = 450,  -- width of the trigger area
        height = 1000,  -- height of the trigger area
        activated = false  -- flag to track if the trigger is activated
    }

    Xbird = bird.body:getX()
    Ybird = bird.body:getY()

    birdhurttriggerleft = {}
    birdhurttriggerleft.body = love.physics.newBody(world,Xbird,Ybird,"dynamic")
    birdhurttriggerleft.shape = love.physics.newRectangleShape(52,52)
    birdhurttriggerleft.fixture = love.physics.newFixture(birdhurttriggerleft.body,birdhurttriggerleft.shape,1)
    birdhurttriggerleft.fixture:setSensor (true)
    birdhurttriggerleft.fixture:setUserData (birdhurttriggerleft)
    birdhurttriggerleft.body:setMass(1)
    birdhurttriggerleft.name= "hurttriggerL"
    

    birdhurttriggerright = {}
    birdhurttriggerright.body = love.physics.newBody(world,Xbird,Ybird,"dynamic")
    birdhurttriggerright.shape = love.physics.newRectangleShape(52,52)
    birdhurttriggerright.fixture = love.physics.newFixture(birdhurttriggerright.body,birdhurttriggerright.shape,1)
    birdhurttriggerright.fixture:setSensor (true)
    birdhurttriggerright.fixture:setUserData (birdhurttriggerright)
    birdhurttriggerright.body:setMass(1)
    birdhurttriggerright.name= "hurttriggerR"






    bird2 = {}
    bird2.body = love.physics.newBody(world, 2500, -1450, "dynamic")
    bird2.shape = love.physics.newRectangleShape(100,50)
    bird2.fixture = love.physics.newFixture(bird2.body, bird2.shape, 1)
    bird2.body:setFixedRotation(true)
    bird2.body:setLinearDamping(3)
    bird2.fixture:setUserData(bird2)
    bird2.name = "enemy"
    bird2.type = "enemy"
    bird2.x, bird2.y = bird2.body:getPosition()
    bird2.speedX = 1
    bird2.speedY = 1
    bird2.direction = 1
    bird2.OriginalX = 2500
    bird2.OriginalY = -1450
    bird2.body:setGravityScale(0)
    bird2.viewangle = 0
    bird2.chasing = false
    bird2.range = 2
    bird2.killed = false
    bird2.distance = 0
    

    bird2trigger = {
        x = 2200,  -- x-coordinate of the trigger area
        y = -1560,  -- y-coordinate of the trigger area
        width = 450,  -- width of the trigger area
        height = 660,  -- height of the trigger area
        activated = false  -- flag to track if the trigger is activated
    }

    bird2hurttriggerleft = {}
    bird2hurttriggerleft.body = love.physics.newBody(world,Xbird2,Ybird2,"dynamic")
    bird2hurttriggerleft.shape = love.physics.newRectangleShape(52,52)
    bird2hurttriggerleft.fixture = love.physics.newFixture(bird2hurttriggerleft.body,bird2hurttriggerleft.shape,1)
    bird2hurttriggerleft.fixture:setSensor (true)
    bird2hurttriggerleft.fixture:setUserData (bird2hurttriggerleft)
    bird2hurttriggerleft.body:setMass(1)
    bird2hurttriggerleft.name= "hurttriggerL"

    bird2hurttriggerright = {}
    bird2hurttriggerright.body = love.physics.newBody(world,Xbird2,Ybird2,"dynamic")
    bird2hurttriggerright.shape = love.physics.newRectangleShape(52,52)
    bird2hurttriggerright.fixture = love.physics.newFixture(bird2hurttriggerright.body,bird2hurttriggerright.shape,1)
    bird2hurttriggerright.fixture:setSensor (true)
    bird2hurttriggerright.fixture:setUserData (bird2hurttriggerright)
    bird2hurttriggerright.body:setMass(1)
    bird2hurttriggerright.name= "hurttriggerR"





    fox = {}
    fox.body = love.physics.newBody(world, 576,100,"dynamic")
    fox.shape = love.physics.newRectangleShape(100,50)
    fox.fixture = love.physics.newFixture(fox.body,fox.shape,1)
    fox.body:setLinearDamping(3)
    fox.body:setMass(10)
    fox.fixture:setUserData(fox)
    fox.body:setFixedRotation(true)
    fox.name = "fox"
    fox.type = "enemy"
    fox.killed = false
    fox.distance = 0

    Xfox = fox.body:getX()
    Yfox = fox.body:getY()

    foxhurttriggerleft = {}
    foxhurttriggerleft.body = love.physics.newBody(world,Xfox,Yfox,"dynamic")
    foxhurttriggerleft.shape = love.physics.newRectangleShape(52,54)
    foxhurttriggerleft.fixture = love.physics.newFixture(foxhurttriggerleft.body,foxhurttriggerleft.shape,1)
    foxhurttriggerleft.fixture:setSensor (true)
    foxhurttriggerleft.fixture:setUserData (foxhurttriggerleft)
    foxhurttriggerleft.body:setMass(1)
    foxhurttriggerleft.name= "hurttriggerL"

    foxhurttriggerright = {}
    foxhurttriggerright.body = love.physics.newBody(world,Xfox,Yfox,"dynamic")
    foxhurttriggerright.shape = love.physics.newRectangleShape(52,54)
    foxhurttriggerright.fixture = love.physics.newFixture(foxhurttriggerright.body,foxhurttriggerright.shape,1)
    foxhurttriggerright.fixture:setSensor (true)
    foxhurttriggerright.body:setMass(1)
    foxhurttriggerright.fixture:setUserData (foxhurttriggerright)
    foxhurttriggerright.name= "hurttriggerR"

    foxnotice = {}
    foxnotice.body = love.physics.newBody(world,Xfox,Yfox,"static")
    foxnotice.shape = love.physics.newRectangleShape(500,500)
    foxnotice.fixture = love.physics.newFixture(foxnotice.body,foxnotice.shape,1)
    foxnotice.fixture:setSensor (true)
    foxnotice.fixture:setUserData (foxnotice)
    foxnotice.name= "foxarea"

    
    stalactite = {}
    stalactite.body = love.physics.newBody(world, 750,-925,"dynamic")
    stalactite.shape = love.physics.newRectangleShape(50,100)
    stalactite.fixture = love.physics.newFixture(stalactite.body,stalactite.shape,1)
    stalactite.body:setLinearDamping(3)
    stalactite.body:setMass(10)
    stalactite.fixture:setUserData(stalactite)
    stalactite.name = "stalactite"
    stalactite.type = "enemy"
    stalactite.body:setGravityScale(0)
    stalactite.canFall = false
    stalactite.x =0
    stalactite.y = 0
    stalactite.distance = 0
    stalactite.groundContact = false


    stalactitehurttriggerleft = {}
    stalactitehurttriggerleft.body = love.physics.newBody(world,XStalactite,Ystalactite,"dynamic")
    stalactitehurttriggerleft.shape = love.physics.newRectangleShape(52,102)
    stalactitehurttriggerleft.fixture = love.physics.newFixture(stalactitehurttriggerleft.body,stalactitehurttriggerleft.shape,1)
    stalactitehurttriggerleft.fixture:setSensor (true)
    stalactitehurttriggerleft.fixture:setUserData (stalactitehurttriggerleft)
    stalactitehurttriggerleft.body:setMass(1)
    stalactitehurttriggerleft.name= "hurttriggerL"

    stalactitehurttriggerright = {}
    stalactitehurttriggerright.body = love.physics.newBody(world,XStalactite,Ystalactite,"dynamic")
    stalactitehurttriggerright.shape = love.physics.newRectangleShape(52,102)
    stalactitehurttriggerright.fixture = love.physics.newFixture(stalactitehurttriggerright.body,stalactitehurttriggerright.shape,1)
    stalactitehurttriggerright.fixture:setSensor (true)
    stalactitehurttriggerright.fixture:setUserData (stalactitehurttriggerright)
    stalactitehurttriggerright.body:setMass(1)
    stalactitehurttriggerright.name= "hurttriggerR"

    stalactitetrigger = {
        x = 550,  -- x-coordinate of the trigger area
        y = -1550,  -- y-coordinate of the trigger area
        width = 300,  -- width of the trigger area
        height = 1200,  -- height of the trigger area
        activated = false  -- flag to track if the trigger is activated
    }


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

function UpdateTriggerPosition()
    if fox.body:isDestroyed() == false then
        Xfox, Yfox = fox.body:getPosition()
        foxhurttriggerright.body:setPosition(Xfox + 25, Yfox)
        foxhurttriggerleft.body:setPosition(Xfox - 25, Yfox)
    end

    if bird.body:isDestroyed() == false then
        Xbird, Ybird = bird.body:getPosition()
        birdhurttriggerleft.body:setPosition(Xbird - 25, Ybird)
        birdhurttriggerright.body:setPosition(Xbird + 25, Ybird)
    end

    if stalactite.body:isDestroyed() == false then
        XStalactite, Ystalactite= stalactite.body:getPosition()
        stalactitehurttriggerleft.body:setPosition(XStalactite - 25,  Ystalactite)
        stalactitehurttriggerright.body:setPosition(XStalactite + 25,  Ystalactite)
    end

    if bird2.body:isDestroyed() == false then
        Xbird2, Ybird2 = bird2.body:getPosition()
        bird2hurttriggerleft.body:setPosition(Xbird2 - 25, Ybird2)
        bird2hurttriggerright.body:setPosition(Xbird2 + 25, Ybird2)
    end
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
   
    -- BirdCollision(ball, birdtrigger, bird)
    -- BirdMovement(bird, playerposition)

    -- BirdCollision(ball, bird2trigger, bird2)
    -- BirdMovement(bird2, playerposition)

   
    -- BirdCollision(ball, bird2trigger, bird2)
    -- BirdMovement(bird2, playerposition)
   
   
    FoxBehaviourTiled(dt) 
    for i = 1, #birds do

        local CurrentBird = birds[i]
        BirdMovementTiled(CurrentBird, playerposition)
    end

   --StalactiteCollision(ball, stalactitetrigger, stalactite)
   FallingStalactite(stalactite, dt)

end

function FallingStalactite(stalactite,dt)
    if stalactite.body:isDestroyed() == false then
        if  stalactite.canFall == true and stalactite.groundContact ~= true then
            stalactite.body:setY(stalactite.body:getY() +550 *dt)
        end
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
    love.graphics.setColor(0.9,0.5,0.2)
    love.graphics.rectangle("line", birdtrigger.x, birdtrigger.y, birdtrigger.width, birdtrigger.height)
    love.graphics.rectangle("line", bird2trigger.x, bird2trigger.y, bird2trigger.width, bird2trigger.height)

    love.graphics.setColor(0.7,0.7,0.7)
    if bird.body:isDestroyed() == false then
        love.graphics.polygon("fill", bird.body:getWorldPoints(bird.shape:getPoints()))
    end

    if bird2.body:isDestroyed() == false then
        love.graphics.polygon("fill", bird2.body:getWorldPoints(bird2.shape:getPoints()))
    end

    love.graphics.setColor(1, 0.5,0)
    if fox.body:isDestroyed() == false then
         love.graphics.polygon("fill", fox.body:getWorldPoints(fox.shape:getPoints()))
    end

    love.graphics.setColor(0.2,0.1,0.5)
    if stalactite.body:isDestroyed() == false then
        love.graphics.polygon("fill", stalactite.body:getWorldPoints(stalactite.shape:getPoints()))
   end

    love.graphics.setColor(0.9,0.5,0.2)
    if stalactite.body:isDestroyed() == false then
        love.graphics.rectangle("line", stalactitetrigger.x, stalactitetrigger.y, stalactitetrigger.width, stalactitetrigger.height)
    end


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