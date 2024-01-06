require "Player"

local ground , ground1
local LeftWall, RightWall
local plataforma, plataforma2, plataforma3, plataforma4
local groundrock, platarock,platarock1,platarock2,platarock3,platarock4
local platagrass,platagrass2,platagrass3,platagrass4
local ltg
local ltgLove
local bgm
local logo
local sw, sh
local BoxOptions = {}
local BoxOption



local xMM
local yMM = {}
local w
local h

function LoadMap(world)

    bgm = love.audio.newSource("environment.wav", "stream")
    bgm:setLooping(true)
    love.audio.play(bgm)

    ltg = love.graphics.newImage("ltg.png")
    ltgLove = love.graphics.newImage("ltgLove.png")

    logo = love.graphics.newImage("/Immages/logo.png")

    sw = love.graphics:getWidth()
    sh = love.graphics:getHeight()
    w = sw/4
    h = sh/12


    WinningZone = {}
    WinningZone.body = love.physics.newBody(world, 6848, 0, "static")
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

end

function LoadMainMenu(world)
    xMM = sw/2
    yMM[1] = sh / 2 + h



    for i = 1, 3, 1 do

        local xi = xMM
        local yi = yMM[i]

        CreateBoxOptions(world, xi, yi, w, h)

        yMM[i+1] = yMM[i] +200

        print(xMM, " ", yi, " ", w, h, i)
    end
end



function GamingOver()

    love.graphics.setColor(1,1,1)

    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.print("Your life is nothing, you serve zero purpose.\nYou should kill yourself, NOW!", 400, 300,0,2,2)
    love.graphics.draw(ltg, 400, 500)

end

function Winning()

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.print("Your life is everything, you serve purpose.\nYou should Love yourself, NOW!", 400, 300,0,2,2)
    love.graphics.draw(ltgLove, 400, 500)

end

function MainMenu()

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(love.graphics.newFont(30))

    love.graphics.draw(logo, sw/2- logo:getWidth()*3, sh/7, 0, 6, 6)
    love.graphics.print("Pebbles and amoguses", sw/2 - 350, sh/2,0,2,2)

    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawMainMenu()
    CeckMouseOverlapping(Mx, My)
    --CreateBoxOptions()

end

function CeckMouseOverlapping(Mx, My)
    
    for i = 1, #BoxOptions, 1 do

        --check if mouse is inside boxes xor
        if (Mx >= xMM - w/2 and Mx <= xMM + w/2) and (My >= yMM[i] and My <= yMM[i] + h)  then 

            --print("overlapping")
            --print(yMM[i], h)
            -- funny feddback and state changments

        end
    end

end

function DrawMainMenu()
    love.graphics.setColor(0.3, 0.3, 0.3)

    for i = 1, #BoxOptions do

        local CurrentBox = BoxOptions[i]
        love.graphics.polygon("fill", CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))

    end
end

function CreateBoxOptions(world, Tx, y, w, h)

    local yi = y + h/2

    BoxOption = {}

    BoxOption.body = love.physics.newBody(world, Tx, yi, "static")
    BoxOption.shape=love.physics.newRectangleShape(w, h)
    BoxOption.fixture = love.physics.newFixture(BoxOption.body, BoxOption.shape, 1)
    BoxOption.fixture:setUserData(BoxOption)
    BoxOption.fixture:setSensor(true)

    table.insert(BoxOptions, BoxOption)

    -- table.insert(BoxOptions, BoxOption)
end

function love.mousepressed(x, y, button, istouch)
    print("mouse pressed at: " .. x .. ", " .. y)
end