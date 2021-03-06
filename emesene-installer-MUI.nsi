;--------------------------------
# Compressor Type
    SetCompressor /SOLID lzma

;--------------------------------
# Includes

    ; Modern UI
    !include "MUI2.nsh"

;--------------------------------
# Defines

    ;Program info
    !define PROGRAM_NAME "emesene" ; emesene
    !define PROGRAM_VERSION "2.11.6devel"
    !define PROGRAM_TYPE "installer"
    !define PROGRAM_PUBLISHER "emesene team"
    !define PROGRAM_WEBSITE "http://www.emesene.org"
    !define PROGRAM_ISSUE "https://github.com/emesene/emesene/issues/"

    ; File info
    !define FILE_DIRECTORY "emesene2" ; emesene2
    !define FILE_EXE "emesene.exe" ; emesene.exe
    !define FILE_DEBUG "emesene_debug.exe" ; emesene_debug.exe
    !define FILE_UNINSTALL "uninstall.exe"

    ; Shortcut info
    !define SHORTCUT_STARTMENU "$SMPROGRAMS\${FILE_DIRECTORY}"
    !define SHORTCUT_EXE "emesene2.lnk" ; emesene2
    !define SHORTCUT_DEBUG "emesene2 (Debug).lnk" ; emesene2 (Debug).lnk
    !define SHORTCUT_REPORT "Report Issue.lnk"
    !define SHORTCUT_UNINSTALL "Uninstall.lnk"

    ; Registry info
    !define REG_HIVE "HKCU" ; HKLM = HKEY_LOCAL_MACHINE | HKCU = HKEY_CURRENT_USER
    !define REG_INSTALL "Software\${FILE_DIRECTORY}"
    !define REG_UNINSTALL "Software\Microsoft\Windows\CurrentVersion\Uninstall\${FILE_DIRECTORY}"

;--------------------------------
# General

    ; Name and output file
    Name "${PROGRAM_NAME} ${PROGRAM_VERSION}"
    OutFile "${PROGRAM_NAME}-${PROGRAM_VERSION}-${PROGRAM_TYPE}.exe"

    ; The default installation directory
    InstallDir "$PROGRAMFILES\${FILE_DIRECTORY}"

    ; Get installation folder from registry if available
    InstallDirRegKey ${REG_HIVE} "${REG_INSTALL}" "Install_Dir"

    ;Request application privileges for Windows Vista/7
    RequestExecutionLevel admin

;--------------------------------
# MUI Settings

    !define MUI_ABORTWARNING
    !define MUI_HEADERIMAGE
    !define MUI_HEADERIMAGE_BITMAP "windows\header.bmp"
    !define MUI_ICON "windows\emesene.ico"
    !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

    ;Remember the installer language
    !define MUI_LANGDLL_REGISTRY_ROOT "${REG_HIVE}" 
    !define MUI_LANGDLL_REGISTRY_KEY "${REG_INSTALL}" 
    !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

;--------------------------------
# Pages

    ; Installer pages
    !insertmacro MUI_PAGE_WELCOME
    !insertmacro MUI_PAGE_LICENSE "GPL"
    !insertmacro MUI_PAGE_COMPONENTS
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_PAGE_FINISH

    ; Uninstaller pages
    !insertmacro MUI_UNPAGE_WELCOME
    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES
    !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
# Languages

    !insertmacro MUI_LANGUAGE "English"
    !insertmacro MUI_LANGUAGE "French"
    !insertmacro MUI_LANGUAGE "Italian"
    !insertmacro MUI_LANGUAGE "Spanish"

;--------------------------------
;Reserve Files

    !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
# Functions
    
    Function .onInit
        ; Select language on installer start
        !insertmacro MUI_LANGDLL_DISPLAY
    FunctionEnd

    ; Register uninstaller into Add/Remove panel (for local user only)
    Function RegisterApplication
        WriteRegStr ${REG_HIVE} "${REG_UNINSTALL}" "DisplayName" "${PROGRAM_NAME}"
        WriteRegStr ${REG_HIVE} "${REG_UNINSTALL}" "DisplayIcon" "$\"$INSTDIR\${FILE_EXE}$\""
        WriteRegStr ${REG_HIVE} "${REG_UNINSTALL}" "Publisher" "${PROGRAM_PUBLISHER}"
        WriteRegStr ${REG_HIVE} "${REG_UNINSTALL}" "DisplayVersion" "${PROGRAM_VERSION}"
        WriteRegStr ${REG_HIVE} "${REG_UNINSTALL}" "HelpLink" "${PROGRAM_ISSUE}"
        WriteRegStr ${REG_HIVE} "${REG_UNINSTALL}" "URLInfoAbout" "${PROGRAM_WEBSITE}"
        WriteRegStr ${REG_HIVE} "${REG_UNINSTALL}" "InstallLocation" "$\"$INSTDIR$\""
        WriteRegDWORD ${REG_HIVE} "${REG_UNINSTALL}" "NoModify" 1
        WriteRegDWORD ${REG_HIVE} "${REG_UNINSTALL}" "NoRepair" 1
        WriteRegStr ${REG_HIVE} "${REG_UNINSTALL}" "UninstallString" "$\"$INSTDIR\${FILE_UNINSTALL}$\""
    FunctionEnd

    ; Deregister uninstaller from Add/Remove panel
    Function un.DeregisterApplication
        DeleteRegKey ${REG_HIVE} "${REG_UNINSTALL}"
    FunctionEnd

;--------------------------------
# Installer Sections

    ; Main installation (Required)
    Section "${PROGRAM_NAME} ${PROGRAM_VERSION}" secInstall
        SectionIn RO

        SetOutPath "$INSTDIR"
        ;SetOverwrite on
        File /r "dist\*.*" ; dist\*.*

        ; Store installation folder
        WriteRegStr ${REG_HIVE} "${REG_INSTALL}" "Install_Dir" "$INSTDIR"

        ; Create uninstaller
        Call RegisterApplication
        WriteUninstaller "$INSTDIR\${FILE_UNINSTALL}"
    SectionEnd

    /*
    ; Plug-ins (Optional)
    Section "Plug-ins" SecPlugins
        ;Plug-ins here :)
    SectionEnd
    */

    ; Desktop Shortcuts (Optional)
    Section "Desktop Shortcuts"  secDesktop
        CreateShortCut "$DESKTOP\${SHORTCUT_EXE}" "$INSTDIR\${FILE_EXE}" "" "$INSTDIR\${FILE_EXE}" 0
    SectionEnd

    ;/*
    ; StartMenu Shortcuts (Optional)
    Section "StartMenu Shortcuts" secStartMenu
        SetShellVarContext current
        CreateDirectory "${SHORTCUT_STARTMENU}"
        CreateShortCut "${SHORTCUT_STARTMENU}\${SHORTCUT_EXE}" "$INSTDIR\${FILE_EXE}" "" "$INSTDIR\${FILE_EXE}" 0
        CreateShortCut "${SHORTCUT_STARTMENU}\${SHORTCUT_DEBUG}" "$INSTDIR\${FILE_DEBUG}" "" "$INSTDIR\${FILE_DEBUG}" 0
        CreateShortCut "${SHORTCUT_STARTMENU}\${SHORTCUT_REPORT}" "${PROGRAM_ISSUE}"
        CreateShortCut "${SHORTCUT_STARTMENU}\${SHORTCUT_UNINSTALL}" "$INSTDIR\${FILE_UNINSTALL}" "" "$INSTDIR\${FILE_UNINSTALL}" 0
    SectionEnd
    ;*/

;--------------------------------
# Descriptions

    ; Language strings
    LangString DESC_secInstall ${LANG_ENGLISH} "Install"
    LangString DESC_secInstall ${LANG_FRENCH} "Install (French)"
    LangString DESC_secInstall ${LANG_ITALIAN} "Install (Italian)"
    LangString DESC_secInstall ${LANG_SPANISH} "Install (Spanish)"

    LangString DESC_secDesktop ${LANG_ENGLISH} "Desktop Shortcuts"
    LangString DESC_secDesktop ${LANG_FRENCH} "Desktop (French)"
    LangString DESC_secDesktop ${LANG_ITALIAN} "Desktop (Italian)"
    LangString DESC_secDesktop ${LANG_SPANISH} "Desktop (Spanish)"

    LangString DESC_secStartMenu ${LANG_ENGLISH} "StartMenu Shortcuts"
    LangString DESC_secStartMenu ${LANG_FRENCH} "StartMenu (French)"
    LangString DESC_secStartMenu ${LANG_ITALIAN} "StartMenu (Italian)"
    LangString DESC_secStartMenu ${LANG_SPANISH} "StartMenu (Spanish)"

    ; Assign language strings to sections
    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${secInstall} $(DESC_secInstall)
        !insertmacro MUI_DESCRIPTION_TEXT ${secDesktop} $(DESC_secDesktop)
        !insertmacro MUI_DESCRIPTION_TEXT ${secStartMenu} $(DESC_secStartMenu)
    !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
# Uninstaller Sections

    Section "Uninstall"
        ; Removes install directory (no data is stored there anyway)
        Delete "$INSTDIR\${FILE_UNINSTALL}"
        RMDir /r "$INSTDIR"

        ; Removes Desktop shortcuts
        Delete $DESKTOP\${SHORTCUT_EXE}"

        ; Removes StartMenu shortcuts
        SetShellVarContext current
        Delete "${SHORTCUT_STARTMENU}\*.*"
        RMDir /r "${SHORTCUT_STARTMENU}"

        ;Remove uninstaller
        Call un.DeregisterApplication
    SectionEnd