require "vector2"
require "GameState"

local ball
local ShootingTimer = 0.5
local radius = 40
local Stranded = false
local CanThePlayerWin = false
local ammo = 30
local DisplayShootingZone = false

--Enemy pusheback force
local knockbacky = -1200
local knockbacknegx = -1200


local cheats= false
local GravityChangin = true
local rotation = 0
local anmmoConsumption = true

--tiled table
local AmmoBoxes
local WinPostion

--Tiled imgs
local AmmoBoxImg
local playerSprite
local gunSprite
local customCursor
local customCursorReloading
local ammoCounterUI
local ShootingBlast



--player sounds and related variables
local ammoCollectSound
local reloadSound
local reloadSoundToggle = false
local shootSound
local killFoxSound
local killBirdSound
local stalactiteFall
local stalactiteDeath

-- Variables used for the rayCast
local RayHitList = {}
local shootingRange = 400 --400
local shootingAmplitude = 45 --45
local shootingRays = 11 --11
local rays

--Camera dragging
local targetToFollowX, targetToFollowY




----------LOADING VARIOUS ELEMENTS
function LoadPlayer(world)

    ball = {}
    ball.body = love.physics.newBody(world, 1000, 7542, "dynamic")
    ball.shape = love.physics.newCircleShape(radius)
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
    gunSprite = love.graphics.newImage("/Immages/player/gun.png")

    customCursor = love.graphics.newImage("/Immages/cursor.png")
    customCursorReloading = love.graphics.newImage("/Immages/reloadingCursor.png")
    ammoCounterUI = love.graphics.newImage("/Immages/AmmoCounter.png")
    ShootingBlast = love.graphics.newImage("/Immages/player/shotgunblast.png")
    
    

    Ray = {}

    return ball
end

function LoadAmmoBox(AmmoBoxs, WinZone)

    AmmoBoxes = AmmoBoxs

    AmmoBoxImg = love.graphics.newImage("Immages/AmmoBoxImg.png")

    WinPostion = WinZone

end

function LoadPlayerSounds()

    reloadSound = love.audio.newSource("/sounds/reloaddone.wav", "static")
    ammoCollectSound = love.audio.newSource("/sounds/ammopickup.wav", "static")
    shootSound = love.audio.newSource("/sounds/explosion.wav", "static" )
    killFoxSound = love.audio.newSource("/sounds/foxkillsound.wav", "static")
    killBirdSound = love.audio.newSource("/sounds/birdkillsound.wav", "static")

    stalactiteFall = love.audio.newSource("/sounds/crack.wav", "static")
    stalactiteDeath = love.audio.newSource("/sounds/stalabreak.wav", "static")

end



------------------------ PLAYER MOVEMENT
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


function UpdatePlayer(dt, camera, world)
    -- Binds the camera to the player position
    targetToFollowX, targetToFollowY = ball.body:getPosition()
    

    --Updates the ball.x and ball.y used for the enemy
    PlayerPosition()

    --
    if ShootingTimer > 0 then --ShootingTimer function
        ShootingTimer = ShootingTimer-dt
    end


    --plays the reload timer before you can shoot and also stops the shooting sound and fixes a bug where rapid shooting repetition where missing sound
    if reloadSoundToggle == true and ShootingTimer <= 0.438 then
        love.audio.stop(shootSound)
        love.audio.play(reloadSound)
        reloadSoundToggle = false

        DisplayShootingZone = false
    end


    --Makes the shooting balst being seen for longer than just a frame
    if ShootingTimer <= 1.2 then
        DisplayShootingZone = false
    end


    DirecitonalVector = UsingCameraCoordinate()

    rotation = math.atan2(DirecitonalVector.y, DirecitonalVector.x)
    local CameraDisplacment = vector2.new(0, 0)


    -- Calculating the angle between a given number of rays and its amplitude    
    -- Resets the Ray hit lists

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
        if i == 0 then
            CameraDisplacment = ray
        end
        --print(i * rayAngleIncrement + math.deg(rotation), " ", ray.x, " ", ray.y)
    end


    --Player movemnts Using CAMERA as a reference
    if love.mouse.isDown(1) and ShootingTimer <= 0 and ammo > 0 then
        
        love.audio.play(shootSound)
        reloadSoundToggle=true

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
            --print(velocity.y)

            if love.mouse.getY() <= ball_y then
                ball.body:applyLinearImpulse(velocity.x, velocity.y)
            else
                velocity.y = velocity.y - 200
                --print(velocity.y)
                ball.body:applyLinearImpulse(velocity.x, velocity.y )
            end
            
        else
            ball.body:setLinearVelocity(0,0)
        end

        if anmmoConsumption then
            ammo=ammo - 1
        end
        
        DisplayShootingZone = true
        ShootingTimer = 1.3  --1.5 reload ShootingTimer
    end
    
    if love.mouse.isDown(2) then
        targetToFollowX, targetToFollowY = MoveCamera(CameraDisplacment.x, CameraDisplacment.y)
    end

    camera:follow(targetToFollowX, targetToFollowY)


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

        -- there should be a ShootingTimer and a possible fade in for the Death screen

        ChangeGameState(STATE_STRANDED)
    end

    if cheats == false then
        KeyPressedPlyaer()
    end

    if GravityChangin == false then
        ball.body:setGravityScale(0)
    else
        ball.body:setGravityScale(1)
    end

end

function MoveCamera(CameraDisplacmentX, CameraDisplacmentY)
    --Will check for the camera to not move outside the said range, the one of the shootingRange


    --mouse position
    local Wx, Wy = camera:getMousePosition()
    local PlayerPos = vector2.new(ball.body:getPosition())
    -- ball - mouse
    local playerToMouseX = Wx - PlayerPos.x 
    local playerToMouseY = Wy - PlayerPos.y
    local playerToMouse = vector2.new(playerToMouseX, playerToMouseY)
    -- ^ this part is similar to getting the player position
    -- |


    -- associating the camera min position as a vector
    local Camera = vector2.new(CameraDisplacmentX, CameraDisplacmentY)


    -- finding the magnitude for checking purposes
    local MaxDisplacmentMagnitude = vector2.magnitude(Camera)
    local playerToMouseMagnitude =  vector2.magnitude(playerToMouse)


    -- natural followinf position, the coordinates of the mosue
    local targetX = playerToMouse.x
    local targetY = playerToMouse.y


    -- if the mouse is inside the circle, it gets moved and makes the camera works(as intended btw[completely not luck])
    if playerToMouseMagnitude < MaxDisplacmentMagnitude - 300 then
        -- changes teh values accordingly
        targetX = Camera.x
        targetY = Camera.y
    end

    -- returns them to be used for the camera:follow
    return targetX, targetY
end

------------------------- RAY CASTING------------------------------
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

end


-------------------------------------------------KEYBOARD PRESSES ONCE OR MULTIPLE TIMES
function KeyPressedPlayer(key)
    if key == "space" then
        GravityChangin = not GravityChangin
    end

    if love.keyboard.isDown("a") then
        anmmoConsumption = not anmmoConsumption
    end

    if key == "e" and ball.body:getLinearVelocity() == 0 and CanThePlayerWin == true then
        CanThePlayerWin = true
        ChangeGameState(STATE_WON)
    end
end

function KeyPressedPlyaer()

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
        DisplayShootingZoneCheat = true

    end


end






-----------------DRAWINGS
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
    -- Gun being drawed before the player since it's supposed to rotate behind him
    love.graphics.draw(gunSprite, ball.body:getX(), ball.body:getY(), rotation, 1, 1, 0, 34)
    -- Player drawing
    love.graphics.draw(playerSprite, ball.body:getX()- 21*2, ball.body:getY()-42*2, 0)


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
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(ShootingBlast, ball.body:getX(), ball.body:getY() - ShootingBlast:getHeight()/2 + ShootingBlast:getHeight()/2, rotation, 1 ,1, -radius - gunSprite:getWidth()/2 ,ShootingBlast:getHeight()/2)

    end

end

function DrawShootingZoneCheat()
    love.graphics.setColor(0,1,0)

    if DisplayShootingZoneCheat then
        for i = 1, #rays, 1 do
            love.graphics.line(ball.x, ball.y, rays[i].x, rays[i].y)
        end
    end
    DisplayShootingZoneCheat = false
end

function DrawCursor()
    -- ShootingTimer che inizia a 1.35 e termina a 0
    love.mouse.setVisible(false)
    if ShootingTimer <= 0.1 then
        love.graphics.draw(customCursor, love.mouse.getX() - customCursor:getWidth()/2, love.mouse.getY() - customCursor:getHeight()/2)
    else
        love.graphics.draw(customCursorReloading, love.mouse.getX() - customCursorReloading:getWidth()/2, love.mouse.getY() - customCursorReloading:getHeight()/2)
    end
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



-----------------------STATE CHEKING ---------------------
function UpdateGameStatus()
    if ammo <= 0 and Stranded == true then
        GameOver = true
    end

    return Stranded
end


function UpdateWinCondition()
    return STATE_WON
end





---------------------------- COLLISION DETECTION -----------------------------
------------------------- EVERYTHING HAS BEEN DONE HERE

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
            currentFixture.attachment.soundTimer = 0
        end

        if currentFixture.typeOfEnemy == "stalactite" then
            CanStalFall(currentFixture.attachment)
            if currentFixture.attachment.body:isDestroyed() == false then
                love.audio.play(stalactiteFall)
            end
        end

    end

    if fixtureA:getUserData().name == "WinZone" and fixtureB:getUserData().name == "Player" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")
        -- cahnges a flag so that in the pressing key it is activated
        CanThePlayerWin = true
        

    end

    if fixtureA:getUserData().type == "terrain" and fixtureB:getUserData().name == "Player" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")
        if fixtureB:getUserData().body:getY() <= fixtureA:getUserData().body:getY() - 32 then
            if ShootingTimer > 0.3 then 
                ShootingTimer = 0.3
            end
            --print("Terrain contact")
        end
    end

    if fixtureA:getUserData().type == "terrain" and fixtureB:getUserData().name == "stalactite" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")
        if fixtureB:getUserData().body:getY() <= fixtureA:getUserData().body:getY() - 32 then -- stalactite on top of the terrain
            fixtureB:getUserData().body:destroy()
            love.audio.play(stalactiteDeath)
        end
    end

    -- Generic enemy pushback
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



    if fixtureA:getUserData().name == "WinZone" and fixtureB:getUserData().name == "Player" then --or (fixtureA:getUserData().name == "ball" and fixtureB:getUserData().name == "Ammo")

        -- changes a flag so that in the pressing key it is activated
        CanThePlayerWin = false

    end
end



--------------------FUNCTION OF COLLISIONS/ RAYCASTING--------------
function KillEnemy(enemy)
    if enemy.name == "fox" then
        love.audio.play(killFoxSound)
        --love.graphics.print("cock", enemy.body:getX(), enemy.body:getY())
    end

    if enemy.name == "bird" then
        love.audio.play(killBirdSound)
    end
    if enemy.name == "stalactite" then
        love.audio.play(stalactiteFall)
    end

    enemy.body:destroy()
end



function AmmoColleciton(fixtureA)
    love.audio.play(ammoCollectSound)
    ammo = ammo + 10

    AmmoCollectionFeedBack(fixtureA)

    fixtureA.body.destroy(fixtureA.body)
end


function PlaceFlag()
    love.graphics.setColor(1,1,1)
    if CanThePlayerWin then
       love.graphics.draw(WinPostion.img, WinPostion.body:getX()- WinPostion.img:getWidth()/2, WinPostion.body:getY() - WinPostion.img:getHeight()/2)
    end

    

end