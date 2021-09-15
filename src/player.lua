player = {}


-- Inertie
function inertiePlayer(dt)
  player.vx = player.vx * 0.88

  if math.abs(player.vx) < 0.1 then
    player.vx = 0
  end
end


-- Gravité
function graviterPlayer(dt)
  player.vy = player.vy + (0.7 * dt)
end


-- Mise a jour pour lui set la Gravité / Inertie en continue
function setGraviterInertieForPlayer(dt)
  player.x = player.x + player.vx
  player.y = player.y + player.vy
end


function mouvementPlayer(dt)

  -- Déplacement GAUCHE
  if love.keyboard.isDown('left') == true then
    if player.scaleX == math.abs(player.scaleX)  then
      player.scaleX = -player.scaleX
    end

    if player.activeAnimation ~= player.activeAnimation then
      player.activeAnimation = player.activeAnimation
    end
  end


  -- Déplacement DROITE
  if love.keyboard.isDown('right') == true then
    if player.scaleX == player.scaleX  then
      player.scaleX = math.abs(player.scaleX) -- math.abs() pour convertir le nombre négatif en positif
    end

    if player.activeAnimation ~= player.activeAnimation then
      player.activeAnimation = player.activeAnimation²
    end
  end

end




function player.load()
  -- Initialisation de l'objet player qui contient le joueur.
  -- Exemple : scaleY = 1 (default) pour avoir l'offsetY au centre -> il faudra diviser player.height / 2 | si scaleY = 0.70 : il faudra diviser player.height / 3.2 
  player.activeAnimation = 'gorilla' -- Juste à changer le nom pour pouvoir changer d'animations/skins
  player.speedAnimation = 1 -- Vitesse d'animations (1 : par défault)
  player.loopAnimation = true -- Animation en boucle (true or false)
  player.scaleX = 0.5
  player.scaleY = -0.5 -- Bug sur le ScaleY il es a : -1, il devrais être a l'envers alors qu'il dans le bon sens avec -1 donc mettre à l'envers le Sprite/Animation : 1
  player.width = animationsCharactersPlayer[player.activeAnimation]['state']['data']['skeletonData'].width / player.scaleX -- Faire la bonne operation
  player.height = animationsCharactersPlayer[player.activeAnimation]['state']['data']['skeletonData'].height / player.scaleY -- Faire la bonne operation
  player.offsetX = nil 
  player.offsetY = 2 + (10 - (player.scaleX * 10)) / 0.5 * 0.2 -- Pour avoir l'offsetY au centre du Sprite/Anim : + player.height / player.offsetY
  player.x = largeurEcran / 2
  player.y = hauteurEcran / 2 + player.height / player.offsetY
  player.vx = 10 
  player.vy = 0
  player.alpha = 1 -- Opacity
  player.rotate = nil -- Pas fait

  -- VOIR POUR LES COLLISION DU PLAYER VU QUE PENDANT L'ANIMATION LA LARGEUR CHANGE 

  print(player.width)
  print(player.height)
end


function player.update(dt)
  inertiePlayer(dt)
  graviterPlayer(dt)
  setGraviterInertieForPlayer(dt)
  mouvementPlayer(dt)
end


function player.draw()

end


return player