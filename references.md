# Reference Links

- [Arduino IDE Official Site](https://www.arduino.cc/en/software)
- [Arduino Reference Documentation](https://www.arduino.cc/reference/en/)
- [Arduino Forum](https://forum.arduino.cc/)
- [Arduino GitHub Repository](https://github.com/arduino/Arduino)
- [Arduino Libraries](https://www.arduino.cc/reference/en/libraries/)


# External Links
- [Arduino Portable 2.3.4 Dev Test 1](https://portableapps.com/node/68844)


    I've never used an Arduino, but I was interested in experimenting. This works for me on Win7. Because it is Electron I use CommandLineArguments=--user-data-dir="%PAL:DataDir%\arduino-ide"
    Environment variables are from https://arduino.github.io/arduino-cli/0.28/configuration/#environment-va...

    ```bat
    [Launch]
    ProgramExecutable=2.1.1\Arduino IDE.exe
    CommandLineArguments=--user-data-dir="%PAL:DataDir%\arduino-ide"
    DirectoryMoveOK=yes
    SupportsUNC=yes
    RunAsAdmin=try

    [Environment]
    ARDUINO_DIRECTORIES_DATA=%PAL:DataDir%\Arduino15
    ARDUINO_DIRECTORIES_DOWNLOADS=%PAL:DataDir%\Arduino15\staging
    ARDUINO_DIRECTORIES_USER=%PAL:DataDir%\Sketchbook
    ARDUINO_DIRECTORIES_BUILTIN_LIBRARIES=%PAL:DataDir%\Lib
    ARDUINO_DIRECTORIES_BUILTIN_TOOLS=%PAL:DataDir%\Tools
    ARDUINO_LOGGING_FILE=%PAL:DataDir%\logfile.txt

    [DirectoriesMove]
    settings\.arduinoIDE=%USERPROFILE%\.arduinoIDE
    Arduino IDE=%APPDATA%\Arduino IDE

    [FileWrite1]
    Type=Replace
    File=%PAL:DataDir%\settings\.arduinoIDE\arduino-cli.yaml
    Find=%PAL:LastDrive%%PAL:LastPackagePartialDir%\
    Replace=%PAL:Drive%%PAL:PackagePartialDir%\

    [FileWrite2]
    Type=Replace
    File=%PAL:DataDir%\settings\.arduinoIDE\arduino-cli.yaml
    Find=%PAL:LastDrive%%PAL:LastPortableAppsBaseDir%\
    Replace=%PAL:Drive%%PAL:PortableAppsBaseDir%\

    [FileWrite3]
    Type=Replace
    File=%PAL:DataDir%\settings\.arduinoIDE\arduino-cli.yaml
    Find=%PAL:LastDrive%\
    Replace=%PAL:Drive%\
    ```
