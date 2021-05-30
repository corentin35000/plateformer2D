local menu = {}

-- Les images du background du Menu et les bouttons du Menu.
imgMenu = {} 
imgMenu.background = nil
imgMenu.play = nil
imgMenu.options = nil
imgMenu.exit = nil





function menu.Load()

  -- Initialiser/Charger les images du Menu
  imgMenu.background = love.graphics.newImage("assets/background_menu.jpg")
  imgMenu.play = love.graphics.newImage("assets/menu_play.png")
  imgMenu.options = love.graphics.newImage("assets/menu_options.png")
  imgMenu.exit = love.graphics.newImage("assets/menu_exit.png")
  

  -- Récupère le scaleX et scaleY pour adapter le background a n'importe quel taille d'écran.
  imgBackgroundMenuScaleX, imgBackgroundMenuScaleY = getScaling(imgMenu.background)

end


function menu.Update()

  
end


function menu.Draw()
  
  -- Affichage du background du Menu.
  love.graphics.draw(imgMenu.background, 0, 0, 0, imgBackgroundMenuScaleX, imgBackgroundMenuScaleY)


  -- Affichages des bouttons du Menu.
  love.graphics.draw(imgMenu.play, (largeurEcran / 2), (hauteurEcran / 3), 0, 1, 1, imgMenu.play:getWidth() / 2, imgMenu.play:getHeight() / 2)
  love.graphics.draw(imgMenu.options, (largeurEcran / 2), (hauteurEcran / 2), 0, 1, 1, imgMenu.options:getWidth() / 2, imgMenu.options:getHeight() / 2)
  love.graphics.draw(imgMenu.exit, (largeurEcran / 2), (hauteurEcran / 1.5), 0, 1, 1, imgMenu.exit:getWidth() / 2, imgMenu.exit:getHeight() / 2)
  
end

return menu