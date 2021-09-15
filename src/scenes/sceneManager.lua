local sceneManager = {}


stateScene = "SplashScreen"
versionJeuLocal = 0.8


function sceneManager.load()
    sceneSplashScreenModule.load()
    sceneKeyAccessModule.load()
    sceneMenuModule.load()
    sceneGameplayModule.load()
    sceneGameoverModule.load()
    sceneEditorMapsModule.load()
    sceneCreateUserModule.load()
end

function sceneManager.update(dt)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.update(dt)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.update(dt)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.update(dt)
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
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.draw()
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





-- Fonction de rappel déclenchée lorsqu'une touche est enfoncée.
function sceneManager.keypressed(key, scancode, isrepeat)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.keypressed(key, scancode, isrepeat)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.keypressed(key, scancode, isrepeat)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.keypressed(key, scancode, isrepeat)
    elseif stateScene == "Menu" then
        sceneMenuModule.keypressed(key, scancode, isrepeat)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.keypressed(key, scancode, isrepeat)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.keypressed(key, scancode, isrepeat)
    elseif stateScene == "Editor" then
        sceneEditorMapsModule.keypressed(key, scancode, isrepeat)
    end
end
  

-- Fonction de rappel déclenchée lorsqu'une touche du clavier est relâchée.
function sceneManager.keyreleased(key, scancode, isrepeat)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.keyreleased(key, scancode, isrepeat)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.keyreleased(key, scancode, isrepeat)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.keyreleased(key, scancode, isrepeat)
    elseif stateScene == "Menu" then
        sceneMenuModule.keyreleased(key, scancode, isrepeat)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.keyreleased(key, scancode, isrepeat)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.keyreleased(key, scancode, isrepeat)
    end
end


-- Appelé lorsque du texte est saisi par l'utilisateur.
function sceneManager.textinput(event)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.textinput(event)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.textinput(event)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.textinput(event)
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


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est enfoncé.
function sceneManager.mousepressed(x, y, button, istouch, presses)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.mousepressed(x, y, button, istouch, presses)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.mousepressed(x, y, button, istouch, presses)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.mousepressed(x, y, button, istouch, presses)
    elseif stateScene == "Menu" then
        sceneMenuModule.mousepressed(x, y, button, istouch, presses)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.mousepressed(x, y, button, istouch, presses)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.mousepressed(x, y, button, istouch, presses)
    elseif stateScene == "Editor" then
        sceneEditorMapsModule.mousepressed(x, y, button, istouch, presses)
    end
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est relâché.
function sceneManager.mousereleased(x, y, button, istouch, presses)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.mousereleased(x, y, button, istouch, presses)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.mousereleased(x, y, button, istouch, presses)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.mousereleased(x, y, button, istouch, presses)
    elseif stateScene == "Menu" then
        sceneMenuModule.mousereleased(x, y, button, istouch, presses)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.mousereleased(x, y, button, istouch, presses)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.mousereleased(x, y, button, istouch, presses)
    end
end


-- Fonction de rappel déclenchée lorsque la souris est déplacée.
function sceneManager.mousemoved(x, y, dx, dy)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.mousemoved(x, y, dx, dy)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.mousemoved(x, y, dx, dy)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.mousemoved(x, y, dx, dy)
    elseif stateScene == "Menu" then
        sceneMenuModule.mousemoved(x, y, dx, dy)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.mousemoved(x, y, dx, dy)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.mousemoved(x, y, dx, dy)
    end
end


-- Fonction de rappel déclenchée lorsque la molette de la souris est déplacer.
function sceneManager.wheelmoved(x, y)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.wheelmoved(x, y)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.wheelmoved(x, y)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.wheelmoved(x, y)
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


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est enfoncé.
function sceneManager.gamepadpressed(joystick, button)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.gamepadpressed(joystick, button)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.gamepadpressed(joystick, button)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.gamepadpressed(joystick, button)
    elseif stateScene == "Menu" then
        sceneMenuModule.gamepadpressed(joystick, button)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.gamepadpressed(joystick, button)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.gamepadpressed(joystick, button)
    end
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est relâché.
function sceneManager.gamepadreleased(joystick, button)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.gamepadreleased(joystick, button)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.gamepadreleased(joystick, button)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.gamepadreleased(joystick, button)
    elseif stateScene == "Menu" then
        sceneMenuModule.gamepadreleased(joystick, button)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.gamepadreleased(joystick, button)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.gamepadreleased(joystick, button)
    end
end


-- Appelé lorsqu'un bouton du joystick est enfoncé.
function sceneManager.joystickpressed(joystick, button)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.joystickpressed(joystick, button)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.joystickpressed(joystick, button)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.joystickpressed(joystick, button)
    elseif stateScene == "Menu" then
        sceneMenuModule.joystickpressed(joystick, button)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.joystickpressed(joystick, button)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.joystickpressed(joystick, button)
    end
end


-- Appelé lorsqu'un bouton du joystick est relâché.
function sceneManager.joystickreleased(joystick, button)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.joystickreleased(joystick, button)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.joystickreleased(joystick, button)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.joystickreleased(joystick, button)
    elseif stateScene == "Menu" then
        sceneMenuModule.joystickreleased(joystick, button)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.joystickreleased(joystick, button)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.joystickreleased(joystick, button)
    end
end


-- Appelé lorsqu'un joystick est connecté.
function sceneManager.joystickadded(joystick)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.joystickadded(joystick)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.joystickadded(joystick)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.joystickadded(joystick)
    elseif stateScene == "Menu" then
        sceneMenuModule.joystickadded(joystick)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.joystickadded(joystick)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.joystickadded(joystick)
    end
end


-- Appelé lorsqu'un joystick est déconnecté.
function sceneManager.joystickremoved(joystick)
    if stateScene == "SplashScreen" then
        sceneSplashScreenModule.joystickremoved(joystick)
    elseif stateScene == "KeyAccess" then
        sceneKeyAccessModule.joystickremoved(joystick)
    elseif stateScene == "CreateUser" then
        sceneCreateUserModule.joystickremoved(joystick)
    elseif stateScene == "Menu" then
        sceneMenuModule.joystickremoved(joystick)
    elseif stateScene == "Gameplay" then
        sceneGameplayModule.joystickremoved(joystick)
    elseif stateScene == "Gameover" then
        sceneGameoverModule.joystickremoved(joystick)
    end
end


return sceneManager