-- main.lua
local widget = require("widget")

-- Fundo da tela
local fundo = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
fundo:setFillColor(1) -- branco

-- Título
local titulo = display.newText("Meu Álbum Polaroid", display.contentCenterX, 60, native.systemFontBold, 28)
titulo:setFillColor(0)

-- Função para aplicar moldura
local function aplicarMoldura(imagemOriginal)
    local grupo = display.newGroup()

    -- Moldura
    local moldura = display.newImageRect("imagens/moldura_polaroid.png", 300, 350)
    moldura.x = display.contentCenterX
    moldura.y = display.contentCenterY
    grupo:insert(moldura)

    -- Foto centralizada na moldura
    imagemOriginal.width = 260
    imagemOriginal.height = 260
    imagemOriginal.x = moldura.x
    imagemOriginal.y = moldura.y - 20
    grupo:insert(imagemOriginal)

    -- Texto (legenda)
    local legenda = display.newText("Minha Foto", moldura.x, moldura.y + 120, native.systemFont, 18)
    legenda:setFillColor(0)
    grupo:insert(legenda)

    -- Botão para salvar imagem
    local botaoSalvar = widget.newButton({
        label = "Salvar Foto",
        x = display.contentCenterX,
        y = moldura.y + 200,
        width = 180,
        height = 40,
        shape = "roundedRect",
        cornerRadius = 10,
        fillColor = { default={0.3,0.8,0.3}, over={0.2,0.6,0.2} },
        labelColor = { default={1}, over={0.8} },
        onRelease = function()
            local nomeArquivo = "foto_" .. os.time() .. ".png"
            display.save(grupo, {
                filename = nomeArquivo,
                baseDir = system.DocumentsDirectory,
                isFullResolution = true
            })
            native.showAlert("Salvo", "Sua foto foi salva com moldura!", { "OK" })
        end
    })
end

-- Função para escolher foto da galeria
local function escolherFoto()
    local function fotoSelecionada(event)
        if event.completed and event.target then
            local imagem = display.newImage(event.target)
            aplicarMoldura(imagem)
        end
    end

    media.selectPhoto({
        mediaSource = "photoLibrary",
        listener = fotoSelecionada
    })
end

-- Botão: Escolher da Galeria
local botaoGaleria = widget.newButton({
    label = "Carregar da Galeria",
    x = display.contentCenterX,
    y = 130,
    width = 200,
    height = 40,
    shape = "roundedRect",
    cornerRadius = 10,
    fillColor = { default={0.2,0.6,1}, over={0.1,0.4,0.8} },
    labelColor = { default={1}, over={0.8} },
    onRelease = escolherFoto
})

-- Botão: Tirar Foto com a Câmera
local botaoCamera = widget.newButton({
    label = "Tirar Foto",
    x = display.contentCenterX,
    y = 190,
    width = 200,
    height = 40,
    shape = "roundedRect",
    cornerRadius = 10,
    fillColor = { default={1, 0.6, 0.2}, over={1, 0.5, 0.1} },
    labelColor = { default={1}, over={0.8} },
    onRelease = function()
        local function fotoCapturada(event)
            if event.completed and event.target then
                local imagem = display.newImage(event.target)
                aplicarMoldura(imagem)
            end
        end

        media.capturePhoto({
            listener = fotoCapturada,
            destination = {
                baseDir = system.TemporaryDirectory,
                filename = "foto_camera.jpg",
                type = "image"
            }
        })
    end
})
