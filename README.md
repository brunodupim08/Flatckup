# Flatckup
Backs up the list of installed flatpaks and also installs from an existing list.

	usage:

		flatckup [OPTION] [FILE-NAME]

            flatckup -b 'backup-name-file'
            flatckup -b 'backup-name-file' -p 'path'

            flatckup -r 'backup.txt'

    -b|--backup)        Create a backup file.
    -p|--path)          Path to save backup.

    -r|--restore)       Restore programs with backup file.
    
    --version)          Show version.

    "