local menu = {}

function menu.Draw()
  
  -- Affichage du background du Menu.
  love.graphics.draw(imgMenu.background, 0, 0)
  

  -- Affichages des bouttons du Menu.
  love.graphics.draw(imgMenu.play, (largeurEcran / 2), (hauteurEcran / 3), 0, 1, 1, imgMenu.play:getWidth() / 2, imgMenu.play:getHeight() / 2)
  love.graphics.draw(imgMenu.options, (largeurEcran / 2), (hauteurEcran / 2), 0, 1, 1, imgMenu.options:getWidth() / 2, imgMenu.options:getHeight() / 2)
  love.graphics.draw(imgMenu.exit, (largeurEcran / 2), (hauteurEcran / 1.5), 0, 1, 1, imgMenu.exit:getWidth() / 2, imgMenu.exit:getHeight() / 2)
  
end

return menu