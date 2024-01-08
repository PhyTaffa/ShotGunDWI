require "Player"
require "GameState"

STATE_IN_GAME = 1
STATE_OPTIONS = 2
STATE_MAIN_MENU = 3
STATE_WON = 4
STATE_STRANDED = 5
STATE_IN_GAME_MENU = 6
STATE_CREDITS = 7
STATE_QUIT = 8

local GameStateArray = {}

local logo
local WinningScreen

local bgm

local sw, sh
local BoxOptionsMM = {}
local BoxOptionsStranded = {}
local BoxOptionsWin = {}
local BoxOptionGameMenu = {}
local BoxOptionOption = {}
local BoxOptionCredits = {}
local BoxOption



local xMM
local yMM = {}
local w
local h
local yGM = {}

local textMainMenu = {"PLAY", "OPTION", "QUIT"}
local textStranded = {"MAIN MENU", "QUIT"}
local textWin = {"CREDITS"}
local textGameMenu = {"RESUME", "MAIN MENU", "QUIT"}
local textOption = {"BACK"}
local textCredits ={"MAIN MENU "}


local textMM = "Pebbles and amoguses"

local GameEnded = false
-- sounds
local menuSound


local mouseTimer = 0
local creditTimer = 3


function LoadMap(world)

    bgm = love.audio.newSource("environment.wav", "stream")
    bgm:setLooping(true)
    love.audio.play(bgm)

    WinningScreen = love.graphics.newImage("Immages/sunset.png")

    logo = love.graphics.newImage("/Immages/logo.png")

    sw = love.graphics:getWidth()
    sh = love.graphics:getHeight()
    w = sw/3
    h = sh/12


    menuSound = love.audio.newSource("/sounds/menu.wav", "static")

end

function DrawMap()

end

function LoadMainMenu(world)
    xMM = sw/2
    yMM[1] = sh/2 + h



    for i = 1, #textMainMenu, 1 do

        local xi = xMM
        local yi = yMM[i]

        CreateBoxOptions(world, xi, yi, w, h, i, BoxOptionsMM, textMainMenu)

        yMM[i+1] = yMM[i] + h * 2

        print("Main Menu", xMM, " ", yi, " ", w, h, i)
    end
end



function GamingOver()

    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawStrandedMenu()
    CheckMouseOverlapping(Mx, My, BoxOptionsStranded, textStranded)

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, sh/9, sw, sh/3)

    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(love.graphics.newFont(200))
    love.graphics.printf("STRANDED", 0, sh/9 + h/2, sw, "center")
    love.graphics.print("YOU STRANDED", sw/3 - sw/10, sh/9 - sh/3)

    
end

function LoadStrandedMenu(world)
    xMM = sw/2
    yMM[1] = sh/2 + h



    for i = 1, #textStranded, 1 do

        local xi = xMM
        local yi = yMM[i]

        CreateBoxOptions(world, xi, yi, w, h, i, BoxOptionsStranded, textStranded)

        yMM[i+1] = yMM[i] + h * 2

        print("Stranded Menu",xMM, " ", yi, " ", w, h, i)
    end
end

function LoadWinMenu(world)
    xMM = sw/2
    yMM[1] = sh/2 + h



    for i = 1, #textWin, 1 do

        local xi = xMM
        local yi = yMM[i]

        CreateBoxOptions(world, xi, yi, w, h, i, BoxOptionsWin, textWin)

        yMM[i+1] = yMM[i] + h * 2

        print("Win Menu",xMM, " ", yi, " ", w, h, i)
    end
end


function LoadGameMenu(world)
  
    yGM[1] = sh/2 - h*2



    for i = 1, #textGameMenu, 1 do

        local xi = xMM
        local yi = yGM[i]

        CreateBoxOptions(world, xi, yi, w, h, i, BoxOptionGameMenu, textGameMenu)

        yGM[i+1] = yGM[i] + h * 2

        print("Game Menu", xMM, " ", yi, " ", w, h, i)
    end
end

function LoadOptionMenu(world)
  
    yGM[1] = sh/2 - h*2



    for i = 1, #textOption, 1 do

        local xi = xMM
        local yi = yGM[i]

        CreateBoxOptions(world, xi, yi, w, h, i, BoxOptionOption, textOption)

        --yGM[i+1] = yGM[i] + h * 2

        print("Option Menu", xMM, " ", yi, " ", w, h, i)
    end
end

function GameMenu()

    local imgW = WinningScreen:getWidth()
    local imgH = WinningScreen:getHeight()

    local ratioW = sw/imgW
    local ratioH = sh/imgH

    -- love.graphics.setColor(1,1,1)
    -- love.graphics.draw(WinningScreen, 0, 0, 0 ,ratioW, ratioH)


    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawGameMenu()
    CheckMouseOverlappingGM(Mx, My, BoxOptionGameMenu, textGameMenu)

end

function CheckMouseOverlappingGM(Mx, My, GameStateBoxes, CurrentText)


    for i = 1, #GameStateBoxes, 1 do

        CurrentBox = GameStateBoxes[i]

        --check if mouse is inside boxes xor
        if (Mx >= xMM - w/2 and Mx <= xMM + w/2) and (My >= (yGM[i]) - h/2 and My <= (yGM[i]) + h/2)  then 

            
            --print(yMM[i], h)
            love.graphics.setColor(0.7, 0.7, 1)
            love.graphics.polygon("line",  CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))

            love.graphics.setColor(0.7, 0.7, 0)
            love.graphics.setFont(love.graphics.newFont(75))
            love.graphics.printf(CurrentText[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2 , w, "center")
            --love.graphics.print(textMainMenu[i], BoxOptions[i].body:getX() - w/10, BoxOptions[i].body:getY() - h/2)

            --print("overlapping")

            if love.mouse.isDown(1) and mouseTimer <= 0 and CurrentText[i] == "MAIN MENU " then
                --print("mouse working")
                mouseTimer = 0.2
                love.audio.play(menuSound)
                ChangeGameState(CurrentBox.state)
                textMM = "Pebbles and amoguses +"
                --GameEnded = true
                --ChangeSaveInfo()

            end

            if love.mouse.isDown(1) and mouseTimer <= 0 then
                --print("mouse working")
                mouseTimer = 0.2
                love.audio.play(menuSound)
                ChangeGameState(CurrentBox.state)
            end

            --funny feddback and state changments
        end
    end

end

function Winning()

    local imgW = WinningScreen:getWidth()
    local imgH = WinningScreen:getHeight()

    local ratioW = sw/imgW
    local ratioH = sh/imgH

    love.graphics.setColor(1,1,1)
    love.graphics.draw(WinningScreen, 0, 0, 0 ,ratioW, ratioH)


    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawWinMenu()
    CheckMouseOverlapping(Mx, My, BoxOptionsWin, textWin)

end

function MainMenu()

    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawMainMenu()
    CheckMouseOverlapping(Mx, My, BoxOptionsMM, textMainMenu)

    local imgW = logo:getWidth()
    local imgH = logo:getHeight()

    local ratioW = sw/(imgW * 3)
    local ratioH = sh/(imgH * 2.5)

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(love.graphics.newFont(30))

    love.graphics.draw(logo, sw/2 - imgW * 3/2, logo:getHeight(), 0, ratioW, ratioH)

    -- if GameEnded then
    --     love.graphics.setColor(1,0.4,1)
    -- end

    --love.graphics.print(textMM, sw/2 - 350, sh/2 - logo:getHeight() * 2, 0, 2, 2)
    -- else
    --     love.graphics.setColor(1,1,1)
    --     love.graphics.setFont(love.graphics.newFont(30))

    --     love.graphics.draw(logo, sw/2- logo:getWidth() * 3, logo:getHeight(), 0, 3, 3)
    --     love.graphics.print(textMM, sw/2 - 350, sh/2 - logo:getHeight() * 2, 0, 2, 2)

    -- end
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

function Option()

    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawOption()
    CheckMouseOverlappingGM(Mx, My, BoxOptionOption, textOption)

    love.graphics.setColor(1,1,1)
    
    

end

function KeyPressedM(key, CurrentState)

    if key == "escape" then
        if CurrentState == STATE_IN_GAME then
            ChangeGameState(STATE_IN_GAME_MENU)
        end

        if CurrentState == STATE_IN_GAME_MENU then
            ChangeGameState(STATE_IN_GAME)
        end
    end

    -- if key == "n" then
    --     print(GameEnded)
    -- end

    -- if key == "m" then
    --     filing()
    -- end

    -- if key == "b" then
    --     Wfiling()
    -- end

    -- if key == "k" then
    --     print(Rfiling())
    -- end
end


function CheckMouseOverlapping(Mx, My, GameStateBoxes, CurrentText)


    for i = 1, #GameStateBoxes, 1 do

        CurrentBox = GameStateBoxes[i]

        --check if mouse is inside boxes xor
        if (Mx >= xMM - w/2 and Mx <= xMM + w/2) and (My >= yMM[i] - h/2 and My <= yMM[i] + h/2)  then 

            
            --print(yMM[i], h)
            love.graphics.setColor(0.7, 0.7, 1)
            love.graphics.polygon("line",  CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))

            love.graphics.setColor(0.7, 0.7, 0)
            love.graphics.setFont(love.graphics.newFont(75))
            love.graphics.printf(CurrentText[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2 , w, "center")
            --love.graphics.print(textMainMenu[i], BoxOptions[i].body:getX() - w/10, BoxOptions[i].body:getY() - h/2)

            --print("overlapping")

            if love.mouse.isDown(1) and mouseTimer <= 0 then
                --print("mouse working")
                mouseTimer = 0.2
                love.audio.play(menuSound)
                ChangeGameState(CurrentBox.state)
            end

            --funny feddback and state changments
        end
    end

end

function UpdateMenusTimers(dt)
    if mouseTimer > 0 then
        mouseTimer = mouseTimer - dt
    end

    if creditTimer > 0 and ReturnCurrentGameState() == STATE_CREDITS then
        creditTimer = creditTimer - dt
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


function DrawStrandedMenu()

    for i = 1, #BoxOptionsStranded do

        local CurrentBox = BoxOptionsStranded[i]
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.polygon("fill", CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(75))
        love.graphics.printf(textStranded[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2 , w, "center")
        --love.graphics.print(textMainMenu[i], CurrentBox.body:getX() - w/10, CurrentBox.body:getY() - h/2)
    end
end


function DrawWinMenu()

    for i = 1, #BoxOptionsWin do

        local CurrentBox = BoxOptionsWin[i]
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.polygon("fill", CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(75))
        love.graphics.printf(textWin[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2 , w, "center")
        --love.graphics.print(textMainMenu[i], CurrentBox.body:getX() - w/10, CurrentBox.body:getY() - h/2)
    end
end

function DrawGameMenu()

    for i = 1, #BoxOptionGameMenu do

        local CurrentBox = BoxOptionGameMenu[i]
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.polygon("fill", CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))
        --love.graphics.rectangle("fill", CurrentBox.body:getX(), CurrentBox.body:getY(), w, h)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(75))
        love.graphics.printf(textGameMenu[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2, w, "center")
        --love.graphics.print(textMainMenu[i], CurrentBox.body:getX() - w/10, CurrentBox.body:getY() - h/2)
    end
end


function DrawOption()

    for i = 1, #BoxOptionOption do

        local CurrentBox = BoxOptionOption[i]
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.polygon("fill", CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))
        --love.graphics.rectangle("fill", CurrentBox.body:getX(), CurrentBox.body:getY(), w, h)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(75))
        love.graphics.printf(textOption[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2, w, "center")
        --love.graphics.print(textMainMenu[i], CurrentBox.body:getX() - w/10, CurrentBox.body:getY() - h/2)
    end
end


function CreateBoxOptions(world, Tx, y, w, h, i, BoxTable, TextList)

    local yi = y

    BoxOption = {}

    BoxOption.body = love.physics.newBody(world, Tx, yi, "static")
    BoxOption.shape=love.physics.newRectangleShape(w, h)
    BoxOption.fixture = love.physics.newFixture(BoxOption.body, BoxOption.shape, 1)
    BoxOption.fixture:setUserData(BoxOption)
    BoxOption.fixture:setSensor(true)

    CurrentText = TextList[i]

    if CurrentText == "MAIN MENU" then
        BoxOption.state = STATE_MAIN_MENU
    end

    if CurrentText == "QUIT" then
        BoxOption.state = STATE_QUIT
    end

    if CurrentText == "OPTION" then
        BoxOption.state = STATE_OPTIONS
    end

    if CurrentText == "PLAY" or CurrentText == "RESUME" then
        BoxOption.state = STATE_IN_GAME
    end

    if CurrentText == "CREDITS" then
        BoxOption.state = STATE_CREDITS
    end
    if CurrentText == "BACK" then
        BoxOption.state = STATE_MAIN_MENU
    end
    

    table.insert(BoxTable, BoxOption)

    -- table.insert(BoxOptions, BoxOption)
end

-- function love.mousepressed(x, y, button, istouch)
--     print("mouse pressed at: " .. x .. ", " .. y)
-- end


function LoadCredits(world)
  
    yGM[1] = sh/2 - h*2



    for i = 1, #textCredits, 1 do

        local xi = xMM
        local yi = yGM[i]

        CreateBoxOptions(world, xi, yi, w, h, i, BoxOptionCredits, textCredits)

        --yGM[i+1] = yGM[i] + h * 2

        print("Credits Menu", xMM, " ", yi, " ", w, h, i)
    end
end

function Credits()

    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawCredits()
    CheckMouseOverlappingGM(Mx, My, BoxOptionOption, textCredits)

    if creditTimer <= 0 then
        ChangeGameState(STATE_MAIN_MENU)
        textMM = "Pebbles and amoguses +"
        --Wfiling()
        --GameEnded = true
        --ChangeSaveInfo()
        creditTimer = 3
    end

    love.graphics.setColor(1,1,1)
    
    print(creditTimer)
    
    

end

function DrawCredits()

    for i = 1, #BoxOptionCredits do

        local CurrentBox = BoxOptionCredits[i]
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.polygon("fill", CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))
        --love.graphics.rectangle("fill", CurrentBox.body:getX(), CurrentBox.body:getY(), w, h)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(60))
        love.graphics.printf(textCredits[i], CurrentBox.body:getX()- w/2, CurrentBox.body:getY() - h/2, w, "center")
        --love.graphics.print(textMainMenu[i], CurrentBox.body:getX() - w/10, CurrentBox.body:getY() - h/2)
    end
end


---------------------------files

-- function LoadSaveInfo()
--     -- reads the content of the/file
--     local file = io.open("C:/Users/../AppData/Roaming/LOVE/ShotGunDWI/timer")
--     local i = 1

--     for line in file:lines() do

--         GameEnded = line
--         -- world[i] = {}
--         -- for j = 1, #line, 1 do
--         --     world[i][j] = line:sub(j, j)
--         -- end
--         -- i = i + 1
--     end

--     file:close()
-- end

-- function ChangeSaveInfo()
--     -- reads the content of the file
--     local file = io.open(fileName, "w")
--     local i = 1

--     for line in file:lines() do

--         --line = "true"
        
--         -- world[i] = {}
--         -- for j = 1, #line, 1 do
--         --     world[i][j] = line:sub(j, j)
--         -- end
--         -- i = i + 1
--     end
--     --love.filesystem.write( "GameInfo.txt", "true")
    
--     file:close()
-- end

-- local timerStr = "true"
-- local FileDirectory = "timer"

-- function saveTimer()

--     love.filesystem.write(FileDirectory, timerStr)

-- end

-- -- presses M
-- function loadTimer()

--     if love.filesystem.getInfo(FileDirectory) ~= nil then

--         local saveFileData = love.filesystem.read(FileDirectory)
--         --StringToTimer(saveFileData)
--         print("file already exist")
--     else
--         saveTimer()
--         print("no previous time data found.")
--     end
-- end


-- function filing()

--     local file = fileName
--     --Read from a file

--     file = io.open("GameInfo.txt", "r")
--     for c in file:lines() do
--         print(c)
--         GameEnded = c
--     end
--     file:close()
-- end

-- ----- B
-- function Wfiling()
--     local file = fileName

--     file = io.open("GameInfo.txt", "w")
--     file:write("false")
--     file:close()

--     print("writing done")
-- end

-- function Rfiling()

--     local file = fileName
--     local Read
--     --Read from a file

--     file = io.open("GameInfo.txt", "r")
--     for c in file:lines() do
--         Read = c
--     end
--     file:close()

--     return Read
-- end