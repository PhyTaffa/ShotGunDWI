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


---------------------------MENNUS CREADTION, DRAWING AND ESSENTIAL FUNCTIONS-------------------------


function LoadMenuEssentials(world)

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



-------------MAIN MENU
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

    love.graphics.draw(logo, sw/2 - imgW * 3/2 - 60, logo:getHeight(), 0, ratioW, ratioH)

end





--------------STRANDED
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






------------------- WIN MENU/SCREEN
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




----------------- IN GAME MENU
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



----------- OPTION MENU
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

function Option()

    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawOption()
    CheckMouseOverlappingGM(Mx, My, BoxOptionOption, textOption)

    love.graphics.setColor(1,1,1)
    
    

end




------------------------------ CREDITS
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

function Credits()

    local Mx = love.mouse:getX()
    local My = love.mouse.getY()

    DrawCredits()
    CheckMouseOverlappingCredits(Mx, My, BoxOptionOption, textCredits)

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







------------FUNCTIONS NECESSARY TO MAKE EVRYTHING WORK-------------------------------------


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


----------------------- CREATION OF THE BOXS FOR THE MENUS
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





function UpdateMenusTimers(dt)
    if mouseTimer > 0 then
        mouseTimer = mouseTimer - dt
    end

    if creditTimer > 0 and ReturnCurrentGameState() == STATE_CREDITS then
        creditTimer = creditTimer - dt
    end

end




---------------------------- CHECKS IF HTE MOUSE IS OVERLAPPING
---------------------------- TWO EXISTS CUZ OF LACK OF TIME, ONE IS MORE THAN ENOUGH BUT THINGS SHOULD HAVE BEEN CHANGED
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

function CheckMouseOverlappingCredits(Mx, My, GameStateBoxes, CurrentText)


    for i = 1, #GameStateBoxes, 1 do

        CurrentBox = GameStateBoxes[i]

        --check if mouse is inside boxes xor
        if (Mx >= xMM - w/2 and Mx <= xMM + w/2) and (My >= (yGM[i]) - h/2 and My <= (yGM[i]) + h/2)  then 

            
            --print(yMM[i], h)
            love.graphics.setColor(0.7, 0.7, 1)
            love.graphics.polygon("line",  CurrentBox.body:getWorldPoints(CurrentBox.shape:getPoints()))

            love.graphics.setColor(0.7, 0.7, 0)
            love.graphics.setFont(love.graphics.newFont(60))
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







------------ KEYBOARD PRESSES 
function KeyPressedM(key, CurrentState)

    if key == "escape" then
        if CurrentState == STATE_IN_GAME then
            ChangeGameState(STATE_IN_GAME_MENU)
        end

        if CurrentState == STATE_IN_GAME_MENU then
            ChangeGameState(STATE_IN_GAME)
        end

        if CurrentState == STATE_MAIN_MENU then
            ChangeGameState(STATE_MAIN_MENU)

            love.event.quit()
        end
    end

end