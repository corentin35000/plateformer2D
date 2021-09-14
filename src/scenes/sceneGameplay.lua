local sceneGameplay = {}


function sceneGameplay.load()
    -- Module animationsCharacter.lua (Load)
    animationsCharactersSpinesModule.load()


    -- Module player.lua (Load)
    playerModule.load()


    -- Module mapsInGame.lua
    --mapsInGameModule.load()
end


function sceneGameplay.update(dt)
    -- Module mapsInGame.lua
    --mapsInGameModule.update()


    -- Le module animationsCharacters.lua de la fonction Update
    animationsCharactersSpinesModule.update(dt)
  

    -- Le module player.lua de la fonction Update
    playerModule.update(dt)
end


function sceneGameplay.draw()
    --
    love.graphics.setBackgroundColor(255, 255, 255, 1)


    -- Module mapsInGame.lua
    --mapsInGameModule.draw()
 
 
    -- Le module player.lua de la fonction Draw
    playerModule.draw()
 
 
    -- Le module animationsCharacters.lua de la fonction Draw
    animationsCharactersSpinesModule.draw()
   
     
    -- Effet de transition d'écran
    --ecransTransitionsModule.Draw.GamePlay()
end


function sceneGameplay.keypressed(key, isrepeat)

end


function sceneGameplay.mousepressed(x, y, button)

end


function sceneGameplay.textinput(event)

end


return sceneGameplay