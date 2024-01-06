require "vector2"

local ball
local timer = 0
-- local CameraDirection = vector2.new(0,0)
local Stranded = false
local ammo = 10
local DisplayShootingZone = false
local collected = false
local ammoboxtrigger
local win = false
local knockbacky = -1200
local knockbackposx = 1200
local knockbacknegx = -1200
local knockbacktoggle = false
local knockbacktoggletimer = 0.1

local cheats= false
local GravityChangin = true
local rotation = 0
local anmmoConsumption = true

--tiled table
local AmmoBoxes

--Tiled imgs
local AmmoBoxImg
local playerSprite
local gunSprite
local customCursor
local customCursorReloading
local ammoCounterUI



--player sounds and related variables
local ammoCollectSound
local reloadSound
local reloadSoundToggle = false
local shootSound
local killFoxSound
local killBirdSound

-- Variables used for the rayCast
local RayHitList = {}
local shootingRange = 400 --400
local shootingAmplitude = 45 --45
local shootingRays = 11 --11
local rays

--Camera dragging
local MaxCameraDisplacment = vector2.new(0, 0)
local targetToFollowX, targetToFollowY

function Noknockback()

    if love.keyboard.isDown("s") and knockbacktoggletimer <=0 and knockbacktoggle == false then

        knockbacktoggle = true
        knockbacknegx = 0
        knockbackposx = 0
        knockbacky = 0
        knockbacktoggletimer = 1
    elseif love.keyboard.isDown("s") and knockbacktoggle==true and knockbacktoggletimer <=0 then

            knockbacktoggle = false
            knockbacknegx = -1200
            knockbackposx = 1200
            knockbacky = -2800
            knockbacktoggletimer = 1
        end
end

function Updatetoggletimer(dt)

    if knockbacktoggletimer > 0 then
        knockbacktoggletimer = knockbacktoggletimer -dt
    end
end

function LoadPlayer(world)

    ball= {}
    ball.body = love.physics.newBody(world, 1000, 7542, "dynamic")
    --ball.shape = love.physics.newRectangleShape(21, 32)
    ball.shape= love.physics.newCircleShape(40)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 0) -- 1 os the density which if it's diverse than zero will impact the mass accordingly to the given shape nad it's size
    ball.body:setMass(1)
    ball.body:setFixedRotation(true)
    ball.body:setLinearDamping(2)
    ball.fixture:setUserData(ball)
    ball.name = "Player"
    ball.onground = false
    ball.ammonition = ammo
    ball.x, ball.y = ball.body:getPosition()
    playerSprite = love.graphics.newImage("/Immages/player/playerBase.png")
    gunSprite = love.graphics.newImage("/Immages/player/jun.png")

    customCursor = love.graphics.newImage("/Immages/cursor.png")
    customCursorReloading = love.graphics.newImage("/Immages/reloadingCursor.png")
    ammoCounterUI = love.graphics.newImage("/Immages/AmmoCounter.png")
    
    

    Ray = {}

    return ball
end

function LoadAmmoBox(AmmoBoxs)

    AmmoBoxes = AmmoBoxs

    -- ammoboxtrigger = {}
    -- ammoboxtrigger.body = love.physics.newBody(world,450,525,"static")
    -- ammoboxtrigger.shape = love.physics.newRectangleShape(64, 64)
    -- ammoboxtrigger.fixture = love.physics.newFixture(ammoboxtrigger.body,ammoboxtrigger.shape,2)
    -- ammoboxtrigger.fixture:setSensor (true)
    -- ammoboxtrigger.fixture:setUserData(ammoboxtrigger)
    -- ammoboxtrigger.name = "Ammo"
    -- ammoboxtrigger.type = "ammonistions"
    -- ammoboxtrigger.collected=false
    -- ammoboxtrigger.distance = 0

    AmmoBoxImg = love.graphics.newImage("Immages/AmmoBoxImg.png")

end

function LoadPlayerSounds()

    reloadSound = love.audio.newSource("/sounds/reloaddone.wav","static")
    ammoCollectSound = love.audio.newSource("/sounds/ammopickup.wav", "static")
    shootSound = love.audio.newSource("/sounds/explosion.wav", "static" )
    killFoxSound = love.audio.newSource("/sounds/foxtrim.wav", "static")
    killBirdSound = love.audio.newSource("/sounds/crow.wav", "static")

end

function UsingCameraCoordinate()
    -- Mouse - Plyaer usign camera coordinates

    local ball_x, ball_y = camera:toCameraCoords(ball.body:getPosition())
    local diffCoordX = love.mouse.getX() - ball_x
    local diffCoordY = love.mouse.getY() - ball_y
    local PlayerDirectionUsingCameraCoordinates = vector2.new(diffCoordX, diffCoordY)

    return PlayerDirectionUsingCameraCoordinates
end

function PlayerPosition()
    ball.x, ball.y = ball.body:getPosition()

    return ball.x, ball.y
end

function Infiniteammo(dt)

    if love.keyboard.isDown("a") then
        anmmoConsumption = false
    end
end

function displayTable(table)
    for key, value in pairs(table) do
        if type(value) == "table" then
            -- If the value is another table, recursively display its content
            print(key .. ":")
            displayTable(value)
        else
            -- Print key-value pairs
            print(key .. ": " .. tostring(value))
        end
    end
    print("\n")
end

-- function DistancePlayerObj(list)
--     local playerX = list[1].x
--     local playerY = list[1].x
--     local playerT = list[1].fixture

--     for _, fixture in ipairs(list) do
--         print("Name:", fixture.fixture)
--         print("X Coordinate:", list.x)
--         print("Y Coordinate:", list.y)
--         print("----")
--     end

-- end

function UpdatePlayer(dt, camera, world, CurrentState)
    -- Binds the camera to the player position
    targetToFollowX, targetToFollowY = ball.body:getPosition()
    

    --Updates the ball.x and ball.y used for the enemy
    PlayerPosition()

    --
    if timer > 0 then --timer function
        timer = timer-dt
    end

    if reloadSoundToggle==true and timer <= 0.438 then
        love.audio.play(reloadSound)
        reloadSoundToggle = false
    end


    DirecitonalVector = UsingCameraCoordinate()

    rotation = math.atan2(DirecitonalVector.y, DirecitonalVector.x)
    local shootingRangeVector = vector2.new(shootingRange, 0)
    MaxCameraDisplacment = vector2.rotation(shootingRangeVector, math.rad(rotation))
    --MaxCameraDisplacment = vector2.add(MaxCameraDisplacment, vector2.new(ball.body:getPosition()))

    --Player movemnts Using CAMERA as a reference
    if love.mouse.isDown(1) and timer <= 0 and ammo > 0 then
        
        love.audio.play(shootSound)
        reloadSoundToggle=true
        -- Calculating the angle between a given number of rays and its amplitude    
    
        local rayAngleIncrement = shootingAmplitude / (shootingRays - 1)
        local endIndex = math.floor((shootingRays - 1) / 2)
        local startIndex = -endIndex
    
        rays = {}
        for i = startIndex, endIndex, 1 do
            local ray = vector2.new(shootingRange, 0)
            ray = vector2.rotation(ray, math.rad(i * rayAngleIncrement) + rotation)
            local ballPositionX, ballPositionY = ball.body:getPosition()
            ray = vector2.add(ray, vector2.new(ballPositionX, ballPositionY))
            table.insert(rays, ray)
            --displayTable(ray)
            --print(i * rayAngleIncrement + math.deg(rotation), " ", ray.x, " ", ray.y)
        end


        -- Resets the Ray hit lists

        -- Cycles through all the correctly rotated table of rays
        for i = 1, #rays, 1 do
            -- ray casting
            world:rayCast( ball.x, ball.y, rays[i].x, rays[i].y, WorldRayCastCallback)
            -- finding the distance -> sprting the table using the distance -> chekcing if enemies can be killed
            FindDistance(RayHitList)
            SortTable(RayHitList)
            SearchValue(RayHitList)

            RayHitList = {}
        end

        

        if vector2.magnitude(DirecitonalVector) > 2 then

            DirecitonalVector = vector2.normalize(DirecitonalVector)
            ball.body:setLinearVelocity(0,0)
            local velocity =  vector2.mult(DirecitonalVector, -3300)

            local ball_x, ball_y = camera:toCameraCoords(ball.body:getPosition())
            print(velocity.y)

            if love.mouse.getY() <= ball_y then
                ball.body:applyLinearImpulse(velocity.x, velocity.y)
            else
                velocity.y = velocity.y - 200
                print(velocity.y)
                ball.body:applyLinearImpulse(velocity.x, velocity.y )
            end
            
        else
            ball.body:setLinearVelocity(0,0)
        end

        if anmmoConsumption then
            ammo=ammo - 1
        end
        
        timer = 1.3  --1.5 reload timer
        DisplayShootingZone = true
    end
    
    if love.mouse.isDown(2) then
        targetToFollowX, targetToFollowY = MoveCamera(MaxCameraDisplacment, camera)
    end

    camera:follow(targetToFollowX, targetToFollowY, rotation)


    local contacts =  ball.body:getContacts()

    if #contacts == 0 then
        ball.onground = false
    else
        local groundcontact = false
        for i = 1, #contacts, 1 do
            local normal = vector2.new(contacts[i]:getNormal())
            if normal.y == -1 then
                groundcontact = true
            end
        end

        ball.onground = groundcontact
    end



    if ammo == 0 and ball.body:getLinearVelocity() == 0 then
        Stranded = true
        CurrentState = STATE_STRANDED
    end

    if cheats == false then
        KeyPressedPlyaer(world)
    end


    return 1
end

function MoveCamera(MaxCameraDisplacment, camera, rotation)
    --Will check for the camera to not move outside the said range, the one of the shootingRange
    --local ActualCameraDisplacment = vector2.new(MaxCameraDisplacment)

    --mouse position
    local Wx, Wy = camera:getMousePosition()
    print(Wx, " ", Wy)
    local PlayerPos = vector2.new(ball.body:getPosition())
    -- ball - mouse
    -- local playerToMouseX = Wx - PlayerPos.x 
    -- local playerToMouseY = Wy - PlayerPos.y
    -- local playerToMouse = vector2.new(playerToMouseX, playerToMouseY)
    -- local yes = vector2.add(playerToMouse, PlayerPos)
    local yes1 = vector2.new(Wx, Wy)

    local correctMAxCameraDisplacent = vector2.new(0, 0)
    correctMAxCameraDisplacent = vector2.add(MaxCameraDisplacment, PlayerPos)
    -- correctMAxCameraDisplacent = vector2.rotation(correctMAxCameraDisplacent, rotation)

----------------- vettore associato alla posizione del mouse, controllo se la magnitudo supera la posizione detta se si, allora con un vettore preciiso sommato alla posizione del player
    local camMove = vector2.new(shootingRange, 0)
    camMove = vector2.rotation(camMove, math.rad(rotation))
    local ballPositionX, ballPositionY = ball.body:getPosition()
    camMove = vector2.add(camMove, vector2.new(ballPositionX, ballPositionY))
    local m = vector2.magnitude(camMove)

    --print("playerToMouse ", playerToMouse.x, " ", playerToMouse.y)

    local MouseLength = vector2.magnitude(yes1)

    local finalValueX, finalValueY
    -- local MagnitudeOfTheDisplacment 
    -- local PushingLength = playerToMouse

    if vector2.magnitude(yes1) > shootingRange then

        finalValueX = camMove.x
        finalValueY = camMove.y

        --yes = correctMAxCameraDisplacent
    end

    -- targetToFollowX = PushingLength.x
    -- targetToFollowY = PushingLength.y

    targetToFollowX = finalValueX.x
    targetToFollowY = finalValueY.y

    --print("Target", targetToFollowX, targetToFollowY)

    -- targetToFollowX = Wx
    -- targetToFollowY = Wy

    
    --camera:follow(targetToFollowX, targetToFollowY)

    return targetToFollowX, targetToFollowY
end


function WorldRayCastCallback(fixture, x, y, xn, yn, fraction)

    local hit = {}
	hit.reference = fixture:getUserData()
    
    if fixture:getUserData().type == "terrain" or fixture:getUserData().type == "enemy" then-- enmey x,y expressed in world coordinate
        fixture:getUserData().x = x
        fixture:getUserData().y = y        

        table.insert(RayHitList,hit)
    end

	return 1 -- Continues with ray cast through all shapes.
end


function FindDistance(items)
    local firstItem = {reference = ball}

    for i = 1, #items do

        local currentItem = items[i]
        local distance = CalculateDistance(firstItem.reference.x, firstItem.reference.y, currentItem.reference.x, currentItem.reference.y)
        --print("Distance between", firstItem.reference.name, "and", currentItem.reference.name, "is:", distance)
       
        items[i].reference.distance = distance
    end
end

function CalculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx^2 + dy^2)
end

function CompareDec(a, b)
    return a.reference.distance < b.reference.distance
end


function SortTable(elements)

    table.sort(elements, CompareDec)

end


function SearchValue(mainTable)

    for i = 1, #mainTable, 1 do
        if mainTable[i].reference.type == "terrain" then
            break
        else 
            if mainTable[i].reference.body:isDestroyed() == false then
                KillEnemy(mainTable[i].reference)
            end
        end
    end

    -- for _, value in ipairs(mainTable) do
    --     if value.type == "enemy" then
    --         KillEnemy(i)-- Return the name or the entire subtable depending on your needs
    --     end
    -- end
end


-- function printTable(table, indent)
--     indent = indent or 0

--     for key, value in pairs(table) do
--         if type(value) == "table" then
--             print(string.rep("  ", indent) .. key .. ":")
--             printTable(value, indent + 1)
--         else
--             print(string.rep("  ", indent) .. key .. ": " .. tostring(value))
--         end
--     end
-- end

function KeyPressedPlyaer(world)
    if love.keyboard.isDown("space") then
        GravityChangin = not GravityChangin
    end

    if love.keyboard.isDown("z") then
        print(ball.body:getPosition())
    end
    
    -- if GravityChangin == false then
    --     world:setGravity( 0, 150 * love.physics.getMeter() )
    -- else
    --     world:setGravity( 0, 0 )
    -- end

    if GravityChangin == false then
        ball.body:setGravityScale(0)
    else
        ball.body:setGravityScale(1)
    end

    if love.keyboard.isDown("right") then

        local moveForce = vector2.new(2000, 0)
        ball.body:applyForce(moveForce.x, moveForce.y)
    end
    if love.keyboard.isDown("left") then

        local moveForce = vector2.new(-2000, 0)
        ball.body:applyForce(moveForce.x, moveForce.y)
    end
    if love.keyboard.isDown("up") then
        GravityChangin = false
        ball.body:setGravityScale(0)

        local jumpForce = vector2.new(0, -2000)
        ball.body:applyForce(jumpForce.x, jumpForce.y)
    end

    if love.keyboard.isDown("down") then
        --world:setGravity( 0, 70 * love.physics.getMeter() )
        local jumpForce = vector2.new(0, 2000)
        ball.body:applyForce(jumpForce.x, jumpForce.y)
    end

    if love.keyboard.isDown("q") then
        DisplayShootingZone = true
    end
end



function RotateDisplayShootingZone(mode, x, y, width, height, angle)
	-- We cannot rotate the rectangle directly, but we
	-- can move and rotate the coordinate system.
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, width-30, height/2, width-300, height) -- origin in the middle, outside the body of the ball
	love.graphics.pop()
end

function DrawPlayer()
    --love.graphics.rectangle("fill", ball.body:getX() - 21* 2, ball.body:getY() - 32* 2, 21* 4, 32* 4)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(gunSprite, ball.body:getX(), ball.body:getY() - 10*2, rotation, 4, 4, 4, 9)
    love.graphics.draw(playerSprite, ball.body:getX()- 21*2, ball.body:getY()-42*2, 0, 4, 4)


    love.graphics.setColor(243/256, 58/256, 106/256)
    --love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())

end

function DrawTrajectory()
    local Wx, Wy = camera:getMousePosition()
    love.graphics.setColor(1,0.7,0.4)
    --love.graphics.line(ball.x, ball.y, Wx, Wy)

    --add cheats to see the line between player and mouse
    --love.graphics.line(ball.x, ball.y, Wx, Wy)
end

function DrawShootingZone()

    if DisplayShootingZone == true then
        love.graphics.setColor(0,1,0)
        -- RotateDisplayShootingZone("fill", ball.x, ball.y, 1, 1, rotation)
        -- RotateDisplayShootingZone("fill", ball.x, ball.y-100, 1, 1, rotation)
        -- RotateDisplayShootingZone("fill", ball.x, ball.y+100, 1, 1, rotation)
        --love.graphics.line(ball.x, ball.y, ActualShootingRange.x, ActualShootingRange.y)
        
        for i = 1, #rays, 1 do
            love.graphics.line(ball.x, ball.y, rays[i].x, rays[i].y)
        end

        DisplayShootingZone = false
    end

end

function DrawCursor()
    -- timer che inizia a 1.35 e termina a 0

    if timer <= 0.1 then
        love.graphics.draw(customCursor, love.mouse.getX(), love.mouse.getY(), 0, 4, 4, 10, 1)
    else
        love.graphics.draw(customCursorReloading, love.mouse.getX() + 16, love.mouse.getY() + 17, 0, 4, 4, 10, 1)
    end
end

function UpdateGameStatus()
    if ammo <= 0 and Stranded == true then
        GameOver = true
    end

    return Stranded
end

function BeginContactPlayer(fixtureA, fixtureB)

    if fixtureA:getUserData().name == "Ammo" and fixtureB:getUserData().name == "Player" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")
        AmmoColleciton(fixtureA:getUserData())
        -- add collection text, +10
    end

    if fixtureA:getUserData().name == "detectionZone" and fixtureB:getUserData().name == "Player" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")
        local currentFixture = fixtureA:getUserData()

        if currentFixture.typeOfEnemy == "fox" then
            FoxUncovering(currentFixture.attachment)
        end

        if currentFixture.typeOfEnemy == "bird" then
            BirdActivating(currentFixture.attachment)
        end

    end


    if fixtureA:getUserData().name== "hurttriggerL" and fixtureB: getUserData().name == "Player" then
        ball.body:setLinearVelocity(knockbacknegx, knockbacky)
    end

    if fixtureA:getUserData().name== "hurttriggerR" and fixtureB: getUserData().name == "Player" then
        ball.body:setLinearVelocity(knockbackposx, knockbacky)

    end

    if (fixtureA:getUserData().name == "stalactite" and fixtureB:getUserData().name == "groundrock") then
        -- Say that the stalactite can't fall anymore
        fixtureA:getUserData().canFall = false
    end

    if (fixtureB:getUserData().name == "stalactite" and fixtureA:getUserData().type == "terrain") then
        fixtureB:getUserData().canFall = false
        fixtureB:getUserData().groundContact = true
    end

    -- if (fixtureB:getUserData().name == "platagrass4" and fixtureA:getUserData().name == "Player") or (fixtureA:getUserData().name == "platagrass4" and fixtureB:getUserData().name == "Player") then
    --     win = true
    --     UpdateWinCondition()
    -- end

    if fixtureA:getUserData().name== "WinningZone" and fixtureB: getUserData().name == "Player" then
        win = true
        UpdateWinCondition()
    end

    if fixtureA:getUserData().type == "terrain" and fixtureB:getUserData().name == "Player" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")
        if fixtureB:getUserData().body:getY() <= fixtureA:getUserData().body:getY() - 32 then
            if timer > 0.3 then 
                timer = 0.3
            end
            --print("Terrain contact")
        end
    end

    -- fox
    if fixtureA:getUserData().type == "enemy" and fixtureB:getUserData().name == "Player" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")
        local enemyX = fixtureA:getUserData().body:getX()
        local playerX = fixtureB:getUserData().body:getX()

        if enemyX > playerX then
            ball.body:setLinearVelocity(knockbacknegx, knockbacky)
        else
            ball.body:setLinearVelocity(-knockbacknegx, knockbacky)
        end
    end
end

function EndContactPlayer(fixtureA, fixtureB)
    if fixtureA:getUserData().name == "detectionZone" and fixtureB:getUserData().name == "Player" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")
        local currentFixture = fixtureA:getUserData()

        if currentFixture.typeOfEnemy == "fox" then
            FoxUncovering(currentFixture.attachment)
        end

        if currentFixture.typeOfEnemy == "bird" then
            BirdDeactivating(currentFixture.attachment)
        end

    end
end

function UpdateWinCondition()
    return STATE_WON
end


function KillEnemy(enemy)
    if enemy.name == "fox" then
        love.audio.play(killFoxSound)
        love.graphics.print("cock", enemy.body:getX(), enemy.body:getY())
    end

    if enemy.name == "bird" then
        love.audio.play(killBirdSound)
    end

    enemy.body:destroy()
end



function AmmoColleciton(fixtureA)
    love.audio.play(ammoCollectSound)
    ammo = ammo + 10

    AmmoCollectionFeedBack(fixtureA)

    fixtureA.body.destroy(fixtureA.body)
end


function DrawAmmoBox()
    for i = 1, #AmmoBoxes do

        local CurrentAmmoBox = AmmoBoxes[i]

        if CurrentAmmoBox.body:isDestroyed() == false then
            love.graphics.setColor(1,1,1)
            love.graphics.draw(AmmoBoxImg, CurrentAmmoBox.body:getX()-32, CurrentAmmoBox.body:getY()-32)
        end
    end
end


function AmmoCollectionFeedBack(ammoBox)

    love.graphics.setFont(love.graphics.newFont(80))
    love.graphics.print("+10", ammoBox.body:getX(), ammoBox.body:getY())
    --print("+10")

end

function DrawUI()
    local PlayerX, PlayerY = PlayerPosition()

    -- get screen width/height
    local sw = love.graphics:getWidth()
    local sh = love.graphics:getHeight()
    local uiX = ammoCounterUI:getWidth()
    local uiY = ammoCounterUI:getHeight()
    
    love.graphics.setColor(1,1,1)
    -- set font
    love.graphics.setFont(love.graphics.newFont(75))
    love.graphics.draw(ammoCounterUI, sw - uiX * 2, sh - uiY * 2, 0, 2, 2)
    if ammo >= 10 then 
        love.graphics.print(ammo, sw - uiX- 20, sh - uiY- 40, 0, 1, 1)
    else
        love.graphics.print("0 " .. ammo, sw - uiX - 30, sh - uiY- 40, 0, 1, 1)
    end
end
-- function love.mousepressed(x, y, button, istouch)
--     print("mouse pressed at: " .. x .. ", " .. y)
-- end

