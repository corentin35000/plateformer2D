-- Pour adapter une image a la taille d'écran actuel du joueur, grâce au scaleX et scaleY (background menu ...)
-- Load : imageScaleX, imageScaleY = adaptImageToScreenSize(image)
-- Draw : love.graphics.draw(img, x, y, 0, imageScaleX, imageScaleY)
function adaptImageToScreenSize(image)
	local imgWidth = image:getWidth()
	local imgHeight = image:getHeight()

	local scaleX = largeurEcran / imgWidth
	local scaleY = hauteurEcran / imgHeight

	return scaleX, scaleY
end



-- Découpage d'une Spritesheet.
-- decoupeSpriteSheet(0, 0, largeurImg, hauteurImg, nombreImgParColonneSpriteSheet, nombreLignSpriteSheet, pNombreColonneADeduire, imgSpriteSheet)
function decoupeSpriteSheet(pPixelWidth, pPixelHeight, pImgWidth, pImgHeight, pNombreColonneSpriteSheet, pNombreLignSpriteSheet, pNombreColonneADeduire, pImgSpriteSheet)
    local arrayQuads = {}

    local counterNombreColonneSpriteSheet = 0 
    local nombreTotalColonnes = pNombreLignSpriteSheet * pNombreColonneSpriteSheet 
    nombreTotalColonnes = nombreTotalColonnes - pNombreColonneADeduire

    for i=0,nombreTotalColonnes,1 do
        if i == nombreTotalColonnes then
            break
        else
            if i >= 1 then
                -- Change de colonne dans la SpriteSheet (axe x)
                pPixelWidth = pPixelWidth + pImgWidth
            end

            -- Change de ligne dans la SpriteSheet (axe y)
            if counterNombreColonneSpriteSheet == pNombreColonneSpriteSheet then
                pPixelWidth = 0
                pPixelHeight = pPixelHeight + pImgHeight
                counterNombreColonneSpriteSheet = 0
            end

            counterNombreColonneSpriteSheet = counterNombreColonneSpriteSheet + 1
        end

        local quad = love.graphics.newQuad(pPixelWidth, pPixelHeight, pImgWidth, pImgHeight, pImgSpriteSheet)
        table.insert(arrayQuads, quad)
    end

    return arrayQuads
end



-- Timer / Minuteur
timer = {}
timer.minuteur = 0
timer.onMouse = 2 -- Décrémenter jusqu'a 0 et afficher l'image en preview / test

function timerr(dt)
    timer.minuteur = timer.minuteur + dt

    --print("TEMPS : " .. timer.minuteur)
end