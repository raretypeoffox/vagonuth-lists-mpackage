-- Script: VagoInvInstall
-- Attribute: isActive

-- Script Code:
-- Installed with: lua installPackage("https://github.com/raretypeoffox/vagonuth-lists-mpackage/releases/latest/download/Vagonuth-Inventory-Mgmt.mpackage")
VagoInv = VagoInv or {}
VagoInv.Version = "v1.0.7"
VagoInv.OnlinePath = "https://github.com/raretypeoffox/vagonuth-lists-mpackage/releases/latest/download/"
VagoInv.OnlineVersionFile = "https://raw.githubusercontent.com/raretypeoffox/vagonuth-lists-mpackage/main/versions.lua"
VagoInv.ProfileName = getProfileName():lower()
VagoInv.DownloadPath = getMudletHomeDir().."/vagonuth inv package/"
VagoInv.Downloading = false

function VagoInv:DownloadVersionFile()
    if not io.exists(VagoInv.DownloadPath) then lfs.mkdir(VagoInv.DownloadPath) end
    local filename = "versions.lua"
    VagoInv.Downloading=true
    downloadFile(VagoInv.DownloadPath .. filename, VagoInv.OnlineVersionFile)
end

function VagoInv:CheckVersion()
    local path = VagoInv.DownloadPath .. "versions.lua"
    local versions = {}
    
    table.load(path, versions)
    local pos = table.index_of(versions, VagoInv.Version) or 0
    local line = ""
    if pos ~= #versions then
        cecho("<white>Newer version of Vagonuth Inventory Management Package available\n")
        cecho("<white>Type the command <yellow>idownload <white>to update\n")
      end
end

function VagoInv:UpdateVersion()
    if VagoInv.downloadFileHandler then
        killAnonymousEventHandler(VagoInv.downloadFileHandler)
    end
    if table.contains(getPackages(),"Vagonuth-Inventory-Mgmt") then
        uninstallPackage("Vagonuth-Inventory-Mgmt")
      end
    installPackage(VagoInv.OnlinePath .. "Vagonuth-Inventory-Mgmt.mpackage")
end

function VagoInv:onFileDownloaded(event, ...)
    if event == "sysDownloadDone" and VagoInv.Downloading then
        local file = arg[1]
        if string.ends(file,"/versions.lua") then
            VagoInv.Downloading=false
            VagoInv:CheckVersion()
        end
    end
end

VagoInv.downloadFileHandler = VagoInv.downloadFileHandler or nil

if VagoInv.downloadFileHandler then
    killAnonymousEventHandler(VagoInv.downloadFileHandler)
end

VagoInv.downloadFileHandler = registerAnonymousEventHandler("sysDownloadDone","VagoInv:onFileDownloaded")

tempTimer(2, [[VagoInv.DownloadVersionFile()]])