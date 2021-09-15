local reseau = {}


-- Librairies externes / Requires
local http = require("socket.http")
local ltn12 = require("ltn12")


-- Resultats qui contient la responses de la request HTTP de type GET qui contiendras la clé d'accès pour jouer
keyAccessOfficiel = {}
local result, code, headers, status = http.request { 
    url = "http://crz-gamestudio.com/jeu/keyBeta.php", 
    method = "GET",
    sink = ltn12.sink.table(keyAccessOfficiel)
}
keyAccessOfficiel = table.concat(keyAccessOfficiel)



-- Resultats qui contient la responses de la request HTTP de type GET qui contiendras version du jeu en temps réel
versionJeuOfficiel = {}
local result2, code2, headers2, status2 = http.request { 
    url = "http://crz-gamestudio.com/jeu/versionJeu.php", 
    method = "GET",
    sink = ltn12.sink.table(versionJeuOfficiel)
}
versionJeuOfficiel = table.concat(versionJeuOfficiel)



-- Requests HTTP - POST / Example
local req_body = "age=23&name=Coco" -- for the send body POST
local res_body = {} -- for the response body

local result3, code3, headers3, status3 = http.request {
    method = "POST",
    url = "https://crz-gamestudio.com/jeu/test3.php",
    source = ltn12.source.string(req_body),
    headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
        ["Content-Length"] = #req_body
    },
    sink = ltn12.sink.table(res_body)
}
res_body = table.concat(res_body)




-- Log status, code, headers..etc :
--print('result : ' .. tostring(code3))
print('code : ' .. tostring(code3))
print('status : ' .. tostring(status3))
--print('headers : ' .. tostring(headers3))


-- Print result for Request
print("\n")
--print("responses_body : " .. keyAccessOfficiel)
--print("responses_body : " .. versionJeuOfficiel)
print("responses_body : " .. res_body)


return reseau