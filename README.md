# Corona SDK - Menu Slider Library

CopyRight (C) 2017 - Leonardo Soares e Silva - lsoaresesilva@gmail.com

## Sumary

Use this library to create toolbars on Corona Labs SDK applications.
Toolbars are containers located on top and bottom of screen. 

Top container constains a background, text and up to two actions buttons. When clicked these actions opens customizable composer scenes.

Bottom container a background and up to four actions buttons. When clicked these actions opens customizable composer scenes.

## Instalation

Just copy toolbar.lua to your Corona project's folder.

## Usage

Just import the library and call new function. This functions receives a table as parameter with options to configure the top and bottom container.

Configurations for top container are:

* bgColor - (lua table) with r, g, b color values.
* textProperty - (lua table) with text properties: (optional, but must be set if filename is not defined.)
** text - (string)
** align - (string) text align on top container, can be 'left' or 'center'. Defaults to center.
** color - (lua table) with r, g, b color values.
* height - (number) height of top container. Defaults to 50.
* fileName - (string) name of file located in your main's folder. (optional)
* imageWidth - (number) width of background image (required if fileName is defined)
* imageHeight - (number) height of background image (required if fileName is defined)
* actions - (lua table) with definitions for icon actions
** defaultFile (string) - image file for this icon
** scene (string) - name of scene which will open when this icon is clicked.

## Top container with only text

```lua
-- in your main.lua
local toolbarLibrary = require("toolbar")
local toolbar = toolbar:new({
    containers = {
        topContainerProperties = { 
            bgColor = {1,0.8,0.8},
            textProperty={text="Top"},
            
        }
    }})
```

## Top container with a background image 

```lua
local menu = require("menu_slider")
local newMenu = menu:new({
    containers={
        topContainerProperties={
            fileName="img_container.png", -- this image is loaded inside a newImageRect, so its supports image scaling
            imageWidth=display.contentWidth, -- you must specify image width
            imageHeight=50 -- you must specify image height
        }
    }
    })
```
## Top container with actions

```lua
local toolbarLibrary = require("toolbar")
local toolbar = toolbar:new({
    containers = {
        topContainerProperties = { 
            bgColor = {1,0.8,0.8},
            textProperty={text="Top"},
            actions={
                {defaultFile="search_icon.png", scene="search"},
                {defaultFile="home.png", scene="home"},
            }
        }
    }})
```

## Top container and bottom container

```lua
local toolbarLibrary = require("toolbar")
local toolbar = toolbar:new({
    containers = {
        topContainerProperties = { 
            bgColor = {1,0.8,0.8},
            textProperty={text="Top"},
            actions={
                {defaultFile="search_icon.png", scene="search"},
                {defaultFile="home.png", scene="home"},
            }
        },
        bottomContainerProperties = { 
            bgColor = {0.8,0.8,0.8},
            actions={
                {defaultFile="search_icon.png", scene="opa"},
                {defaultFile="home.png", scene="2"},
                {defaultFile="Icon-60.png", scene="ola"},
                {defaultFile="search_icon.png", scene="4"},
            }
        },
    }})
```


# APIDOC

