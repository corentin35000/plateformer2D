local animationsCharactersEffectsFX = {}


-- Une table qui contient toutes les Spritesheets des animations de Particules/FX/Effets/Characters..
SpriteSheetsEffectsFX = {}
SpriteSheetsCharacters = {}

-- Tableau à deux dimensions contenant toute les animations de Particules/FX/Effets/Characters image par image.
animationsEffectsFX = {}
animationsCharacters = {}



function animationsCharactersEffectsFX.Load()
    -- animationsEffectsFX['nomAnimation'] = decoupeSpriteSheet(0, 0, imgWidth, imgHeight, 8, 14, 2, imgTileSheet)
    -- Creer la propriétée animationsEffectsFX.frames pour changer d'image dynamiquement
end


function animationsCharactersEffectsFX.Update()
 
end


function animationsCharactersEffectsFX.Draw()
    --local frameArrondie = math.floor(animationsEffectsFX.frames)
    --love.graphics.draw(imgSpriteSheet, animationsEffectsFX['nomAnimation'][frameArrondie], x, y)
end


return animationsCharactersEffectsFX