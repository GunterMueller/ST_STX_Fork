#encoding iso8859-1

; $Header: /cvs/stx/stx/libbasic/resources/de.rs,v 1.10 2015-03-02 01:05:28 cg Exp $
;
; German strings
;
; this file contains 8bit national characters;
; DONT EDIT this file with an old vi !

SHORTDATEFORMAT '%D.%M.%y'
DATEFORMAT      '%D-%(ShortMonthName)-%y'
LONGDATEFORMAT  '%(DayName), den %D.%M.%y'

TIMEFORMAT      '%h:%m:%s'

'monday'      'Montag'
'tuesday'     'Dienstag'
'wednesday'   'Mittwoch'
'thursday'    'Donnerstag'
'friday'      'Freitag'
'saturday'    'Samstag'
'sunday'      'Sonntag'

'mon'         'Mo'
'tue'         'Di'
'wed'         'Mi'
'thu'         'Do'
'fri'         'Fr'
'sat'         'Sa'
'sun'         'So'

'january'     'Januar'
'february'    'Februar'
'march'       'M�rz'
'april'       'April'
'may'         'Mai'
'june'        'Juni'
'july'        'Juli'
'august'      'August'
'september'   'September'
'october'     'Oktober'
'november'    'November'
'december'    'Dezember'

'jan'         'Jan'
'feb'         'Feb'
'mar'         'Mrz'
"/ 'mar'         'M�r'  -- DIN 1355-1 says: 'Mrz' !
'apr'         'Apr'
MAY_ABBREV    'Mai'
'jun'         'Jun'
'jul'         'Jul'
'aug'         'Aug'
'sep'         'Sep'
'oct'         'Okt'
'nov'         'Nov'
'dec'         'Dez'

#if LanguageTerritory == #au
'january'     'J�nner'
#endif

;
; OS stuff...
;
'EPERM'             'Unerlaubte Operation'
'ENOENT'            'Datei oder Verzeichnis existiert nicht'
'ESRCH'             'Prozess existiert nicht'
; 'EINTR'             'Interrupted system call'
'EIO'               'I/O Fehler'
'ENXIO'             'Ger�t oder Adresse existiert nicht'
'E2BIG'             'Zu viele Argumente'
; 'ENOEXEC'           'Exec format error'
; 'EBADF'             'Bad file number'
; 'ECHILD'            'No child processes'
; 'EAGAIN'            'Try again'
; 'ENOMEM'            'Out of memory'
'EACCES'            'Fehlende Berechtigung'
; 'EFAULT'            'Bad address'
; 'EBUSY'             'Device or resource busy'
'EEXIST'            'Datei existiert bereits'
; 'EXDEV'             'Cross-device link'
'ENODEV'            'Ger�t existiert nicht'
'ENOTDIR'           'Ist kein Verzeichnis'
'EISDIR'            'Ist ein Verzeichnis'
; 'EINVAL'            'Invalid argument'
; 'ENFILE'            'File table overflow'
; 'EMFILE'            'Too many open files'
; 'ENOTTY'            'Not a typewriter'
'EFBIG'             'Datei ist zu gro�'
'ENOSPC'            'Kein Platz auf dem Ger�t'
; 'ESPIPE'            'Illegal seek'
'EROFS'             'Dateisystem ist schreibgesch�tzt'
; 'EMLINK'            'Too many links'
; 'EPIPE'             'Broken pipe'
; 'EDOM'              'Math argument out of domain'
; 'ERANGE'            'Math result not representable'
; 'EDEADLK'           'Resource deadlock would occur'
'ENAMETOOLONG'      'Dateiname ist zu lang'
; 'ENOLCK'            'No record locks available'
; 'ENOSYS'            'Function not implemented'
; 'ENOTEMPTY'         'Directory not empty'
; 'EILSEQ'            'Illegal byte sequence'
; 'ENOTBLK'           'Block device required'
; 'ETXTBSY'           'Text file busy'
; 'EWOULDBLOCK'       'Operation would block'
; 'ENOMSG'            'No message of desired type'
; 'ELOOP'             'Too many levels of symbolic links'
'ETIME'             'Zeitlimit �berschritten'
; 'ENOSR'             'Out of streams resources'
; 'ENOSTR'            'Device not a stream'
; 'ECOMM'             'Communication error on send'
; 'EPROTO'            'Protocol error'
; 'ESTALE'            'Stale NFS file handle'
; 'EREMOTE'           'Too many levels of remote in path'
; 'EINPROGRESS'       'Operation now in progress'
; 'EALREADY'          'Operation already in progress'
; 'ENOTSOCK'          'Socket operation on non-socket'
; 'EDESTADDRREQ'      'Destination address required'
; 'EMSGSIZE'          'Message too long'
; 'EPROTOTYPE'        'Protocol wrong type for socket'
; 'ENOPROTOOPT'       'Protocol not available'
; 'EPROTONOSUPPORT'   'Protocol not supported'
; 'ESOCKTNOSUPPORT'   'Socket type not supported'
; 'EOPNOTSUPP'        'Operation not supported on socket'
; 'EPFNOSUPPORT'      'Protocol family not supported'
; 'EAFNOSUPPORT'      'Address family not supported by protocol family'
; 'EADDRINUSE'        'Address already in use'
; 'EADDRNOTAVAIL'     'Can''t assign requested address'
'ETIMEDOUT'         'Zeitlimit beim Verbindungsaufbau �berschritten'
'ECONNREFUSED'      'Verbindung wurde abgelehnt'
'ENETDOWN'          'Network is down'
'ENETUNREACH'       'Netz ist nicht erreichbar'
; 'ENETRESET'         'Network dropped conn due to reset'
; 'ECONNABORTED'      'Software caused connection abort'
'ECONNRESET'        'Verbindung wurde von der Gegenseite abgebaut'
; 'EISCONN'           'Socket is already connected'
; 'ENOTCONN'          'Socket is not connected'
; 'ESHUTDOWN'         'Can''t send after socket shutdown'
; 'EHOSTDOWN'         'Host is down'
; 'EHOSTUNREACH'      'No route to host'

#if OperatingSystem isVMSlike
;
; VMS error string(s)
;
; 'EVMSERR'           'VMS system request error'
#endif

#if OperatingSystem isMSWINDOWSlike
;
; Windows error strings
;
; 'ERROR_INVALID_FUNCTION'        'Invalid function'
; 'ERROR_BAD_FORMAT'              'Bad Format'
; 'ERROR_FILE_NOT_FOUND'          'File not found'
; 'ERROR_PATH_NOT_FOUND'          'Path not found'
; 'ERROR_TOO_MANY_OPEN_FILES'     'Too many open files'
; 'ERROR_OPEN_FAILED'             'Open failed'
; 'ERROR_ACCESS_DENIED'           'Access denied'
; 'ERROR_INVALID_HANDLE'          'Invalid handle'
; 'ERROR_NOT_ENOUGH_MEMORY'       'Not enough memory'
; 'ERROR_INVALID_ACCESS'          'Invalid access'
; 'ERROR_INVALID_DATA'            'Invalid data'
; 'ERROR_INVALID_NAME'            'Invalid name'
; 'ERROR_ARENA_TRASHED'           'Arena trashed'
; 'ERROR_OUTOFMEMORY'             'Out of memory'
; 'ERROR_BROKEN_PIPE'             'Broken pipe'
; 'ERROR_GEN_FAILURE'             'Generic failure'
; 'ERROR_WRITE_PROTECT'           'Write protected'
; 'ERROR_WRITE_FAULT'             'Write fault'
; 'ERROR_READ_FAULT'              'Read fault'
; 'ERROR_HANDLE_DISK_FULL'        'Disk full'
; 'ERROR_DISK_FULL'               'Disk full'
; 'ERROR_SHARING_VIOLATION'       'Sharing violation'
; 'ERROR_LOCK_VIOLATION'          'Lock violation'
; 'ERROR_INVALID_PARAMETER'       'Invalid parameter'
; 'ERROR_NET_WRITE_FAULT'         'Net write fault'
; 'ERROR_NOT_SUPPORTED'           'Unsopported network request'
; 'ERROR_REM_NOT_LIST'            'Remote computer not available'
; 'ERROR_NETWORK_ACCESS_DENIED'   'Network access denied'
; 'ERROR_DUP_NAME'                'Duplicate name on network'
; 'ERROR_BAD_NETPATH'             'Bad network path'
; 'ERROR_NETWORK_BUSY'            'Network busy'
; 'ERROR_DRIVE_LOCKED'            'Drive locked'
; 'ERROR_INVALID_DRIVE'           'Invalid Drive'
; 'ERROR_WRONG_DISK'              'Wrong disk(ette)'
; 'ERROR_CURRENT_DIRECTORY'       'Cannot remove current directory'
; 'ERROR_CANNOT_MAKE'             'Directory or file cannot be created'
; 'ERROR_NO_MORE_FILES'           'No more files'
; 'ERROR_NOT_READY'               'Device not ready'
; 'ERROR_NOT_DOS_DISK'            'Not a DOS disk'
; 'ERROR_OUT_OF_PAPER'            'Printer is out of paper'
; 'ERROR_PRINTQ_FULL'             'Printer queue is full'
'ERROR_FILE_EXISTS'               'Datei existiert bereits'

#endif