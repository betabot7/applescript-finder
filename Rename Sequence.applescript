on run
    tell application "Finder" to set inputFiles to selection
    rename_sequence(inputFiles)
end run

on open(inputFiles)
    rename_sequence(inputFiles)
end open

on get_number(thePrompt, theDefault)
    set thePrefix to ""
    set theIcon to note
    repeat
        display dialog thePrefix & thePrompt default answer theDefault with icon theIcon
        set theNumber to text returned of result
        try
            if theNumber = "" then error
            set theNumber to theNumber as number
            exit repeat
        on error
            set thePrefix to "INVALID ENTRY! "
            set theIcon to stop
        end try
    end repeat
    return theNumber
end get_number

on rename_sequence(inputFiles)
    if length of inputFiles equals 0 then return
    tell application "Finder"
        display dialog "Are you sure you want to rename these " & (length of inputFiles) & " files?" with icon caution
        set homePath to the POSIX path of (get path to home folder)
        set renameCommand to "/usr/local/bin/python " & homePath & ".local/bin/rename-sequence"
        set theStart to my get_number("Enter start number:", 1)
        set thePrefix to (display dialog "Enter prefix:" default answer "" with icon note)
        set theSuffix to (display dialog "Enter suffix:" default answer "" with icon note)
        set theWidth to my get_number("Enter sequence width (0 = auto):", 0)
        set renameCommand to renameCommand & " -s " & theStart
        set renameCommand to renameCommand & " -w " & theWidth
        set renameCommand to renameCommand & " -P " & quoted form of thePrefix
        set renameCommand to renameCommand & " -S " & quoted form of theSuffix
        repeat with inputFile in inputFiles
            set renameCommand to renameCommand & " " & quoted form of POSIX path of inputFile
        end repeat
        set renamedFilenames to paragraphs of (do shell script renameCommand)
        set renamedFiles to {}
        repeat with renamedFilename in renamedFilenames
            set end of renamedFiles to (my POSIX file renamedFilename)
        end repeat
        reveal renamedFiles
    end tell
end rename_sequence
