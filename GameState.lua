STATE_IN_GAME = 1
STATE_MAIN_MENU = 2
STATE_WON = 3
STATE_STRANDED = 4
STATE_IN_GAME_MENU = 5

local state = 2

function CheckGameState(CurrentState)

    if CurrentState == STATE_IN_GAME then
        -- inGame Update/Drawings

    elseif CurrentState == STATE_MAIN_MENU then
        -- Main menu

    elseif CurrentState == STATE_WON then
        --Drawing things and stopping the update
    
    elseif CurrentState == STATE_STRANDED then
        --Drawing things and stopping the update
    
    end

end