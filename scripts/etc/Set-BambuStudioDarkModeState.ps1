[CmdletBinding()]
param (
    [System.Nullable[bool]] $EnableDarkMode
)


$BAMBU_STUDIO_PROCESS_NAME = "bambu-studio"
$BAMBU_STUDIO_CONFIG_FILE_PATH = "$env:APPDATA\BambuStudio\BambuStudio.conf"
$APP_JSON_KEY = "app"
$DARK_COLOR_MODE_JSON_KEY = "dark_color_mode"


if ($null -ne $EnableDarkMode) {
    Wait-Process $BAMBU_STUDIO_PROCESS_NAME -ErrorAction SilentlyContinue
    if (Test-Path $BAMBU_STUDIO_CONFIG_FILE_PATH) {
        $bambuStudioConfig = Get-Content $BAMBU_STUDIO_CONFIG_FILE_PATH
        if ($bambuStudioConfig[-1][0] -eq '#') {
            $bambuStudioConfig = $bambuStudioConfig[0..($bambuStudioConfig.Length - 2)]
        }
        $bambuStudioConfigJson = $bambuStudioConfig | ConvertFrom-Json
        $bambuStudioConfigJson.$APP_JSON_KEY | Add-Member -MemberType NoteProperty -Name $DARK_COLOR_MODE_JSON_KEY -Value "" -ErrorAction SilentlyContinue
        if ($EnableDarkMode) {
            $bambuStudioConfigJson.$APP_JSON_KEY.$DARK_COLOR_MODE_JSON_KEY = "1"
        } else {
            $bambuStudioConfigJson.$APP_JSON_KEY.$DARK_COLOR_MODE_JSON_KEY = "0"
        }
        $bambuStudioConfigJson | ConvertTo-Json -depth 32 | Set-Content $BAMBU_STUDIO_CONFIG_FILE_PATH
    }
}
