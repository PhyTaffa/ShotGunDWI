STATE_IN_GAME = 1
STATE_OPTIONS = 2
STATE_MAIN_MENU = 3
STATE_WON = 4
STATE_STRANDED = 5
STATE_IN_GAME_MENU = 6
STATE_CREDITS = 7
STATE_QUIT = 8

local SelectedState = STATE_MAIN_MENU


function love.keypressed(key, scancode, isrepeat)

    if key == "1" then
        SelectedState = STATE_IN_GAME
        love.mouse.setVisible(false)
        print("current State: ", SelectedState)
     end

     if key == "2" then
        SelectedState = STATE_OPTIONS
        love.mouse.setVisible(true)
        print("current State: ", SelectedState)

     end

     if key == "3" then
        SelectedState = STATE_MAIN_MENU
        love.mouse.setVisible(true)
        print("current State: ", SelectedState)

     end

     if key == "4" then
        SelectedState = STATE_WON
        love.mouse.setVisible(true)
        print("current State: ", SelectedState)

     end
 
     if key == "5" then
        SelectedState = STATE_STRANDED
        love.mouse.setVisible(true)
        print("current State: ", SelectedState)


     end

     if key == "6" then
        if SelectedState == STATE_IN_GAME then
            SelectedState = STATE_IN_GAME_MENU
            love.mouse.setVisible(true)
            print("current State: ", SelectedState)
        else
            print("not in game, Current State: ", SelectedState)
        end

    end

     if key == "7" then
        SelectedState = STATE_CREDITS
        love.mouse.setVisible(true)
        print("current State: ", SelectedState)
     end

     if key == "8" then
        SelectedState = STATE_QUIT
        print("current State: ", SelectedState)
     end

end


function love.keyreleased(key)
    if key == "c" and SelectedState == STATE_IN_GAME_MENU then
        SelectedState = STATE_IN_GAME
        print("Previous State was STATE_IN_GAME_MENU, current one is STATE_IN_GAME")
    end

    if key == "escape" and SelectedState == STATE_IN_GAME then
        SelectedState = STATE_IN_GAME_MENU
        print("Previous State was STATE_IN_GAME, current one is STATE_IN_GAME_MENU")
    end
 end

--Everything gets fisted from here

function ChangeGameState(ToBeSelectedState)

    if ToBeSelectedState == STATE_MAIN_MENU then 

    end

    SelectedState = ToBeSelectedState

end

function ChangeGameState1(ToBeSelectedState)

    --1print(SelectedState)

    return SelectedState
end