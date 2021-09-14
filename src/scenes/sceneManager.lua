local sceneManager = {}


stateScene = "Editor"


function sceneManager.load()
    --sceneSplashScreenModule.load()
    sceneKeyAccessModule.load()
    sceneMenuModule.load()
    sceneGameplayModule.load()
    sceneGameoverModule.load()
    sceneEditorMapsModule.load()
end

function sceneManager.update(dt)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.update(dt)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.update(dt)
    elseif stateScene == "Menu" then
        sceneMenuModule.update(dt)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.update(dt)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.update(dt)
    elseif stateScene == "Editor" then
        sceneEditorMapsModule.update(dt)
    end
end


function sceneManager.draw()
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.draw()
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.draw()
    elseif stateScene == "Menu" then
        sceneMenuModule.draw()
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.draw()
    elseif stateScene == "Gameover" then
        sceneGameoverModule.draw()
    elseif stateScene == "Editor" then
        sceneEditorMapsModule.draw()
    end
end


function sceneManager.keypressed(key, isrepeat)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.keypressed(key, isrepeat)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.keypressed(key, isrepeat)
    elseif stateScene == "Menu" then
        sceneMenuModule.keypressed(key, isrepeat)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.keypressed(key, isrepeat)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.keypressed(key, isrepeat)
    elseif stateScene == "Editor" then
        sceneEditorMapsModule.keypressed(key, isrepeat)
    end
end


function sceneManager.mousepressed(x, y, button)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.mousepressed(x, y, button)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.mousepressed(x, y, button)
    elseif stateScene == "Menu" then
        sceneMenuModule.mousepressed(x, y, button)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.mousepressed(x, y, button)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.mousepressed(x, y, button)
    elseif stateScene == "Editor" then
        sceneEditorMapsModule.mousepressed(x, y, button)
    end
end


function sceneManager.textinput(event)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.textinput(event)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.textinput(event)
    elseif stateScene == "Menu" then
        sceneMenuModule.textinput(event)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.textinput(event)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.textinput(event)
    elseif stateScene == "Editor" then
        sceneEditorMapsModule.textinput(event)
    end
end


function sceneManager.wheelmoved(x, y)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.wheelmoved(x, y)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.wheelmoved(x, y)
    elseif stateScene == "Menu" then
        sceneMenuModule.wheelmoved(x, y)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.wheelmoved(x, y)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.wheelmoved(x, y)
    elseif stateScene == "Editor" then
        sceneEditorMapsModule.wheelmoved(x, y)
    end
end


return sceneManager