local sceneGameover = {}


function sceneGameover.load()

end

function sceneGameover.update(dt)

end


function sceneGameover.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("PERDU !", largeurEcran / 2, hauteurEcran / 2)
end


function sceneGameover.keypressed(key, isrepeat)

end


function sceneGameover.mousepressed(x, y, button)

end


function sceneGameover.textinput(event)

end


function sceneGameover.wheelmoved(x, y)
   
end


return sceneGameover