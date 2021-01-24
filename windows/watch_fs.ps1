### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $filewatcher_jpg = New-Object System.IO.FileSystemWatcher
    #Mention the folder to monitor
    $filewatcher_jpg.Path = "$(Get-Location)"
    $filewatcher_jpg.Filter = "*.JPG"
    #include subdirectories $true/$false
    $filewatcher_jpg.IncludeSubdirectories = $true
    $filewatcher_jpg.EnableRaisingEvents = $true

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    function JobImage {
        param (
            $path,
            $target_path)

        $sb = [scriptblock]::Create("& 'C:\Program Files\ImageMagick-7.0.10-Q16\magick.exe' convert -interlace Plane -gaussian-blur 0.05 -quality 85% $path $target_path")
        $job = Start-Job -ScriptBlock $sb
    }

    $writeaction = { $path = $Event.SourceEventArgs.FullPath
                if ($path -like '*converted*') {
                    return
                }
                $name = Split-Path $path -Leaf
                $filesize_0 = $(Get-Item $path).length
                $changeType = $Event.SourceEventArgs.ChangeType
                $directory = $(Get-Item $path).Directory.FullName
                $logline = "$(Get-Date), $changeType, $path, $directory"
                Add-content "FileWatcher_log.txt" -value $logline

                sleep 1
                $filesize_1 = $(Get-Item $path).length
                if ($filesize_0 -ne $filesize_1) {
                    return
                }
                New-Item -ItemType "directory" -Path "$directory\converted"
                $target_path = "$directory\converted\$name"
                if (Test-Path $target_path -PathType Leaf) {
                    return
                }
                JobImage $path $target_path
              }
### DECIDE WHICH EVENTS SHOULD BE WATCHED

#The Register-ObjectEvent cmdlet subscribes to events that are generated by .NET objects on the local computer or on a remote computer.
#When the subscribed event is raised, it is added to the event queue in your session. To get events in the event queue, use the Get-Event cmdlet.
    Register-ObjectEvent $filewatcher_jpg "Changed" -Action $writeaction
#while ($true) {sleep 5}
#
#


### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    function SimpleName {
        param (
            $PathName
        )
        $FileName = Split-Path $PathName -Leaf
        $Extension = $FileName.Split('.') | Select -Last 1
        $FileNameWoExt = $FileName.Substring(0, $FileName.Length - $Extension.Length - 1)
        return $FileNameWoExt
    }
    $writeaction = { $path = $Event.SourceEventArgs.FullPath
                if ($path -like '*converted*') {
                    return
                }
                $name = Split-Path $path -Leaf
                $filesize_0 = $(Get-Item $path).length
                $changeType = $Event.SourceEventArgs.ChangeType
                $directory = $(Get-Item $path).Directory.FullName
                $logline = "$(Get-Date), $changeType, $path, $directory"
                Add-content "FileWatcher_log.txt" -value $logline

                sleep 1
                $filesize_1 = $(Get-Item $path).length
                if ($filesize_0 -ne $filesize_1) {
                    return
                }

                New-Item -ItemType "directory" -Path "$directory\converted"
                $target_path = "$directory\converted\$(SimpleName $name).mp4"
                if (Test-Path $target_path -PathType Leaf) {
                    return
                }
                Start-Process -NoNewWindow -FilePath "D:\ffmpeg-20161218-02aa070-win64-static\bin\ffmpeg " -ArgumentList  "-i", "$path", "-movflags", "use_metadata_tags", "-c:v", "libx265", "-strict", "experimental", "-c:a", "aac", "$target_path"
              }
### DECIDE WHICH EVENTS SHOULD BE WATCHED
### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $filewatcher_mov = New-Object System.IO.FileSystemWatcher
    #Mention the folder to monitor
    $filewatcher_mov.Path = "$(Get-Location)"
    $filewatcher_mov.Filter = "*.MOV"
    #include subdirectories $true/$false
    $filewatcher_mov.IncludeSubdirectories = $true
    $filewatcher_mov.EnableRaisingEvents = $true
    Register-ObjectEvent $filewatcher_mov "Changed" -Action $writeaction

### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $filewatcher_mp4 = New-Object System.IO.FileSystemWatcher
    #Mention the folder to monitor
    $filewatcher_mp4.Path = "$(Get-Location)"
    $filewatcher_mp4.Filter = "*.MP4"
    #include subdirectories $true/$false
    $filewatcher_mp4.IncludeSubdirectories = $true
    $filewatcher_mp4.EnableRaisingEvents = $true

    Register-ObjectEvent $filewatcher_mp4 "Changed" -Action $writeaction
