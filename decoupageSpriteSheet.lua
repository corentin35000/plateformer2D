local decoupageSpriteSheet = {}

-- Découpage d'une Spritesheet.
-- decoupeSpriteSheet(0, 0, largeurImg, hauteurImg, nombreImgParColonneSpriteSheet, nombreLignSpriteSheet, pNombreColonneADeduire, imgSpriteSheet)
function decoupeSpriteSheet(pPixelWidth, pPixelHeight, pImgWidth, pImgHeight, pNombreColonneSpriteSheet, pNombreLignSpriteSheet, pNombreColonneADeduire, pImgSpriteSheet)
    local arrayQuad = {}

    counterNombreColonneSpriteSheet = 0 
    nombreTotalColonnes = pNombreLignSpriteSheet * pNombreColonneSpriteSheet 
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
        table.insert(arrayQuad, quad)
    end

    return arrayQuad
end

return decoupageSpriteSheet