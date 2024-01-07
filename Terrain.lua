require "Player"
require "GameState"

STATE_IN_GAME = 1
STATE_OPTIONS = 2
STATE_MAIN_MENU = 3
STATE_WON = 4
STATE_STRANDED = 5
STATE_IN_GAME_MENU = 6
STATE_CREDITS = 7

local logo
local WinningScreen

local bgm

local sw, sh
local BoxOptionsMM = {}
local BoxOption



local xMM
local yMM = {}
local w
local h

local textMainMenu = {"PLAY", "OPTION", "QUIT"}

-- sounds
local menuSound


function LoadMap(world)

    bgm = love.audio.newSource("environment.wav", "stream")
    bgm:setLooping(true)
    love.audio.play(bgm)

    WinningScreen = love.graphics.newImage("Immages/sunset.png")
    ltg = love.graphics.newImage("ltg.png")

    logo = love.graphics.newImage("/Immages/logo.png")

    sw = love.graphics:getWidth()
    sh = love.graphics:getHeight()
    w = sw/4
    h = sh/12


    menuSound = love.audio.newSource("/sounds/menu.wav", "static")

end

function DrawMap()

end

function LoadMainMenu(world)
    xMM = sw/2
    yMM[1] = sh / 2 + h



    for i = 1, 3, 1 do

        local xi = xMM
        local yi = yMM[i]

        CreateBoxOptions(world, xi, yi, w, h, i)

        yMM[i+1] = yMM[i] +200

        print(xMM, " ", yi, " ", w, h, i)
    end
end



function GamingOver()

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, sh/3, sw, sh/3)

    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(love.graphics.newFont(200))
    love.graphics.print("YOU STRANDED", sw/3 - sw/10, sh/2 - sh/10)

end

function Winning()

    local imgW = WinningScreen:getWidth()
    local imgH = WinningScreen:getHeight()

    local ratioW = sw/imgW
    local ratioH = sh/imgH

    love.graphics.setColor(1,1,1)
    love.graphics.draw(WinningScreen, 0, 0, 0 ,ratioW, ratioH)

end

function MainMenu()

    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawMainMenu()
    CeckMouseOverlapping(Mx, My, BoxOptionsMM)

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(love.graphics.newFont(30))

    love.graphics.draw(logo, sw/2- logo:getWidth() * 3, sh/7, 0, 6, 6)
    love.graphics.print("Pebbles and amoguses", sw/2 - 350, sh/2,0,2,2)

    -- for i = 1, #BoxOptions do

    --     local CurrentBox = BoxOptions[i]

    --     -- love.graphics.setColor(1, 1, 1)
    --     -- love.graphics.setFont(love.graphics.newFont(75))
    --     -- love.graphics.print(textMainMenu[i], CurrentBox.body:getX() - w/10, CurrentBox.body:getY() - h/2)

    -- end

    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.setFont(love.graphics.newFont(20))
    -- love.graphics.print("play", BoxOptions[1].body:getX(), BoxOptions[1].body:getX() )
    -- love.graphics.print("play", BoxOptions[2].body:getX(), BoxOptions[2].body:getX() )
    
    -- --CreateBoxOptions()

end

function CeckMouseOverlapping(Mx, My, GameStateBoxes)
    

    for i = 1, #GameStateBoxes, 1 do

        CurrentBox = GameStateBoxes[i]

        --check if mouse is inside boxes xor
        if (Mx >= xMM - w/2 and Mx <= xMM + w/2) and (My >= yMM[i] and My <= yMM[i] + h)  then 

            
            --print(yMM[i], h)
            love.graphics.setColor(0.7, 0.7, 1)
            love.graphics.polygon("line",  CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))

            love.graphics.setColor(0.7, 0.7, 0)
            love.graphics.setFont(love.graphics.newFont(75))
            love.graphics.printf(textMainMenu[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2 , w, "center")
            --love.graphics.print(textMainMenu[i], BoxOptions[i].body:getX() - w/10, BoxOptions[i].body:getY() - h/2)

            if love.keyboard.isDown("x") then
                love.audio.play(menuSound)
                ChangeGameState(CurrentBox.state)
                --print("overlapping")

            --funny feddback and state changments
            end
        end
    end

end

function DrawMainMenu()

    for i = 1, #BoxOptionsMM do

        local CurrentBox = BoxOptionsMM[i]
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.polygon("fill", CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(75))
        love.graphics.printf(textMainMenu[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2 , w, "center")
        --love.graphics.print(textMainMenu[i], CurrentBox.body:getX() - w/10, CurrentBox.body:getY() - h/2)
    end
end

function CreateBoxOptions(world, Tx, y, w, h, i)

    local yi = y + h/2

    BoxOption = {}

    BoxOption.body = love.physics.newBody(world, Tx, yi, "static")
    BoxOption.shape=love.physics.newRectangleShape(w, h)
    BoxOption.fixture = love.physics.newFixture(BoxOption.body, BoxOption.shape, 1)
    BoxOption.fixture:setUserData(BoxOption)
    BoxOption.fixture:setSensor(true)
    BoxOption.state = i

    if i == STATE_MAIN_MENU then
        BoxOption.state = STATE_QUIT
    end

    table.insert(BoxOptionsMM, BoxOption)

    -- table.insert(BoxOptions, BoxOption)
end

-- function love.mousepressed(x, y, button, istouch)
--     print("mouse pressed at: " .. x .. ", " .. y)
-- end