require "vector2"
camera = require "Camera"
require "Player"
require "Terrain"
require "Enemy"
require "GameState"


local world
local Stranded = false
local win = false
local ball

-- Game States
STATE_IN_GAME = 1
STATE_OPTIONS = 2
STATE_MAIN_MENU = 3
STATE_WON = 4
STATE_STRANDED = 5
STATE_IN_GAME_MENU = 6
STATE_CREDITS = 7

local CurrentState = STATE_MAIN_MENU
-- tiled implementation, should be moved away from the main
local sti = require "sti"
local map
local Boundries = {}
local grassPlatforms = {}
local rockPlatforms = {}
local icePlatforms = {}
local GroundObjs = {}
local AmmoBoxs = {}
local AmmoBoxImg
local foxes = {}
local birds = {}

local WinZone

--

--love.window.setMode( 1920, 1080)
love.window.setFullscreen(true)
function love.load()

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 70 * love.physics.getMeter(), true)

    world:setCallbacks(BeginContact, EndContact, nil, nil)

    camera = camera()
    camera:setFollowLerp(0.2)
    camera:setFollowLead(10)
    camera:setFollowStyle('NO_DEADZONE')
    camera:setBounds(0, 0, 3840, 7680)-- x,y topleft position then the Width and heigth(downwards) of the rectangle
    

    love.mouse.setVisible(true)
    love.mouse.setGrabbed(true)
    love.keyboard.setKeyRepeat(false)
  
  

    ball = LoadPlayer(world)


    LoadMap(world)
    LoadMainMenu(world)
    --LoadAmmoBox(world)

    -- tiled stuff to be moved, possibly idk if necessary to be kept on main
    map = sti("map/draft.lua", {"box2d"})
	map:box2d_init(world)
    map:addCustomLayer("Sprite Layer", 3)

	--physics objs associastion



    if map.layers['Boundries'] then

        for i, obj in pairs(map.layers['Boundries'].objects) do
            Boundary = {}


            if obj.shape == "rectangle" then

                Boundary.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "static")
                Boundary.shape = love.physics.newRectangleShape(obj.width,obj.height)
                Boundary.fixture = love.physics.newFixture(Boundary.body, Boundary.shape, 1)
                Boundary.fixture:setUserData(({reference = Boundary,type = "Boundries", index = i}))

                table.insert(Boundries, Boundary)
            end

        end
        --return Boundries, wall
    end

    if map.layers['GroundObj'] then

        for i, obj in pairs(map.layers['GroundObj'].objects) do
            local GroundObj = {}

            if obj.shape == "rectangle" then
                
                GroundObj.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "static")
                GroundObj.shape = love.physics.newRectangleShape(obj.width,obj.height)
                GroundObj.fixture = love.physics.newFixture(GroundObj.body, GroundObj.shape, 1)
                GroundObj.fixture:setUserData(GroundObj)
                GroundObj.fixture:setFriction(0.8) -- values between 0 to 1, with the lower the more slippery
                GroundObj.index = i
                GroundObj.name = "ground"
                GroundObj.type = "terrain"
                GroundObj.distance = 0

                table.insert(GroundObjs, GroundObj)
            end
        end
    end

    if map.layers['grassPlatform'] then

        for i, obj in pairs(map.layers['grassPlatform'].objects) do
            local grassPlatform = {}

            if obj.shape == "rectangle" then
                
                grassPlatform.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "static")
                grassPlatform.shape = love.physics.newRectangleShape(obj.width,obj.height)
                grassPlatform.fixture = love.physics.newFixture(grassPlatform.body, grassPlatform.shape, 1)
                grassPlatform.fixture:setUserData(grassPlatform)
                grassPlatform.fixture:setFriction(0.8) -- values between 0 to 1, with the lower the more slippery
                grassPlatform.indes = i
                grassPlatform.name = "grass"
                grassPlatform.type = "terrain"
                grassPlatform.distance = 0

                table.insert(grassPlatforms, grassPlatform)
            end
        end
    end

    if map.layers['rockPlatform'] then

        for i, obj in pairs(map.layers['rockPlatform'].objects) do
            local rockPlatform = {}

            if obj.shape == "rectangle" then
                
                rockPlatform.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "static")
                rockPlatform.shape = love.physics.newRectangleShape(obj.width,obj.height)
                rockPlatform.fixture = love.physics.newFixture(rockPlatform.body, rockPlatform.shape, 1)
                rockPlatform.fixture:setUserData(rockPlatform)
                rockPlatform.fixture:setFriction(0.4) -- values between 0 to 1, with the lower the more slippery
                rockPlatform.index = i
                rockPlatform.name = "rock"
                rockPlatform.type = "terrain"
                rockPlatform.distance = 0

                table.insert(rockPlatforms, rockPlatform)
            end
        end
    end

    if map.layers['icePlatform'] then

        for i, obj in pairs(map.layers['icePlatform'].objects) do
            local icePlatform = {}

            if obj.shape == "rectangle" then
                
                icePlatform.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "static")
                icePlatform.shape = love.physics.newRectangleShape(obj.width,obj.height)
                icePlatform.fixture = love.physics.newFixture(icePlatform.body, icePlatform.shape, 1)
                icePlatform.fixture:setUserData(icePlatform)
                icePlatform.fixture:setFriction(0.2) -- values between 0 to 1, with the lower the more slippery
                icePlatform.index = i
                icePlatform.name = "ice"
                icePlatform.type = "terrain"
                icePlatform.distance = 0

                table.insert(icePlatforms, icePlatform)
            end
        end
    end

    --Winning Zone
    if map.layers['WinZone'] then

        for i, obj in pairs(map.layers['WinZone'].objects) do
            WinZone = {}

            if obj.shape == "rectangle" then

                WinZone.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "static")
                WinZone.shape = love.physics.newRectangleShape(obj.width,obj.height)
                WinZone.fixture = love.physics.newFixture(WinZone.body, WinZone.shape, 1)
                WinZone.fixture:setUserData(WinZone)
                WinZone.fixture:setSensor(true)
                WinZone.index = i
                WinZone.name = "WinZone"

            end

        end
    end

    --Ammonitions

    --AmmoBoxImg = love.graphics.newImage("Immages/AmmoBoxImg.png")

    if map.layers['AmmoBoxObj'] then

        for i, obj in pairs(map.layers['AmmoBoxObj'].objects) do
            AmmoBox = {}


            if obj.shape == "rectangle" then

                AmmoBox.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "static")
                AmmoBox.shape = love.physics.newRectangleShape(obj.width,obj.height)
                AmmoBox.fixture = love.physics.newFixture(AmmoBox.body, AmmoBox.shape, 1)
                AmmoBox.fixture:setUserData(AmmoBox)
                AmmoBox.fixture:setSensor(true)
                AmmoBox.index = i
                AmmoBox.name = "Ammo"
                AmmoBox.type = "collectible"
                AmmoBox.collected = false
                AmmoBox.distance = 0

                table.insert(AmmoBoxs, AmmoBox)
            end

        end
        --return Boundries, wall
    end

    LoadAmmoBox(AmmoBoxs)

    -- Enemies:
    --         Bird
    if map.layers['FoxObj'] then

        for i, obj in pairs(map.layers['FoxObj'].objects) do
            local fox = {}

            if obj.shape == "rectangle" then

                fox.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "dynamic")
                fox.shape = love.physics.newRectangleShape(obj.width,obj.height)
                fox.fixture = love.physics.newFixture(fox.body, fox.shape, 1)
                fox.fixture:setUserData(fox)
                fox.body:setFixedRotation(true)
                fox.fixture:setFriction(1)
                fox.index = i
                fox.name = "fox"
                fox.type = "enemy"
                fox.distance = 0
                fox.Readytimer = 2.5
                fox.attackTimer = 1
                fox.uncovered = false
                fox.anim = {}
                fox.animTimer = 0
                fox.animFrame = 1
                fox.x = obj.x
                fox.y = obj.y
                fox.readyAnimTrig = false
                fox.pounceAnimTrig= false
            
                    for j = 1, 12 do
                        fox.anim[j] = love.graphics.newImage("/animations/fox_" .. j .. ".png")
                    end

                table.insert(foxes, fox)
            end
        end
    end

    if map.layers['BirdObj'] then

        for i, obj in pairs(map.layers['BirdObj'].objects) do
            local bird = {}

            if obj.shape == "rectangle" then

                bird.body = love.physics.newBody(world, obj.x + obj.width / 2, obj.y + obj.height / 2, "dynamic")
                bird.shape = love.physics.newRectangleShape(obj.width,obj.height)
                bird.fixture = love.physics.newFixture(bird.body, bird.shape, 1)
                bird.fixture:setUserData(bird)
                bird.body:setFixedRotation(true)
                bird.index = i
                bird.name = "bird"
                bird.type = "enemy"
                bird.distance = 0
                bird.body:setGravityScale(0)
                bird.body:setLinearDamping(3)
                
                bird.chasing = false
                bird.killed = false
                bird.direciton = 1
                bird.active = false
                bird.x = obj.x
                bird.y = obj.y
                bird.range = 2
                bird.viewangle = 0

                bird.uncovered = false

                bird.flyAnim = {}
                bird.animTimer = 0
                bird.animFrame = 1
            
                    for j = 1, 16 do
                        bird.flyAnim[j] = love.graphics.newImage("/animations/Flying_" .. j .. ".png")
                    end

                


                table.insert(birds, bird)
            end
        end
    end

    LoadEnemies(world, foxes, birds)
    LoadPlayerSounds()
    LoadEnemySounds()

end


function BeginContact(fixtureA,fixtureB)
    BeginContactPlayer(fixtureA, fixtureB)
end

function EndContact(fixtureA,fixtureB)
    EndContactPlayer(fixtureA, fixtureB)
end


function love.update(dt)

    CurrentState = ChangeGameState1()

    if CurrentState == STATE_IN_GAME then
        camera:update(dt)
        
        UpdatePlayer(dt, camera, world)
    


        local playerx, playery = PlayerPosition()
        UpdateEnemies(dt, playerx, playery,ball, world)

        map:update(dt)

        world:update(dt)
    end

    if CurrentState == STATE_QUIT then --winning
        love.event.quit()
    end



end

function love.draw()

    if CurrentState == STATE_IN_GAME then

        --map:drawLayer(map.layers["background"])
        

        camera:attach() 

        love.graphics.setColor(1,1,1)
        
        map:drawLayer(map.layers["background"])
        map:drawLayer(map.layers["Ground"])
        
        map:drawLayer(map.layers["florathree"])
        map:drawLayer(map.layers["floratwo"])
        map:drawLayer(map.layers["flora"])
        
        map:drawLayer(map.layers["foxbush"])
        map:drawLayer(map.layers["car"])
        map:drawLayer(map.layers["platforms"])
        --DrawMap()
        
        DrawEnemy()
        DrawAmmoBox()
        DrawPlayer()
        DrawTrajectory()
        DrawShootingZone()

        camera:detach()    
        
        DrawUI()


        DrawCursor()
        
    end

    if CurrentState == STATE_STRANDED then
        camera:attach() 

        love.graphics.setColor(1,1,1)
        
        map:drawLayer(map.layers["background"])
        map:drawLayer(map.layers["Ground"])
        
        map:drawLayer(map.layers["florathree"])
        map:drawLayer(map.layers["floratwo"])
        map:drawLayer(map.layers["flora"])
        
        map:drawLayer(map.layers["foxbush"])
        map:drawLayer(map.layers["car"])
        map:drawLayer(map.layers["platforms"])

        
        DrawEnemy()
        DrawAmmoBox()
        DrawPlayer()
        DrawTrajectory()
        DrawShootingZone()

        camera:detach()    
        
        DrawUI()
        --DrawCursor()


        GamingOver()

    end

    if CurrentState == STATE_WON then --winning
        Winning()
        --DrawCursor()
    end

    if CurrentState == STATE_MAIN_MENU then --winning
        MainMenu()

    end

    if CurrentState == STATE_IN_GAME_MENU then --In game menus
        love.graphics.setColor(1, 1, 1, 0.7) --makes evrything more opaqe so that the focus is drawn on the menu
        camera:attach() 
        
        map:drawLayer(map.layers["background"])
        map:drawLayer(map.layers["Ground"])
        
        map:drawLayer(map.layers["florathree"])
        map:drawLayer(map.layers["floratwo"])
        map:drawLayer(map.layers["flora"])
        
        map:drawLayer(map.layers["foxbush"])
        map:drawLayer(map.layers["car"])
        map:drawLayer(map.layers["platforms"])

        
        DrawEnemy()
        DrawAmmoBox()
        DrawPlayer()
        DrawTrajectory()
        DrawShootingZone()

        camera:detach()    
        
        DrawUI()
        --DrawCursor()
    end
    
end
