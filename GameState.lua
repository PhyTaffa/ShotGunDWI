STATE_IN_GAME = 1
STATE_OPTIONS = 2
STATE_MAIN_MENU = 3
STATE_WON = 4
STATE_STRANDED = 5
STATE_IN_GAME_MENU = 6
STATE_CREDITS = 7
STATE_QUIT = 8

local SelectedState = STATE_MAIN_MENU
local PreviousState = STATE_MAIN_MENU

local text = STATE_IN_GAME






function GetWantedState(DecidedState)
    text = DecidedState

end

-- function love.keyreleased(key)
--     if key == "c" and SelectedState == STATE_IN_GAME_MENU then
--         SelectedState = STATE_IN_GAME
--         print("Current State is ", SelectedState ,", Previous one was ", PreviousState)
--     end

--     if key == "escape" and SelectedState == STATE_IN_GAME then
--         SelectedState = STATE_IN_GAME_MENU
--         print("Current State is ", SelectedState ,", Previous one was ", PreviousState)
--     end

-- end

--Everything gets fisted from here

function ChangeGameState(ToBeSelectedState)


    SelectedState = ToBeSelectedState
end

function ReturnCurrentGameState()

    return SelectedState
end

function PreviousStateToGive()
    return PreviousState
end


function KeyPressedGS(key)
    if key == "1" then
        PreviousState = SelectedState
        SelectedState = STATE_IN_GAME
        love.mouse.setVisible(false)

        print("Current State is ", SelectedState ,", Previous one was ", PreviousState)
    end

     if key == "2" then
        PreviousState = SelectedState

        SelectedState = STATE_OPTIONS
        love.mouse.setVisible(true)

        print("Current State is ", SelectedState ,", Previous one was ", PreviousState)


     end

     if key == "3" then
        PreviousState = SelectedState

        SelectedState = STATE_MAIN_MENU
        love.mouse.setVisible(true)

        print("Current State is ", SelectedState ,", Previous one was ", PreviousState)


     end

     if key == "4" then
        PreviousState = SelectedState
        SelectedState = STATE_WON
        love.mouse.setVisible(true)

        print("Current State is ", SelectedState ,", Previous one was ", PreviousState)


     end
 
     if key == "5" then
        PreviousState = SelectedState
        SelectedState = STATE_STRANDED
        love.mouse.setVisible(true)

        print("Current State is ", SelectedState ,", Previous one was ", PreviousState)

     end

     if key == "6" then
        PreviousState = SelectedState
        if SelectedState == STATE_IN_GAME then
            SelectedState = STATE_IN_GAME_MENU
            love.mouse.setVisible(true)
            print("Current State is ", SelectedState ,", Previous one was ", PreviousState)

        else
            print("not in game, Current State: ", SelectedState)
        end

    end

     if key == "7" then
        PreviousState = SelectedState
        SelectedState = STATE_CREDITS
        love.mouse.setVisible(true)
        print("Current State is ", SelectedState ,", Previous one was ", PreviousState)

     end

     if key == "8" then
        PreviousState = SelectedState
        SelectedState = STATE_QUIT       
        print("Current State is ", SelectedState ,", Previous one was ", PreviousState)
        
     end

    --  if GetKey(key) == "x" then --and SelectedState == STATE_STRANDED
    --     --GetWantedState()
    --     --SelectedState = STATE_MAIN_MENU
    --     --ReturnCurrentGameState()
    --     SelectedState = text
    --     --ReturnCurrentGameState()
    --     print("Current State is ", SelectedState ,", Previous one was ", PreviousState)
    --  end

     if key == "9" then
   
        print("Current State is ", SelectedState ,", Previous one was ", PreviousState)
     end
end