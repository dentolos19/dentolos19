[Setup]

AppId={#Name}
AppName={#Name}
AppVerName={#Name}
AppVersion={#Version}
AppPublisher=Dennise Catolos
AppPublisherURL=https://dennise.me
DefaultDirName={autopf}\{#Name}
LicenseFile={#LicenseFileName}
UninstallDisplayIcon={app}\{#ExecutableFileName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]

Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]

Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]

Source: "{#FilesDirName}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]

Name: "{autoprograms}\{#Name}"; Filename: "{app}\{#ExecutableFileName}"
Name: "{autodesktop}\{#Name}"; Filename: "{app}\{#ExecutableFileName}"; Tasks: desktopicon

[Run]

Filename: "{app}\{#ExecutableFileName}"; Description: "{cm:LaunchProgram,{#StringChange(Name, '&', '&&')}}"; Flags: nowait postinstall skipifsilent