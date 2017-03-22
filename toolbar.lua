--[[
    TODO (prioridade):
        * Permitir top container personalizado para cada scena
        * Personalizar para que a altura de TOP e BOTTOM containers seja proporcional a resolução do aparelho (5)
        * Permitir customizar o action de cada ação e usar listeners personalizados(5)
        * Permitir usar uma imagem que indique que o item está selecionado
        * Permitir mais que 2 actions [usar mecanismo do ActionBar do Android] (4)
        * Permitir colocar um botão do tipo share
        * Adicionar a barra inferior
            ** Deve ser possivel ter dois ícones para as actions, um sem seleção e outro com seleção
            ** A cena selecionada pela action deve ter seu ícone destacado

]]

local composer = require("composer")
local widget = require("widget")
toolbar = {
    currentScene = 0
}

function toolbar:createContainers(options)
    if options.topContainerProperties ~= nil then
        self:createTopContainer(options.topContainerProperties)
    end
    if options.bottomContainerProperties ~= nil then
        self:createBottomContainer(options.bottomContainerProperties)
    end
end

function toolbar:createActions(actionsProperties, container)

    local actionsCreated = {}
    -- actually a max of 2 actions are allowed. 
    -- TODO: create a trigger 3 dots like android to show hidden actions on top container
    local counterStop
    local actionIconSize
    
    if container == "top" then
        counterStop = 2
        actionIconSize = 30 -- TODO: 30 is a fixed value for icons width, TODO: make it dynamic
    else
        counterStop = 4
        actionIconSize = 50
        --spaceBetweenActions = display.contentWidth/5 -- with 4 actions there are 5 spaces between them and between screen.
    end

    for i = 1, #actionsProperties do
        local action = {}
        if counterStop == 0 then
            break
        end
        counterStop = counterStop -1
        
        local previousAction = actionsCreated[i-1]
        local x
        local y
        
        -- if theres an action, reposition it!
        if previousAction ~= nil then 
            if container == "top" then    
                x = previousAction.icon.x
                previousAction.icon.x = x-(actionIconSize+10) -- 40 is a fixed value for icons width, TODO: make it dynamic
            else
                local spaceBetweenActions = (self.menuBottomContainer.width-#actionsProperties*actionIconSize)/(#actionsProperties+1)
                
                x = (previousAction.icon.x+actionIconSize)+spaceBetweenActions
            end
            y = previousAction.icon.y
        else
            if container == "top" then   
                
                x = self.menuTopContainer.width-(actionIconSize+10)
                
                y = self.menuTopContainer.height-(actionIconSize+10)
            else
                -- se tiver apenas um actionsProperties então o pos é central
                if #actionsProperties == 1 then
                    x = (self.menuBottomContainer.width-actionIconSize)*0.5
                else
                    print("lala")
                    x = (self.menuBottomContainer.width-#actionsProperties*actionIconSize)/(#actionsProperties+1)
                    
                --x = self.menuBottomContainer.width-(actionIconSize+10)
                
                end
                y = display.contentHeight-(actionIconSize+10)
            end
            print("x primeiro = ")
            print(x)
        end

        if actionsProperties[i].defaultFile ~= nil and actionsProperties[i].scene ~= nil then
            local iconOptions = {
                defaultFile=actionsProperties[i].defaultFile,
                width=actionIconSize,
                height=actionIconSize
            }
            if actionsProperties[i].overFile ~= nil then
                iconOptions.overFile = actionsProperties[i].overFile 
            end
            local icon = widget.newButton(iconOptions) 
            
            icon.x = x
            icon.y = y
            icon.anchorX = 0
            icon.anchorY = 0
            icon:addEventListener("touch", 
                function(event)
                    if event.phase == "ended" then
                        if container == "bottom" then
                            -- remove selected icon from oldCurrentScene
                            if self.currentScene ~= 0 then
                                
                                for i=1, #self.menuBottomContainer.actions do
                                    if self.currentScene == self.menuBottomContainer.actions[i].scene then
                                        
                                        self.menuBottomContainer.actions[i].icon:setFillColor(1,1,1)
                                        break
                                    end
                                end
                            end
                            -- set icon style as selected
                            self.currentScene = actionsProperties[i].scene
                            icon:setFillColor(0,1,0)
                        end
                        -- mudar o icone e deixar selecionado
                        composer.gotoScene(actionsProperties[i].scene)
                    end
                end
            )

            action.icon = icon
            action.scene = actionsProperties[i].scene

            table.insert(actionsCreated,action)
        end
    end

    return actionsCreated
end

function toolbar:createBottomContainer(options)

    self.menuBottomGroup = display.newGroup()
    self.menuBottomGroup.anchorX = 0.0
    self.menuBottomGroup.anchorY = 0.0

    
    self.menuBottomContainer = display.newRect(0,display.contentHeight-options.height, display.contentWidth, options.height) 
    self.menuBottomContainer:setFillColor(unpack(options.bgColor))

    self.menuBottomContainer.anchorX = 0
    self.menuBottomContainer.anchorY = 0
    self.menuBottomGroup:insert(self.menuBottomContainer)
    
    self.menuBottomContainer.actions = self:createActions(options.actions, "bottom")
end

function toolbar:createTopContainer(options)

    self.menuTopGroup = display.newGroup()
    self.menuTopGroup.anchorX = 0.0
    self.menuTopGroup.anchorY = 0.0

    if options.fileName == nil then -- its not a image, so render a rect
        self.menuTopContainer = display.newRect(0,0, display.contentWidth, options.height) 
        
        self.menuTopContainer:setFillColor(unpack(options.bgColor))

        local x
        local y
        if( options.textProperty.align == "center") then
            x=self.menuTopContainer.width*0.5
        elseif options.textProperty.align == "left" then
            if options.trigger == true then
                x = self.menuTopContainer.width*0.25
            else
                x = self.menuTopContainer.width*0.1
            end
        end

        y=self.menuTopContainer.height*0.5

        self.menuTopContainer.text = display.newText({text=options.textProperty.text, x=x, y=y, font=native.systemFontBold, fontSize=20})
        self.menuTopContainer.text:setFillColor(unpack(options.textProperty.color))
    else
        if options.imageHeight == nil or options.imageWidth == nil then
            error("If using image you must specify imageHeight and imageWidth")
        else
            self.menuTopContainer = display.newImageRect(options.fileName, options.imageWidth, options.imageHeight)
        end
    end

    self.menuTopContainer.anchorX = 0
    self.menuTopContainer.anchorY = 0
    self.menuTopGroup:insert(self.menuTopContainer)

    local xBase = display.contentWidth*0.05
    local yBase = 15
    local strokeWidth = 3
    local triggerWidth = 30
    
    if options.trigger == true then
        print("trigger")
        local dashOne = display.newLine(xBase, yBase, xBase+triggerWidth, yBase) 
        local dashTwo = display.newLine(xBase, yBase+10, xBase+triggerWidth, yBase+10)
        local dashThree = display.newLine(xBase, yBase+20, xBase+triggerWidth, yBase+20)
        
        dashOne.strokeWidth = 3
        dashTwo.strokeWidth = 3
        dashThree.strokeWidth = 3

        dashOne:setStrokeColor(unpack(options.dashColor))
        dashTwo:setStrokeColor(unpack(options.dashColor))
        dashThree:setStrokeColor(unpack(options.dashColor))
        
        self.menuTopContainer.trigger = display.newGroup()
        self.menuTopContainer.trigger:insert(dashOne)
        self.menuTopContainer.trigger:insert(dashTwo)
        self.menuTopContainer.trigger:insert(dashThree)

        self.menuTopGroup:insert(self.menuTopContainer.trigger)
        -- its just a transparent rect to wrap the dashs and receive touch events
        local triggerRect = display.newRect(xBase, yBase, triggerWidth, 25)
        triggerRect:setFillColor(0,0,0,0.01) -- cannot use alpha 0 because it will not get touch events Corona Bug?!
        triggerRect.anchorX = 0
        triggerRect.anchorY = 0

        self.menuTopContainer.trigger:insert(triggerRect)
        self.menuTopContainer.trigger.touch = function( self, event )
            if ( event.phase == "began" ) then
                event.target.menuRef:handleVisualization()
            end
        end
    end
    
    self:createActions(options.actions, "top")
end

function toolbar:new(options)

    options = options or {}
    options.data = options.data or {}
    options.containers = options.containers or {}
    options.containers.topContainerProperties = options.containers.topContainerProperties or nil
    options.containers.bottomContainerProperties = options.containers.bottomContainerProperties or nil
    if options.containers.topContainerProperties ~= nil then
        options.containers.topContainerProperties.height = options.containers.topContainerProperties.height or 50 -- TODO: use a proportional value based on screen size
        options.containers.topContainerProperties.bgColor = options.containers.topContainerProperties.bgColor or {}
        options.containers.topContainerProperties.fileName = options.containers.topContainerProperties.fileName or nil
        options.containers.topContainerProperties.imageWidth = options.containers.topContainerProperties.imageWidth or nil
        options.containers.topContainerProperties.imageHeight = options.containers.topContainerProperties.imageHeight or nil
        options.containers.topContainerProperties.dashColor = options.containers.topContainerProperties.dashColor or {}
        options.containers.topContainerProperties.textProperty = options.containers.topContainerProperties.textProperty or {}
        options.containers.topContainerProperties.textProperty.text = options.containers.topContainerProperties.textProperty.text or ""
        options.containers.topContainerProperties.textProperty.align = options.containers.topContainerProperties.textProperty.align or "center"
        options.containers.topContainerProperties.textProperty.color = options.containers.topContainerProperties.textProperty.color or {}
        
        options.containers.topContainerProperties.trigger = options.containers.topContainerProperties.trigger or false
        options.containers.topContainerProperties.actions = options.containers.topContainerProperties.actions or {}
    end

    if options.containers.bottomContainerProperties ~= nil then
        options.containers.bottomContainerProperties.height = options.containers.bottomContainerProperties.height or 80 -- TODO: use a proportional value based on screen size
        options.containers.bottomContainerProperties.bgColor = options.containers.bottomContainerProperties.bgColor or {}
    end
    self:createContainers(options.containers)
    
    return self
end

return toolbar