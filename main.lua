require "vector2"
camera = require "Camera"
require "Player"
require "Terrain"
require "Enemy"

local world
local Stranded = false
local win = false
local ball

--love.window.setMode( 900, 800)
love.window.setFullscreen(true)
function love.load()

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 70 * love.physics.getMeter(), true)

    world:setCallbacks(BeginContact, nil, nil, nil)

    camera = camera()
    camera:setFollowLerp(0.2)
    camera:setFollowLead(10)
    camera:setFollowStyle('NO_DEADZONE')

    ball = LoadPlayer(world)

    LoadEnemies(world)

    LoadMap(world)
    LoadAmmoBox(world)


end


function BeginContact(fixtureA,fixtureB)
    BeginContactPlayer(fixtureA, fixtureB)
end


function love.update(dt)
    camera:update(dt)
    
    UpdatePlayer(dt,camera,world)
    UpdateTriggerPosition()
    Stranded = UpdateGameStatus()
    win = UpdateWinCondition()

    -- if love.keyboard.isDown("e") then
    --     Difference = vector2.new(PlayerPosition()-EnemyPosition())
    --     print(Difference.x," ", Difference.y,"\n")
    -- end
    local playerx, playery = PlayerPosition()
    UpdateEnemies(dt, playerx, playery,ball)

    --cheats
    FoxBehaviour(dt)
    Infiniteammo(dt)
    Updatetoggletimer(dt)
    Noknockback()

    world:update(dt)
end

function love.draw()

    camera:attach() 
    love.graphics.push()
    --love.graphics.translate(100,100)

    if win == false then
        if Stranded == false then-- everything that is displayed during the game session
            
            DrawMap()
            DrawAmmoBox()
            DrawEnemy()

            DrawPlayer()
            DrawTrajectory()
            DrawShootingZone()
            DrawUI()

        love.graphics.pop()
        camera:detach()    

        else--what you see when you die
            GamingOver()
            love.graphics.pop()
            camera:detach()
        end

        else --winning
            Winning()
            love.graphics.pop()
            camera:detach()
    end

end
