local decoupageSpriteSheet = {}

-- Load toute les Spritesheets


-- Tableau a deux dimensions.
data = {}

-- Découpage d'une Spritesheet.
-- decoupeSpriteSheet(0, 0, largeurImg, hauteurImg, nombreImgParColonne, nombreImgParLigne, imgSpriteSheetAnimation , nomKeyTableauAnimation)
function decoupeSpriteSheet(pPixelWidth, pPixelHeight, pImgWidth, pImgHeight, pNombreColonneSpriteSheet, pNombreLignSpriteSheet, pImgSpriteSheetAnim, pKeyTableau)
    local data2 = {}

    nombreColonneImg = pNombreColonneSpriteSheet 
    nombreTotalColonnes = pNombreLignSpriteSheet * pNombreColonneSpriteSheet 

    for i=0,nombreTotalColonnes,1 do
        if i == nombreTotalColonnes then
            break
        else
            if i >= 1 then
                -- Change de colonne dans la SpriteSheet (axe x)
                pPixelWidth = pPixelWidth + pImgWidth
            end

            -- Change de ligne dans la SpriteSheet (axe y)
            if i == pNombreColonneSpriteSheet then
                pNombreColonneSpriteSheet = pNombreColonneSpriteSheet + pNombreColonneSpriteSheet
                pPixelWidth = 0
                pPixelHeight = pPixelHeight + pImgHeight
            end
        end

        local quad = love.graphics.newQuad(pPixelWidth, pPixelHeight, pImgWidth, pImgHeight, pImgSpriteSheetAnim)
        table.insert(animation, quad)
    end

    data[pKeyTableau] = data2 -- Ajout dans le tableau a deux dimensions.
end







function decoupageSpriteSheet.Load()
    --decoupeSpriteSheet(0, 0, 102, 79, 7, 2, imgTileMapSpriteSheet, 'tileMapDesert')
    -- Creer la propriétée data.frames pour changer d'image dynamiquement
end

function decoupageSpriteSheet.Update()
 
end

function decoupageSpriteSheet.Draw()
    --local frameArrondie = math.floor(animationsPlayer.frames)

    --love.graphics.draw(imgGolemSpritesheetRun, animationGolemRun[frameArrondie], Hero.x, Hero.y, 0, rotationImgX, rotationImgY, Hero.img:getWidth() / 2, Hero.img:getHeight() / 2)
end

return decoupageSpriteSheet