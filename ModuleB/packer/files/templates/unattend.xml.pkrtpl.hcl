<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>en-US</InputLocale>
            <SystemLocale>en-US</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UserLocale>en-US</UserLocale>
            <SetupUILanguage>
                <UILanguage>en-US</UILanguage>
            </SetupUILanguage>
        </component>
        <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-PnpCustomizationsWinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
            <DriverPaths>
            <PathAndCredentials wcm:action="add" wcm:keyValue="1">
                <Path>D:\iostore</Path>
            </PathAndCredentials>
            <PathAndCredentials wcm:action="add" wcm:keyValue="2">
                <Path>D:\netkvm</Path>
            </PathAndCredentials>
            </DriverPaths>
        </component>
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DiskConfiguration>
                <Disk wcm:action="add">
                    <CreatePartitions>
                        <CreatePartition wcm:action="add">
                            <Order>1</Order>
                            <Size>512</Size>
                            <Type>EFI</Type>
                        </CreatePartition>
                        <CreatePartition wcm:action="add">
                            <Order>2</Order>
                            <Size>16</Size>
                            <Type>MSR</Type>
                        </CreatePartition>
                        <CreatePartition wcm:action="add">
                            <Order>3</Order>
                            <Size>2000</Size>
                            <Type>Primary</Type>
                        </CreatePartition>
                    </CreatePartitions>
                    <ModifyPartitions>
                        <ModifyPartition wcm:action="add">
                            <Format>FAT32</Format>
                            <Label>System</Label>
                            <Order>1</Order>
                            <PartitionID>1</PartitionID>
                        </ModifyPartition>
                        <ModifyPartition wcm:action="add">
                            <Extend>true</Extend>
                            <Format>NTFS</Format>
                            <Label>SYSTEM</Label>
                            <Letter>C</Letter>
                            <Order>2</Order>
                            <PartitionID>3</PartitionID>
                        </ModifyPartition>
                    </ModifyPartitions>
                    <DiskID>0</DiskID>
                    <WillWipeDisk>true</WillWipeDisk>
                </Disk>
                <WillShowUI>Never</WillShowUI>
            </DiskConfiguration>
            <UserData>
                <AcceptEula>true</AcceptEula>
            </UserData>
            <ImageInstall>
                <OSImage>
                    <InstallFrom>
                        <MetaData wcm:action="add">
                            <Key>/IMAGE/INDEX</Key>
                            <Value>2</Value>
                        </MetaData>
                    </InstallFrom>
                    <InstallTo>
                        <DiskID>0</DiskID>
                        <PartitionID>3</PartitionID>
                    </InstallTo>
                </OSImage>
            </ImageInstall>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <UserAccounts>
                <AdministratorPassword>
                    <Value>${password}</Value>
                    <PlainText>true</PlainText>
                </AdministratorPassword>
            </UserAccounts>
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
            </OOBE>
            <TimeZone>W. Europe Standard Time</TimeZone>
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>E:\virtio-win-guest-tools.exe /install /passive /norestart</CommandLine>
                    <Description>Install Guest Tools</Description>
                    <Order>1</Order>
                    <RequiresUserInput>false</RequiresUserInput>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>3</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c PowerShell -Command "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>4</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c PowerShell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType String -Force"</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>5</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c PowerShell -Command "Start-Service sshd"</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>6</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c PowerShell -Command "Set-Service -Name sshd -StartupType 'Automatic'"</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>7</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c winrm quickconfig -q</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>8</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c winrm quickconfig -transport:http</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>9</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c winrm set winrm/config @{MaxTimeoutms="1800000"}</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>10</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="800"}</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>11</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c winrm set winrm/config/service @{AllowUnencrypted="true"}</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>12</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c winrm set winrm/config/service/auth @{Basic="true"}</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>13</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c winrm set winrm/config/client/auth @{Basic="true"}</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>14</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="5985"}</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>15</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c netsh advfirewall firewall set rule group="windows remote management" new enable=yes</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>16</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c netsh firewall add portopening TCP 5985 "Port 5985"</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>17</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c net stop winrm</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>18</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c sc config winrm start= auto</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>19</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c net start winrm</CommandLine>
                    <Description>Add SSH feature</Description>
                </SynchronousCommand>
            </FirstLogonCommands>
            <AutoLogon>
                <LogonCount>1</LogonCount>
                <Username>Administrator</Username>
                <Enabled>true</Enabled>
                <Password>
                    <Value>${password}</Value>
                    <PlainText>true</PlainText>
                </Password>
            </AutoLogon>
        </component>
    </settings>
    <cpi:offlineImage cpi:source="wim:d:/wim/install.wim#Windows Server 2022 SERVERSTANDARD" xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>


