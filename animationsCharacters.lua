local animationsCharacters = {}

-- Charge la bibliothèque Spine - Lua/Love2D
local spine = require("spine-love.spine")

-- Tableau a deux dimensions qui contient toute les animations du Player (jump, walk..)
animationsPlayer = {}

-- Création d'animations : loadSkeleton(jsonFile, atlasFile, nomAnimation(jump..), nomSkins, nomDuDossierRessource)
-- Bug sur le ScaleY il es a : -1, il devrais être a l'envers alors qu'il dans le bon sens avec -1 donc mettre à l'envers le Sprite/Animation : 1
function loadSkeleton (jsonFile, atlasFile, animation, skin, nameDossier)
	-- Charge les fichiers json, atlas, sritesheet.png
	local loader = function (path) return love.graphics.newImage(nameDossier .. "/" .. path) end
	local atlas = spine.TextureAtlas.new(spine.utils.readFile(nameDossier .. "/" .. atlasFile .. ".atlas"), loader)
	local json = spine.SkeletonJson.new(spine.AtlasAttachmentLoader.new(atlas))
	local skeletonData = json:readSkeletonDataFile(nameDossier .. "/" .. jsonFile .. ".json")

	-- Instancie le skeleton et le state
	local skeleton = spine.Skeleton.new(skeletonData)
	local stateData = spine.AnimationStateData.new(skeletonData)
	local state = spine.AnimationState.new(stateData)
	state:setAnimationByName(0, animation, true)

	-- Set un autre skin au lieu du personnage par défault
	if skin then
		skeleton:setSkin(skin)
	end

	skeleton:setToSetupPose()
	
	return { state = state, skeleton = skeleton }
end


function mouvementPlayer(dt)

  -- Déplacement GAUCHE
  if love.keyboard.isDown('left') == true then
    testLeft = true;
    rotationImgX = -1

    Hero.x = Hero.x + (-7 * (60 * dt))
  end


  -- Déplacement DROITE
  if love.keyboard.isDown('right') == true then
    testRight = true
    rotationImgX = 1

    Hero.x = Hero.x + (7 * (60 * dt))   
  end
  
  
  -- Déplacement SAUTER vers le HAUT
  if keySpace == true then
    
    testSpace = true
    bonusJump = true

    if currentTimerJump < 0.1 then
      Hero.y = Hero.y - 250 + dt;
    else
      Hero.y = Hero.y + 0
    end
    
    keySpace = false
  end
  
end







function animationsCharacters.Load()
	-- Pour activer la teinte bicolore (true or false)
	skeletonRenderer = spine.SkeletonRenderer.new(true)

	
	-- Charge les animations du Player et les envoie dans un tableau a deux dimensions (animationsPlayer)
	animationsPlayer['golemRunSkins1'] = loadSkeleton("golem", "golem", "run", 'golemRunSkins1', 'animations2D')
	animationsPlayer['golemJumpSkins2'] = loadSkeleton("golem", "golem", "run", 'golemRunSkins2', 'animations2D')


  -- Test : Affichages des data du squelette d'animation en cours d'animation
  --for key, valeur in pairs(animationsPlayer['golemRunSkins1']['state']['data']['skeletonData']) do
    --print(key, valeur)
  --end


	-- Initialisation de l'objet player qui contient le joueur.
  -- OffsetX de l'image/animation de base est déjà au centre | offsetY à besoin d'être changer pour avoir l'offsetY au centre
  -- Exemple : scaleY = 1 (default) pour avoir l'offsetY au centre -> il faudra diviser y / 2 | si scaleY = 0.70 : il faudra diviser y / 3.2 
  -- scaleY (0.5) = 0.2 a diviser.
	player = {}
	player.activeAnimation = 'golemRunSkins1'
  player.width = animationsPlayer[player.activeAnimation]['state']['data']['skeletonData'].width
  player.height = animationsPlayer[player.activeAnimation]['state']['data']['skeletonData'].height
  player.scaleX = 1.0
	player.scaleY = -1.0
  player.offsetX = nil
  player.offsetY = 2 + (10 - (player.scaleX * 10)) / 0.5 * 0.2
	player.x = largeurEcran / 2
	player.y = hauteurEcran / 2 + player.height / player.offsetY
	player.vx = 0
	player.vy = 0
end


function animationsCharacters.Update(dt)
  -- Mise à jour des données du Joueur
  animationsPlayer[player.activeAnimation]['state']['data']['skeletonData'].width = player.width
  animationsPlayer[player.activeAnimation]['state']['data']['skeletonData'].height = player.height
  animationsPlayer[player.activeAnimation]['skeleton'].scaleX = player.scaleX
  animationsPlayer[player.activeAnimation]['skeleton'].scaleY = player.scaleY
  player.offsetY = player.height / (2 + (player.scaleX * 10) * 0.2)
  animationsPlayer[player.activeAnimation]['skeleton'].x = player.x
  animationsPlayer[player.activeAnimation]['skeleton'].y = player.y

  
	-- Juste a mettre une condition pour changer la variable : player.activeAnimation et lui setter le nom de l'animation a jouer en fonction des touches enfoncées
	if love.keyboard.isDown('left') then

	end


	-- Mise à jour des os du squelette en cours d'animations
	local state = animationsPlayer[player.activeAnimation].state
	local skeleton = animationsPlayer[player.activeAnimation].skeleton
	
	state:update(dt)
	state:apply(skeleton)
	skeleton:updateWorldTransform()


	-- Update de la position du Player
	player.x = player.x + (60 * dt)
end


function animationsCharacters.Draw()
  -- Test offset
  love.graphics.setColor(255, 0, 0, 1)
  love.graphics.line(0, hauteurEcran / 2, largeurEcran, hauteurEcran / 2)
  love.graphics.line(largeurEcran / 2, 0, largeurEcran / 2, hauteurEcran)
  love.graphics.setColor(1, 1, 1, 1)


  -- Récupère l'instance de 'skeleton'
	local skeleton = animationsPlayer[player.activeAnimation].skeleton

	-- Affichage du Sprite/Animation
	skeletonRenderer:draw(skeleton)
end

return animationsCharacters