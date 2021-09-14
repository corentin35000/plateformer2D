local animationsCharactersSpine = {}


-- Charge la bibliothèque Spine - Lua/Love2D
local spine = require("spine-love.spine")

-- Tableau a deux dimensions qui contient toute les animations du Player (jump, walk..)
animationsCharactersPlayer = {}
animationsCharactersAll = {}

-- Création AnimationsCharacters : animationLoad(jsonFile, atlasFile, nomAnimation(jump..), nomDuSkin, nomDuDossierRessource)
function animationLoad(jsonFile, atlasFile, animation, skin, nameDossier)
	-- Charge les fichiers json, atlas, sritesheet.png
	local loader = function (path) return love.graphics.newImage(nameDossier .. "/" .. path) end
	local atlas = spine.TextureAtlas.new(spine.utils.readFile(nameDossier .. "/" .. atlasFile .. ".atlas"), loader)
	local json = spine.SkeletonJson.new(spine.AtlasAttachmentLoader.new(atlas))
	local skeletonData = json:readSkeletonDataFile(nameDossier .. "/" .. jsonFile .. ".json")

	-- Instancie le skeleton
	local skeleton = spine.Skeleton.new(skeletonData)

	-- Set un skin au lieu du skin par défault
	if skin then
		skeleton:setSkin(skin)
	end

  -- Instancie le state
  local stateData = spine.AnimationStateData.new(skeletonData)
  local state = spine.AnimationState.new(stateData)
	state:setAnimationByName(0, animation, true)
  
	return { state = state, skeleton = skeleton }
end

function animationUpdate(dt)
  -- Mise à jour des os du squelette en cours d'animations
	local state = animationsCharactersPlayer[player.activeAnimation].state
	local skeleton = animationsCharactersPlayer[player.activeAnimation].skeleton
	
	state:update(dt)
	state:apply(skeleton)
	skeleton:updateWorldTransform()
end  

function animationDraw()
    -- Récupère l'instance de 'skeleton' et affiche le Sprite/Animation
    local skeleton = animationsCharactersPlayer[player.activeAnimation].skeleton
    skeletonRenderer:draw(skeleton)
end



function animationsCharactersSpine.load()
	-- Pour activer la teinte bicolore (true or false)
	skeletonRenderer = spine.SkeletonRenderer.new(true)

	
	-- Charge les animations du Player (animations/skins) et les envoie dans un tableau a deux dimensions (animationsPlayer)
	animationsCharactersPlayer['golemRunSkins1'] = animationLoad("golem", "golem", "run", 'golemRunSkins1', 'animationsCharactersSpine')
	animationsCharactersPlayer['golemJumpSkins2'] = animationLoad("golem", "golem", "run", 'golemRunSkins2', 'animationsCharactersSpine')
	animationsCharactersPlayer['gorilla'] = animationLoad("gorilla", "gorilla", "walk", nil, 'animationsCharactersSpine')


	-- Initialisation de l'objet player qui contient le joueur.
  -- Exemple : scaleY = 1 (default) pour avoir l'offsetY au centre -> il faudra diviser player.height / 2 | si scaleY = 0.70 : il faudra diviser player.height / 3.2 
	player = {}
	player.activeAnimation = 'gorilla' -- Juste à changer le nom pour pouvoir changer d'animations/skins
  player.speedAnimation = 1 -- Vitesse d'animations (1 : par défault)
  player.loopAnimation = true -- Animation en boucle (true or false)
  player.width = animationsCharactersPlayer[player.activeAnimation]['state']['data']['skeletonData'].width
  player.height = animationsCharactersPlayer[player.activeAnimation]['state']['data']['skeletonData'].height
  player.scaleX = 0.25
	player.scaleY = -0.25 -- Bug sur le ScaleY il es a : -1, il devrais être a l'envers alors qu'il dans le bon sens avec -1 donc mettre à l'envers le Sprite/Animation : 1
  player.offsetX = nil 
  player.offsetY = 2 + (10 - (player.scaleX * 10)) / 0.5 * 0.2 -- Pour avoir l'offsetY au centre du Sprite/Anim : + player.height / player.offsetY
	player.x = largeurEcran / 2
	player.y = hauteurEcran / 2 + player.height / player.offsetY
	player.vx = 10 
	player.vy = 0
  player.alpha = 1 -- Opacity
  player.rotate = nil


  -- Test : Affiche les data du squelette d'animation en cours d'animation
  --for key, valeur in pairs(animationsPlayer[player.activeAnimation]['skeleton']['bones'][1]) do
    --print(key, valeur)
  --end
end


function animationsCharactersSpine.update(dt)
  -- Mise à jour des données du Joueur
  animationsCharactersPlayer[player.activeAnimation]['state'].timeScale = player.speedAnimation
  animationsCharactersPlayer[player.activeAnimation]['state']['tracks'][0].loop = player.loopAnimation
  animationsCharactersPlayer[player.activeAnimation]['state']['data']['skeletonData'].width = player.width
  animationsCharactersPlayer[player.activeAnimation]['state']['data']['skeletonData'].height = player.height
  animationsCharactersPlayer[player.activeAnimation]['skeleton'].scaleX = player.scaleX
  animationsCharactersPlayer[player.activeAnimation]['skeleton'].scaleY = player.scaleY
  animationsCharactersPlayer[player.activeAnimation]['skeleton'].x = player.x
  animationsCharactersPlayer[player.activeAnimation]['skeleton'].y = player.y
  animationsCharactersPlayer[player.activeAnimation]['skeleton']['color'].a = player.alpha


  -- Mise à jour des os du squelette en cours d'animations
  animationUpdate(dt)
end


function animationsCharactersSpine.draw()
  -- Test offsetX et offsetY.
  --love.graphics.setColor(255, 0, 0, 1)
  --love.graphics.line(0, hauteurEcran / 2, largeurEcran, hauteurEcran / 2)
  --love.graphics.line(largeurEcran / 2, 0, largeurEcran / 2, hauteurEcran)
  --love.graphics.setColor(1, 1, 1, 1)


  -- Affichage Sprite/Animation
  animationDraw()
end


return animationsCharactersSpine