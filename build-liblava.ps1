function Is-Admin() {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function main() {
    if (-not (Is-Admin)) {
        Write-Host "error: administrator privileges required"
        return 1
    }

    if (Test-Path ".\tmp\") {
        Remove-Item -Path ".\tmp\" -Recurse -Force
    }

    mkdir ".\tmp\"

    git clone "https://github.com/liblava/liblava.git" ".\tmp\liblava\"
    Push-Location ".\tmp\liblava\"

    # build binaries
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=install
    cmake --build build --config Release

    Pop-Location

    # copy binary to bin directory
    Copy-Item ".\tmp\liblava\build\Release\lava-triangle.exe" ".\AutoGpuAffinity\bin\liblava\"

    return 0
}

$_exitCode = main
Write-Host # new line
exit $_exitCode