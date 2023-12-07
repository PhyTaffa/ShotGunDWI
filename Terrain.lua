require "Player"

local ground , ground1
local LeftWall, RightWall
local plataforma, plataforma2, plataforma3, plataforma4
local groundrock, platarock,platarock1,platarock2,platarock3,platarock4
local platagrass,platagrass2,platagrass3,platagrass4
local ltg
local ltgLove

function LoadMap(world)

    ltg = love.graphics.newImage("ltg.png")
    ltgLove = love.graphics.newImage("ltgLove.png")

    ground = {}
    ground.body = love.physics.newBody(world, 200, 757, "static")
    ground.shape=love.physics.newRectangleShape(1050, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1)
    ground.fixture:setFriction(0.5)
    ground.fixture:setUserData(ground)
    ground.name = "ground"
    ground.type= "terrain"
    ground.distance=0
    --ground.fixture:setRestitution(0.01)

    ground1 = {}
    ground1.body = love.physics.newBody(world, 1100, 757, "static")
    ground1.shape=love.physics.newRectangleShape(800, 50)
    ground1.fixture = love.physics.newFixture(ground1.body, ground1.shape, 1)
    ground1.fixture:setFriction(0.05)
    ground1.fixture:setUserData(ground1)
    ground1.name = "ground1"
    ground1.type= "terrain"
    ground1.distance=0

    groundrock = {}
    groundrock.body = love.physics.newBody(world, 1900, 757, "static")
    groundrock.shape=love.physics.newRectangleShape(800, 50)
    groundrock.fixture = love.physics.newFixture(groundrock.body, groundrock.shape, 1)
    groundrock.fixture:setFriction(0.2)
    groundrock.fixture:setUserData(groundrock)
    groundrock.name = "groundrock"
    groundrock.type= "terrain"
    groundrock.distance=0

    platagrass = {}
    platagrass.body = love.physics.newBody(world, 1850, 715, "static")
    platagrass.shape=love.physics.newRectangleShape(400,50)
    platagrass.fixture = love.physics.newFixture(platagrass.body, platagrass.shape, 1)
    platagrass.fixture:setFriction(0.5)
    platagrass.fixture:setUserData(platagrass)
    platagrass.name = "platagrass"
    platagrass.type= "terrain"
    platagrass.distance=0

    plataforma = {}
    plataforma.body = love.physics.newBody(world, 2000, 665, "static")
    plataforma.shape=love.physics.newRectangleShape(400,50)
    plataforma.fixture = love.physics.newFixture(plataforma.body, plataforma.shape, 1)
    plataforma.fixture:setFriction(0.05)
    plataforma.fixture:setUserData(plataforma)
    plataforma.name = "plataforma"
    plataforma.type= "terrain"
    plataforma.distance=0

    plataforma2 = {}
    plataforma2.body = love.physics.newBody(world, 600, 275, "static")
    plataforma2.shape=love.physics.newRectangleShape(500,50)
    plataforma2.fixture = love.physics.newFixture(plataforma2.body, plataforma2.shape, 1)
    plataforma2.fixture:setFriction(0.05)
    plataforma2.fixture:setUserData(plataforma2)
    plataforma2.name = "plataforma2"
    plataforma2.type= "terrain"
    plataforma2.distance=0

    platagrass2 = {}
    platagrass2.body = love.physics.newBody(world, 1200, 135, "static")
    platagrass2.shape=love.physics.newRectangleShape(300, 50)
    platagrass2.fixture = love.physics.newFixture(platagrass2.body, platagrass2.shape, 1)
    platagrass2.fixture:setFriction(0.5)
    platagrass2.fixture:setRestitution(0)
    platagrass2.fixture:setUserData(platagrass2)
    platagrass2.name = "platagrass2"
    platagrass2.type= "terrain"
    platagrass2.distance=0

    plataforma3 = {}
    plataforma3.body = love.physics.newBody(world, 50,100, "static")
    plataforma3.shape=love.physics.newRectangleShape(270,50)
    plataforma3.fixture = love.physics.newFixture(plataforma3.body, plataforma3.shape, 1)
    plataforma3.fixture:setFriction(0.05)
    plataforma3.fixture:setUserData(plataforma3)
    plataforma3.name = "plataforma3"
    plataforma3.type= "terrain"
    plataforma3.distance=0

    plataforma4 = {}
    plataforma4.body = love.physics.newBody(world, 600, 40, "static")
    plataforma4.shape=love.physics.newRectangleShape(250,50)
    plataforma4.fixture = love.physics.newFixture(plataforma4.body, plataforma4.shape, 1)
    plataforma4.fixture:setFriction(0.05)
    plataforma4.fixture:setUserData(plataforma4)
    plataforma4.name = "plataforma4"
    plataforma4.type= "terrain"
    plataforma4.distance=0

    platagrass3 = {}
    platagrass3.body = love.physics.newBody(world,200, -140, "static")
    platagrass3.shape=love.physics.newRectangleShape(250,50)
    platagrass3.fixture = love.physics.newFixture(platagrass3.body, platagrass3.shape, 1)
    platagrass3.fixture:setFriction(0.5)
    platagrass3.fixture:setUserData(platagrass3)
    platagrass3.name = "platagrass3"
    platagrass3.type= "terrain"
    platagrass3.distance=0

    --fianl one
    platagrass4 = {}
    platagrass4.body = love.physics.newBody(world, 2550, -905, "static")
    platagrass4.shape=love.physics.newRectangleShape(1000,50)
    platagrass4.fixture = love.physics.newFixture(platagrass4.body, platagrass4.shape, 1)
    platagrass4.fixture:setFriction(0.5)
    platagrass4.fixture:setUserData(platagrass4)
    platagrass4.name = "platagrass"
    platagrass4.type= "terrain"
    platagrass4.distance=0

    --rock
    platarock = {}
    platarock.body = love.physics.newBody(world, 1800, 250, "static")
    platarock.shape=love.physics.newRectangleShape(250, 50)
    platarock.fixture = love.physics.newFixture(platarock.body, platarock.shape, 1)
    platarock.fixture:setFriction(0.2)
    platarock.fixture:setUserData(platarock)
    platarock.name = "groundrock"
    platarock.type= "terrain"
    platarock.distance=0

    platarock1 = {}
    platarock1.body = love.physics.newBody(world, 2150, 450, "static")
    platarock1.shape=love.physics.newRectangleShape(250, 50)
    platarock1.fixture = love.physics.newFixture(platarock1.body, platarock1.shape, 1)
    platarock1.fixture:setFriction(0.2)
    platarock1.fixture:setUserData(platarock1)
    platarock1.name = "groundrock"
    platarock1.type= "terrain"
    platarock1.distance=0

    platarock2 = {}
    platarock2.body = love.physics.newBody(world, 650, -350, "static")
    platarock2.shape=love.physics.newRectangleShape(900, 50)
    platarock2.fixture = love.physics.newFixture(platarock2.body, platarock2.shape, 1)
    platarock2.fixture:setFriction(0.2)
    platarock2.fixture:setUserData(platarock2)
    platarock2.name = "groundrock"
    platarock2.type= "terrain"
    platarock2.distance=0

    platarock3 = {}
    platarock3.body = love.physics.newBody(world, 1400, -500, "static")
    platarock3.shape=love.physics.newRectangleShape(250, 50)
    platarock3.fixture = love.physics.newFixture(platarock3.body, platarock3.shape, 1)
    platarock3.fixture:setFriction(0.2)
    platarock3.fixture:setUserData(platarock3)
    platarock3.name = "groundrock"
    platarock3.type= "terrain"
    platarock3.distance=0

    platarock4 = {}
    platarock4.body = love.physics.newBody(world, 1800, -670, "static")
    platarock4.shape=love.physics.newRectangleShape(250, 50)
    platarock4.fixture = love.physics.newFixture(platarock4.body, platarock4.shape, 1)
    platarock4.fixture:setFriction(0.2)
    platarock4.fixture:setUserData(platarock4)
    platarock4.name = "groundrock"
    platarock4.type= "terrain"
    platarock4.distance=0
    



    --Walls

    LeftWall = {}
    LeftWall.body = love.physics.newBody(world, -95, 300, "static")
    LeftWall.shape=love.physics.newRectangleShape(10, 900)
    LeftWall.fixture = love.physics.newFixture(LeftWall.body, LeftWall.shape, 1)
    LeftWall.fixture:setRestitution(1)
    LeftWall.fixture:setUserData(LeftWall)
    LeftWall.name = "LeftWall"
    LeftWall.type= "terrain"
    LeftWall.distance=0

    RightWall = {}
    RightWall.body = love.physics.newBody(world, 2300, 300, "static")
    RightWall.shape=love.physics.newRectangleShape(10, 1000)
    RightWall.fixture = love.physics.newFixture(RightWall.body, RightWall.shape, 1)
    RightWall.fixture:setRestitution(0.5)
    RightWall.fixture:setUserData(RightWall)
    RightWall.name = "RightWall"
    RightWall.type= "terrain"
    RightWall.distance=0

    WinningZone = {}
    WinningZone.body = love.physics.newBody(world, 2550, -905, "static")
    WinningZone.shape=love.physics.newRectangleShape(100, 200)
    WinningZone.fixture = love.physics.newFixture(WinningZone.body, WinningZone.shape, 1)
    WinningZone.fixture:setRestitution(0.5)
    WinningZone.fixture:setSensor(true)
    WinningZone.fixture:setUserData(WinningZone)
    WinningZone.name = "WinningZone"
    WinningZone.type= "trigger"
    WinningZone.distance=0





end

function DrawMap()

    love.graphics.setBackgroundColor(0.4,0.4,0.4)

    --Walls
    love.graphics.setColor(1,0,1)
    love.graphics.polygon("fill", LeftWall.body:getWorldPoints(LeftWall.shape:getPoints()))
    love.graphics.polygon("fill", RightWall.body:getWorldPoints(RightWall.shape:getPoints()))
    
    --Grass Terrain
    love.graphics.setColor(0.2,0.4,0)
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
    love.graphics.polygon("fill", platagrass.body:getWorldPoints(platagrass.shape:getPoints()))
    love.graphics.polygon("fill", platagrass2.body:getWorldPoints(platagrass2.shape:getPoints()))
    love.graphics.polygon("fill", platagrass3.body:getWorldPoints(platagrass3.shape:getPoints()))
    love.graphics.polygon("fill", platagrass4.body:getWorldPoints(platagrass4.shape:getPoints()))

    --Ice Terrain
    love.graphics.setColor(0,0,0.5)
    love.graphics.polygon("fill", ground1.body:getWorldPoints(ground1.shape:getPoints()))
    love.graphics.polygon("fill", plataforma.body:getWorldPoints(plataforma.shape:getPoints()))
    love.graphics.polygon("fill", plataforma2.body:getWorldPoints(plataforma2.shape:getPoints()))
    love.graphics.polygon("fill", plataforma3.body:getWorldPoints(plataforma3.shape:getPoints()))
    love.graphics.polygon("fill", plataforma4.body:getWorldPoints(plataforma4.shape:getPoints()))
    
    --Rock Terrain
    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.polygon("fill", groundrock.body:getWorldPoints(groundrock.shape:getPoints()))
    love.graphics.polygon("fill", platarock.body:getWorldPoints(platarock.shape:getPoints()))
    love.graphics.polygon("fill", platarock1.body:getWorldPoints(platarock1.shape:getPoints()))
    love.graphics.polygon("fill", platarock2.body:getWorldPoints(platarock2.shape:getPoints()))
    love.graphics.polygon("fill", platarock3.body:getWorldPoints(platarock3.shape:getPoints()))
    love.graphics.polygon("fill", platarock4.body:getWorldPoints(platarock4.shape:getPoints()))
end



function GamingOver()
    local ballX, ballY = PlayerPosition()

    love.graphics.setColor(1,1,1)
    love.graphics.print("Your life is nothing, you serve zero purpose.\nYou should kill yourself, NOW!", ballX-400, ballY-300,0,2,2)
    love.graphics.draw(ltg, ballX-400, ballY-200)

end

function Winning()
    local ballX, ballY = PlayerPosition()

    love.graphics.setColor(1,1,1)
    love.graphics.print("Your life is nothing, you serve zero purpose.\nYou should Love yourself, NOW! \n jk", ballX-400, ballY-300,0,2,2)
    love.graphics.draw(ltgLove, ballX-400, ballY-200)

end

