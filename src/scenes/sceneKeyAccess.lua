local sceneKeyAccess = {}


local inputClient = ""



function sceneKeyAccess.load()

end

function sceneKeyAccess.update(dt)

end


function sceneKeyAccess.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("KEY BETA : ", largeurEcran / 2, hauteurEcran / 2)
    love.graphics.print("ENTER KEY FOR ACCESS : " .. inputClient, largeurEcran / 2, hauteurEcran / 3)

end


function sceneKeyAccess.keypressed(key, isrepeat)
    if key == "space" then
        if inputClient == keyOfficiel then
            print("KEY BETA VALID !")
        else
            print("KEY BETA NO VALID !")
        end
    end
end


function sceneKeyAccess.mousepressed(x, y, button)

end


function sceneKeyAccess.textinput(event)
    inputClient = inputClient .. event
end


return sceneKeyAccess