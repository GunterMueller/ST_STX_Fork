# This file inherits the licencing from the batch file (smalltalk.bat). (MIT)

# $executable        ... stx.com or .exe
# $log_file          ... log file name with path
# $log_file_encoding ... user defined encoding
# $append_to_log     ... should the log file be appended? (TRUE/FALSE)
# $cmd_close         ... sends either cmd /u /c (close cmd) or /u /k (cmd remains open)
# $PowerShellVersion ... detected powershell version
# $cmd_in_powershell ... should cmd.exe be used for stdout redirection? (TRUE/FALSE)
param($executable, $log_file, $log_file_encoding, $append_to_log, $cmd_close, $PowerShellVersion, $cmd_in_powershell, $stx_manual_switch_detected)


# ===========================================================================
# Reading directly from environment - due to the issues with passing quotes =
# ===========================================================================
# StX switches which are build during batch file execution $env:stx_switch
$stx_switch = [environment]::GetEnvironmentVariable("stx_switch")

# PowerShell version detected during batch file execution  $env:powershell_version_all_functionality
If (![String]::IsNullOrEmpty([environment]::GetEnvironmentVariable("powershell_version_all_functionality"))) {
    $stx_powershell_version = [environment]::GetEnvironmentVariable("powershell_version_all_functionality")
} Else {
    $host.ui.WriteErrorLine('[ERROR] Missing powershell detection variable -> powershell_version_all_functionality <-.')
    EXIT 1
}

# getting line width for the log file
If (![String]::IsNullOrEmpty([environment]::GetEnvironmentVariable("stx.__numeric.log_file_width"))) {
    $log_file_width = [environment]::GetEnvironmentVariable("stx.__numeric.log_file_width")
} Else {
    $host.ui.WriteErrorLine('[ERROR] Missing -> stx.__numeric.log_file_width <- from smalltalk.cfg file.')
    EXIT 1
}

# Defines start-sleep periods while running custom switches
If (![String]::IsNullOrEmpty([environment]::GetEnvironmentVariable("stx.__numeric.start_sleep_in_debug"))) {
    $start_sleep_period = [environment]::GetEnvironmentVariable("stx.__numeric.start_sleep_in_debug")
} Else {
    $host.ui.WriteErrorLine('[ERROR] Missing -> stx.__numeric.start_sleep_in_debug <- from smalltalk.cfg file.')
    EXIT 1
}


# =======================================================
# Adjust all variables to PowerShell style $true/$false =
# =======================================================

If ([environment]::GetEnvironmentVariable("stx.__binary.colored_stdout") -eq 'TRUE') {
    $use_color = $true
} Else {
    $use_color = $false
}

If ($cmd_in_powershell -eq 'TRUE') {
    $cmd_in_powershell = $true
} Else {
    $cmd_in_powershell = $false
}

If ($append_to_log -eq 'TRUE') {
    $append_to_log = $true
} Else {
    $append_to_log = $false
}

If ($stx_manual_switch_detected -eq 'TRUE') {
    $stx_manual_switch_detected = $true
} Else {
    $stx_manual_switch_detected = $false
}

If ($use_color) {
    # fastest way to init empty Hastable
    $saved_color = [System.Collections.Hashtable]@{}
    # save colors for later restore
    $window_private_data = (Get-Host).PrivateData
    $saved_color.Add('VerboseBackgroundColor', "$window_private_data.VerboseBackgroundColor") | Out-null; # Out-null for supressing the natural output
    $saved_color.Add('VerboseForegroundColor', "$window_private_data.VerboseForegroundColor") | Out-null
    $saved_color.Add('WarningBackgroundColor', "$window_private_data.WarningBackgroundColor") | Out-null
    $saved_color.Add('WarningForegroundColor', "$window_private_data.WarningForegroundColor") | Out-null
    $saved_color.Add('ErrorBackgroundColor', "$window_private_data.ErrorBackgroundColor") | Out-null
    $saved_color.Add('ErrorForegroundColor', "$window_private_data.ErrorForegroundColor") | Out-null
    #setting the user specified colors
    $window_private_data.VerboseBackgroundColor = [environment]::GetEnvironmentVariable("stx.stdout_VerboseBackgroundColor")
    $window_private_data.VerboseForegroundColor = [environment]::GetEnvironmentVariable("stx.stdout_VerboseForegroundColor")
    $window_private_data.WarningBackgroundColor = [environment]::GetEnvironmentVariable("stx.stdout_WarningBackgroundColor")
    $window_private_data.WarningForegroundColor = [environment]::GetEnvironmentVariable("stx.stdout_WarningForegroundColor")
    $window_private_data.ErrorBackgroundColor = [environment]::GetEnvironmentVariable("stx.stdout_ErrorBackgroundColor")
    $window_private_data.ErrorForegroundColor = [environment]::GetEnvironmentVariable("stx.stdout_ErrorForegroundColor")
} ElseIf ($cmd_in_powershell) {
    $window_private_data = (Get-Host).PrivateData
    $window_private_data.VerboseBackgroundColor = 'Black'
    $window_private_data.VerboseForegroundColor = 'Gray'
}


# ===========
# Functions =
# ===========

# Function for correct $LASTEXITCODE to ERRORLEVEL passing
function ExitWithCode {
    param (
        $exitcode
    )
    $host.SetShouldExit($exitcode)
    EXIT
} # end ExitWithCode

# To correctly write to stderr when launching from cmd.exe
# more at: https://stackoverflow.com/questions/4998173/how-do-i-write-to-standard-error-in-powershell/15669365#15669365

<#
 .SYNOPSIS
 Writes text to stderr when running in a regular console window,
 to the host''s error stream otherwise.
 
 .DESCRIPTION
 Writing to true stderr allows you to write a well-behaved CLI
 as a PS script that can be invoked from a batch file, for instance.
 
 Note that PS by default sends ALL its streams to *stdout* when invoked from 
 cmd.exe.
 
 This function acts similarly to Write-Host in that it simply calls
 .ToString() on its input; to get the default output format, invoke
 it via a pipeline and precede with Out-String.

#> 
# function Write-StdErr {
#     param (
#         [PSObject] $input_object
#     )
#     $out_function = If ($Host.Name -eq 'ConsoleHost') { 
#         [Console]::Error.WriteLine
#     } Else {
#         $host.ui.WriteErrorLine
#     }
#     If ($input_object) {
#         [void] $out_function.Invoke($input_object.ToString())
#     } Else {
#         [string[]] $lines = @()
#         $Input | % { $lines += $_.ToString() }
#         [void] $out_function.Invoke($lines -join "`r`n")
#     }
# }

# Print User message using String Array $message
function PrintMessage {
    param(
        [Parameter( `
            Mandatory=$True, `
            Valuefrompipeline = $true)]
        [String]$message
    )
    begin {}
    process {
        foreach ($Message in $Message) {
            # Write-Host Considered Harmful - see http://www.jsnover.com/blog/2013/12/07/write-host-considered-harmful/
            # first way how to correctly write it
            #Write-host $message
            # highlights warning and error messages from StX VM!
            If ($line -match '\[error\]' -or $line -match '\[sigsegv\]') {
                $host.ui.WriteErrorLine("$message")
            } ElseIf ($message -match '\[warn\]') {
                Write-Warning $message
            } Else {
                Write-Verbose -Message $message -Verbose
            } 
        }
    }
    end {}
} # end PrintMessage


# To correctly simultinously write to stdout and log file when using out-file!
# Colors the output based on string match
function Tee-Host {
    Param (
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        Position=0)]
        $message
    )
    begin {}
    Process {
        # first way how to correctly write it
        # -EV is short (an alias) for -ErrorVariable
        If ($line -match '\[error\]' -or $line -match '\[sigsegv\]') {
            # this is printing error compatible with all PS versions
            $host.ui.WriteErrorLine("$message")
        } ElseIf ($message -match '\[warning\]') {
            Write-Warning "$message"
        } Else {
            Write-Verbose -Message "$message" -Verbose
        }
        # second correct way how to write it
        #$VerbosePreference = "Continue"
        #Write-Verbose $input_object; 
        return $message
    }
    end {}
} # end Tee-Host

# Synchronously (stdout & stderr) executes Smalltalk/X executable 
# stdout & stderr are redirected together via 2>&1 redirect
function InvokeCommandExecute {
    param(
       $execute_command
    )
    try {
       "`n", "[INFO] Executing command: $execute_command" | PrintMessage
       Invoke-Expression -Command:$execute_command
       If ($lastexitcode -ne 0) {
           $result = $result -join "`n"
           throw "$result `n"
       }
    }
    catch {
        $window_private_data = (Get-Host).PrivateData
        # saving the original colors
        $saved_background_color = $window_private_data.ErrorBackgroundColor
        $saved_foreground_color = $window_private_data.ErrorForegroundColor
        # setting the new colors
        $window_private_data.ErrorBackgroundColor = 'White'
        $window_private_data.ErrorForegroundColor = 'Red'

        $host.ui.WriteErrorLine("[ERROR] happned in stx.com or PowerShell script - See log file: $log_file for more information.")
        Write-Error "`n`n[ERROR] Error from PowerShell:`n`n $_" 2>&1 | Tee-Host | Out-File -Append -Encoding $log_file_encoding -FilePath $log_file -Width $log_file_width

        $window_private_data.ErrorBackgroundColor = $saved_background_color
        $window_private_data.ErrorForegroundColor = $saved_foreground_color
    }
} # end InvokeCommandExecute


# Asynchronously output stdout & stderr while executing Smalltalk/X executable
# Note: 
# 1) for now used only while having manual switches to smalltalk.bat
# 2) Is seems to be little bit slower than the Invoke-Expression, howerver Smalltalk/X GUI
#    appears sooner than all the messages are processed so the end speed should be comparable
# 3) for now used only when manual switches (inputed by user) are detected
# 4) Will output everything from stdout/stderr even when stx executable crashes or powershell encounters an error
#    (of course not closing the powershell window)

function DebugProcessExecute {
    param(
        [Parameter(Mandatory=$true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]$executable,
        [Parameter(Mandatory=$true, Position = 1)]
        $stx_switch,
        [Parameter(Mandatory=$true, Position = 2)]
        [String]$logging_function,
        [Parameter(Mandatory=$true, Position = 3)]
        [Int]$start_sleep_period,
        [Parameter(Mandatory=$false, Position = 4)]
        [String]$verb,
        [Parameter(Mandatory=$false, Position = 5)]
        [System.Diagnostics.ProcessPriorityClass]$Priority = [System.Diagnostics.ProcessPriorityClass]::Normal
    )
    begin {
        If ($log_file_encoding -eq 'ASCII') {
            $output_encoding = New-Object -typename System.Text.ASCIIEncoding
        } ElseIf ($log_file_encoding -eq 'UTF8') {
            $output_encoding = New-Object -typename System.Text.UTF8Encoding
        } ElseIf ($log_file_encoding -eq 'UTF16') {
            $output_encoding = New-Object -typename System.Text.UnicodeEncoding
        } ElseIf ($log_file_encoding -eq 'UTF32') {
            $output_encoding = New-Object -typename System.Text.UTF32Encoding
        }
    }
    process {
        try {
           "`n", "[INFO] Executing asynchronously command: $executable $stx_switch | $logging_function" | PrintMessage

           # Setting process invocation parameters.
           $process_start_info = New-Object -TypeName System.Diagnostics.ProcessStartInfo
           $process_start_info.CreateNoWindow = $true
           $process_start_info.UseShellExecute = $false
           $process_start_info.RedirectStandardOutput = $true
           $process_start_info.StandardOutputEncoding = $output_encoding
           $process_start_info.RedirectStandardError = $true
           $process_start_info.StandardErrorEncoding = $output_encoding
           $process_start_info.FileName = $executable
           $process_start_info.Arguments = $stx_switch
        
           If (![String]::IsNullOrEmpty($verb)) {
               $process_start_info.Verb = $verb
           }
        

           # Creating process object.
           $process = New-Object -TypeName System.Diagnostics.Process
           $process.StartInfo = $process_start_info

           $passing_variable = new-object psobject -property @{file_logging = $logging_function}

           # Asynchronously listen for OutputDataReceived events on the process (stdout)
           # Note: To use all events without ForEach loop use: $event.SourceEventArgs.Data variable
           $outEvent = Register-ObjectEvent -InputObj $process `
                           -Event "OutputDataReceived" `
                           -Action `
            {
                param
                (
                    [System.Object] $sender,
                    [System.Diagnostics.DataReceivedEventArgs] $events 
                )
                # Where to log
                $file_log = $Event.MessageData.file_logging

                ForEach  ($line in $events.data) {
                    Write-Verbose "[stdout]: $line" -Verbose
                   
                    # write to the log file
                    $exec_with_logging = @"
Write-Output '[stdout]: $line' | $file_log
"@
                    Invoke-Expression -Command:$exec_with_logging
                    
                }
            } -MessageData $passing_variable
            # /Out Listener - stdout


            # # asynchronously listen for ErrorDataReceived events on the process (stderr)
            $errEvent = Register-ObjectEvent -InputObj $process `
            -Event "ErrorDataReceived" `
            -Action `
            {
                param
                (
                    [System.Object] $sender,
                    [System.Diagnostics.DataReceivedEventArgs] $events
                ) 

                $file_log = $Event.MessageData.file_logging

                ForEach  ($line in $events.data) {

                    # $line = ("[stderr]:" + $line)
                    If ($line -match '\[error\]' -or $line -match '\[sigsegv\]') {
                        $host.ui.WriteErrorLine("$line")
                    } ElseIf ($line -match '\[warn\]') {
                        Write-Warning $line
                    } Else {
                        Write-Verbose -Message $line -Verbose
                    } 
 
                    # write to the log file
                    $exec_with_logging = @"
Write-Output '$line' | $file_log
"@
                    Invoke-Expression -Command:$exec_with_logging
                }
                
            } -MessageData $passing_variable
            #  Error Listener - stderr

           # Starting process with no return value
           [Void]$process.Start()
           $process.PriorityClass = $Priority

           # Begin async read events
           $process.BeginOutputReadLine()
           $process.BeginErrorReadLine()

           # loop till application exited 
           # used for logging into the stdout/stderr
           # Note: the timeout has been tested for speed vs. process usage -> 50ms does not use CPU that much + the output is reasonably fast
           while (!$process.HasExited) { 
               [System.Console]::Out.Flush()
               [System.Console]::Error.Flush()
               Start-Sleep -Milliseconds $start_sleep_period
           }

           $exit_code = $process.ExitCode

           If ($process.ExitCode -ne 0) {
               $result = $result -join "`n"
               throw "$result `n"
           }
        }
        catch {
            # The only reliable way to flush stderr is to produce an error message
            Write-Error -Message 'An error has occurred...'

            # If an error occurrences than wait till exit - all buffers are emptied
            [System.Console]::Out.Flush()
            [System.Console]::Error.Flush()
            $process.WaitForExit()
            $process.CancelOutputRead()
            $process.CancelErrorRead()

            $window_private_data = (Get-Host).PrivateData
            # saving the original colors
            $saved_background_color = $window_private_data.ErrorBackgroundColor
            $saved_foreground_color = $window_private_data.ErrorForegroundColor
            # setting the new colors
            $window_private_data.ErrorBackgroundColor = 'White'
            $window_private_data.ErrorForegroundColor = 'Red'
        
            $host.ui.WriteErrorLine("[ERROR] happened in stx.com or PowerShell script - See log file: $log_file for more information.")
            Write-Error "`n`n[ERROR] Error from PowerShell:`n`n $_" 2>&1 | Tee-Host | Out-File -Append -Encoding $log_file_encoding -FilePath $log_file -Width $log_file_width
        
            $window_private_data.ErrorBackgroundColor = $saved_background_color
            $window_private_data.ErrorForegroundColor = $saved_foreground_color
           
            # =======================================================
            # Add Catch section Separator when adding into the file =
            # =======================================================
            If (!$is_logfile_locked){
                If ($append_to_log) {
                    Write-Output "`r`n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!`r`n" | Out-File -Append -Encoding $log_file_encoding -FilePath $log_file -Width $log_file_width
                }
            }
        }
        finally {
           # Unregister events
           If (($Null -ne $outEvent) -or ($Null -ne $errEvent)) {
               $outEvent.Name, $errEvent.Name |
               ForEach-Object {Unregister-Event -SourceIdentifier $_}
           }
        }
    }
    end {
        return $exit_code
    } 
} # end DebugProcessExecute


# =============================
# check if log file is locked =
# =============================
function Test-FileLock {
    param (
      [parameter(Mandatory=$true)][string]$path
    )
    $log_file = New-Object System.IO.FileInfo $path
    If ((Test-Path -Path $path) -eq $false) {
        return $false
    }

    try {
      $log_file_stream = $log_file.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
      If ($log_file_stream) {
          $log_file_stream.Close()
      }
      $false
    } catch {
      # file is locked by a process.
      return $true
    }
}


# ========================================================================
# Check if user did not start the PowerShell file directly - exit if yes =
# ========================================================================
If ([string]::IsNullOrEmpty($executable)) {
    "`n", '[ERROR] You can not run this powershell script directly!', 'Execute batch file (.bat) instead.' | PrintMessage
    EXIT 1
}


# ====================================
# Checking the state of the log file =
# ====================================
# Must be done only once in the file in case 
# the file is unlocked before the second instance is closed
$is_logfile_locked = Test-FileLock($log_file)


# ================
# Stdout logging =
# ================
If ($is_logfile_locked){
    "`n", "[WARN] Log file $log_file in use.`n`n  !!NO LOGGING will be available for this Smalltalk/X instance!!" | PrintMessage
    '[INFO] Press any key to continue ...' | PrintMessage
    # pause - waits for pressing any key
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-null
    If (!$cmd_in_powershell -and $stx_manual_switch_detected) {
        $logging_function = 'Out-null'
    } Else {
        $logging_function = 'Tee-Host | Out-null'
    }
} Else {
    If (!$cmd_in_powershell -and $stx_manual_switch_detected) {
        If ($append_to_log) {
            $logging_function = "Out-File -Append -Encoding '$log_file_encoding' -FilePath '$log_file' -Width $log_file_width"
        } Else {
            "`n", "[INFO] Creating a blank log file." | PrintMessage
            Write-Output $null | Out-File -Encoding $log_file_encoding -FilePath $log_file -Width $log_file_width
            $logging_function = "Out-File -Append -Encoding '$log_file_encoding' -FilePath '$log_file' -Width $log_file_width"
        }
    } Else {  
        If ($append_to_log) {
            $logging_function = "Tee-Host | Out-File -Append -Encoding $log_file_encoding -FilePath $log_file -Width $log_file_width"
        } Else {
            $logging_function = "Tee-Host | Out-File -Encoding $log_file_encoding -FilePath $log_file -Width $log_file_width"
        }
    }
}


# ===========
# Execution =
# ===========
# Decide which stdout use - either powershell.exe or cmd.exe
If ($PowerShellVersion -ge $stx_powershell_version) {
    # stdout output via powershell.exe
    If (!$cmd_in_powershell) {
        # Debug powershell mode started with stdout and stderr separation!
        If ($stx_manual_switch_detected) {
            # getting rid of all the double quotes around stx switches (were added in batch file)
            $stx_switch = $stx_switch -replace '"([-]+\w+)"', "`$1"

            $exit_code = DebugProcessExecute -executable $executable -stx_switch $stx_switch -logging_function $logging_function -start_sleep_period $start_sleep_period 

        } Else {
            $command = @"
$executable $stx_switch 2>&1 | $logging_function
"@
            # Due to the PowerShell bug produces FullyQualifiedErrorId : NativeCommandError in the log file -> you can ignore it.
            # actual execution
            InvokeCommandExecute -execute_command $command
       }
    # stdout output via cmd.exe
    # --% was introduced in PowerShell 3.0, forces PowerShell to ignore all code afterwards
    # redirection from 9 - combined (all output combined into a single - easy to redirect stream) from Powershell
    # if manual switch detected force powershell to ignore all code afterwards
    } Else {
        # check if manual switch detected
        If ($stx_manual_switch_detected) {
            # if manual switch detected force powershell to ignore all code afterwards
            $stx_switch = "--% $stx_switch"
            $command = @"
cmd.exe $cmd_close $executable $stx_switch '2^>^&1' ^| $logging_function
"@
        } Else {
            # must replace double quotes in order for the cmd.exe to work correctly - cmd.exe requirement
            $stx_switch = $stx_switch -replace '"','^"'
            $command = @"
cmd.exe $cmd_close $executable $stx_switch '2>&1' | $logging_function
"@
        }
        
        # Due to the PowerShell bug may produce an error: "FullyQualifiedErrorId : NativeCommandError" in the log file -> you can ignore it.
        # actual execution
        Write-verbose -message $command -verbose
        InvokeCommandExecute -execute_command $command
    } # end Else
} Else { # legacy powershell - manual switches available via Asynchronous mode
    # stdout output via powershell.exe
    If (!$cmd_in_powershell) {
        If ($stx_manual_switch_detected) {
            # getting rid of all the double quotes around stx switches (were added in batch file)
            $stx_switch = $stx_switch -replace '"([-]+\w+)"', "`$1"

            $exit_code = DebugProcessExecute -executable $executable -stx_switch $stx_switch -logging_function $logging_function -start_sleep_period $start_sleep_period 

        } Else {
            $command = @"
$executable $stx_switch 2>&1 | $logging_function
"@
            # Due to the PowerShell bug produces FullyQualifiedErrorId : NativeCommandError in the log file -> you can ignore it.
            # actual execution
            InvokeCommandExecute -execute_command $command
        }
    # stdout output via cmd.exe
    } Else {
        If ($stx_manual_switch_detected) {
            "`n", '[ERROR] You can not have -> __binary.cmd_in_powershell <- enabled and run manual switches with StX!' | PrintMessage
            EXIT 1
        } Else {
            # must replace double quotes in order for the cmd.exe to work correctly??
            $stx_switch = $stx_switch -replace '"','^"'
            $command = @"
cmd.exe $cmd_close $executable $stx_switch '2>&1' | $logging_function
"@
           # Due to the PowerShell bug produces FullyQualifiedErrorId : NativeCommandError in the log file -> you can ignore it.
           # actual execution
           InvokeCommandExecute -execute_command $command
        }
    }
} # end if


# ======
# Exit =
# ======
# Sending exit code to calling batch file
try {
   #If ($cmd_in_powershell -or !$stx_manual_switch_detected){
   If (![string]::IsNullOrEmpty($exit_code)){
      "`n", "[INFO] Exiting from PowerShell with code $exit_code " | PrintMessage
      ExitWithCode -exitcode $exit_code
   } Else {
      "`n", "[INFO] Exiting from PowerShell with code $LastExitCode " | PrintMessage
      ExitWithCode -exitcode $LastExitCode
   }
}
catch {
   $host.ui.WriteErrorLine("[ERROR] An error happend during exiting PowerShell.")
}
finally {
    # =========================================
    # Add Separator when adding into the file =
    # =========================================
    If (!$is_logfile_locked){
        If ($append_to_log) {
            Write-Output "`r`n=================================================================================================`r`n" | Out-File -Append -Encoding $log_file_encoding -FilePath $log_file -Width $log_file_width
        }
    }

    # ===============================
    # Restore original Shell colors =
    # ===============================
    If ($use_color) {
        $window_private_data = (Get-Host).PrivateData
        ForEach($item in $saved_color.GetEnumerator()) {
            Set-Variable -name "$window_private_data.$($item.Key)" -Value "$($item.Value)"
        }
    }
}