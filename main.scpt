(* Detect if SmoothMouse is actually installed *)
try
    set detect to quoted form of (POSIX path of (path to resource "detect.sh"))
    do shell script ("/bin/bash " & detect)
on error errorStr number errorNumber
    if errorNumber = 65
        display alert (localized string "NOT_INSTALLED") as informational
    else
        showUnexpectedError(errorStr, errorNumber)
    end if
    quit
end

(* Uninstall *)
set confirm to display dialog (localized string "WELCOME")¬
    buttons ((localized string "CANCEL"), (localized string "CONFIRM"))¬
    cancel button (localized string "CANCEL")¬
    default button (localized string "CONFIRM")¬
    with icon 1

if button returned of confirm = (localized string "CONFIRM") then
    try
        set uninstall to quoted form of (POSIX path of (path to resource "uninstall.sh"))
        do shell script ("/bin/bash " & uninstall) with administrator privileges
        display alert (localized string "SUCCESS") as informational
    on error errorStr number errorNumber
        showUnexpectedError(errorStr, errorNumber)
    end try
end if

(* Routines *)
on showUnexpectedError(message, code)
    display alert (¬
        (localized string "UNEXPECTED") & "\n\n"¬
        & message & " Code: " & code & "."¬
    ) as critical
end