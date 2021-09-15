local reseau = {}


-- Librairies externes / Requires
local http = require("socket.http")
local ltn12 = require("ltn12")


-- Resultats qui contient la version du jeu en temps réel
versionJeuOfficiel = {} -- responsesBody
local result2, code2, headers2, status2 = http.request { 
    url = "http://crz-gamestudio.com/jeu/versionJeu.php", 
    method = "GET",
    sink = ltn12.sink.table(versionJeuOfficiel)
}
versionJeuOfficiel = table.concat(versionJeuOfficiel)



-- Resultat qui renvoie "Success" ou "No Valid" concernat la clé d'accès (alpha, beta..)
function checkKeyAccessForPlay(pValueKeyAccessUser)
    local res_body = {} -- responsesBody
    local req_body = "keyAccessUser=" .. pValueKeyAccessUser

    local result, code, headers, status = http.request {
        method = "POST",
        url = "https://crz-gamestudio.com/jeu/keyAccess.php",
        source = ltn12.source.string(req_body),
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["Content-Length"] = #req_body
        },
        sink = ltn12.sink.table(res_body)
    }

    res_body = table.concat(res_body)
    
    return res_body
end



-- Resultat qui renvoie "Success" ou "Déjà existant" concernat l'inscription de l'utilisateur (nom du joueur) (renvoie pas encore fait sur scriptPHP)
function inscriptionUser(pValueNamePlayer)
    local res_body = {} -- responsesBody
    local req_body = "namePlayer=" .. pValueNamePlayer

    local result3, code3, headers3, status3 = http.request {
        method = "POST",
        url = "https://crz-gamestudio.com/jeu/inscription.php",
        source = ltn12.source.string(req_body),
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["Content-Length"] = #req_body
        },
        sink = ltn12.sink.table(res_body)
    }

    res_body = table.concat(res_body)

    return res_body
end




-- Log status, code, headers..etc :
--print('result : ' .. tostring(code3))
print('code : ' .. tostring(code3))
print('status : ' .. tostring(status3))
--print('headers : ' .. tostring(headers3))


-- Print result for Request²
print("\n")
--print("responses_body : " .. keyAccessOfficiel)
--print("responses_body : " .. versionJeuOfficiel)
--print("responses_body : " .. res_body)


return reseau