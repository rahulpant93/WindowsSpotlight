$sid = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value
$path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\' + $sid
$items = Get-ChildItem -Path $path | Select-Object Name

$largestKey = [bigint]$items.Name.Split("\")[-1]

$items | ForEach-Object {
    $item = [bigint]$_.Name.Split("\")[-1]
   if($item -gt $largestKey){
    $largestKey = $item 
    }
}
$path = $path +"\"+$largestKey
$landscapeImage = (Get-ItemProperty -Path $path -Name "landscapeImage").landscapeImage

$setwallpapersrc = @"
using System.Runtime.InteropServices;
public class wallpaper
{
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path )
{
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
}
}
"@
Add-Type -TypeDefinition $setwallpapersrc
[wallpaper]::SetWallpaper($landscapeImage)