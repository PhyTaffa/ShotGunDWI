require "vector2"
camera = require "Camera"
require "Player"
require "Terrain"
require "Enemy"


local world
local Stranded = false
local win = false
local ball

-- Game States
STATE_IN_GAME = 1
STATE_MAIN_MENU = 2
STATE_WON = 3
STATE_STRANDED = 4
STATE_IN_GAME_MENU = 5
STATE_CREDITS = 6

local CurrentState = STATE_IN_GAME
-- tiled implementation, should be moved away from the main
local sti = require "sti"
local Boundries = {}
local grassPlatforms = {}
local rockPlatforms = {}
local icePlatforms = {}
local GroundObjs = {}
--

love.window.setMode( 1920, 1080)
--love.window.setFullscreen(true)
function love.load()

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 150 * love.physics.getMeter(), true)

    world:setCallbacks(BeginContact, nil, nil, nil)

    camera = camera()
    camera:setFollowLerp(0.2)
    camera:setFollowLead(10)
    camera:setFollowStyle('NO_DEADZONE')
    camera:setBounds(0, 0, 3840, 7680)-- x,y topleft position then the Width and heigth(downwards) of the rectangle


    ball = LoadPlayer(world)

    LoadEnemies(world)

    LoadMap(world)
    LoadAmmoBox(world)

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


    

end


function BeginContact(fixtureA,fixtureB)
    BeginContactPlayer(fixtureA, fixtureB)
end


function love.update(dt)

    --if CurrentState == STATE_IN_GAME then
        camera:update(dt)
        
        UpdatePlayer(dt, camera, world, CurrentState)
        UpdateTriggerPosition()
        -- CurrentState = UpdateGameStatus()
        CurrentState = UpdateWinCondition()

        -- if love.keyboard.isDown("e") then
        --     Difference = vector2.new(PlayerPosition()-EnemyPosition())
        --     print(Difference.x," ", Difference.y,"\n")
        -- end
        local playerx, playery = PlayerPosition()
        UpdateEnemies(dt, playerx, playery,ball)

        --cheats
        -- FoxBehaviour(dt)
        Infiniteammo(dt)
        Updatetoggletimer(dt)
        Noknockback()

        map:update(dt)
    --end
    world:update(dt)
end

function love.draw()

    
    --love.graphics.translate(100,100)
    -- if CurrentState == STATE_IN_GAME then

        camera:attach() 
        love.graphics.push()
        map:drawLayer(map.layers["Ground"])

        map:drawLayer(map.layers["flora"])
        map:drawLayer(map.layers["car"])
        map:drawLayer(map.layers["platforms"])
            --DrawMap()
        DrawAmmoBox()
        DrawEnemy()

        DrawPlayer()
        DrawTrajectory()
        DrawShootingZone()
        

        love.graphics.pop()
        camera:detach()    
        
        DrawUI()
        
    -- end

    -- if CurrentState == STATE_STRANDED then
    --     GamingOver()
    --     love.graphics.pop()
    --     camera:detach()
    -- end
    -- if CurrentState == STATE_WON then --winning
    --     Winning()
    --     love.graphics.pop()
    --     camera:detach()
    -- end
    
end
