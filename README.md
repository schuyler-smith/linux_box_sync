# Syncing Box using Linux Systems #

Box is a great tool for storing large data, but unlike similar services such as Dropbox, there is no app for easy access and file editing for linux. I wrote this script to simplify sending and retreiving files from Box. It works in a git-type fashion.


## Program Needed
If your Linux distro does not come with 'lftp' already installed, you will need to install that.

For Ubuntu users,

```
sudo apt-get install lftp
```

## Sync-ing Box

The shell script here uses lftp to contact your Box drive and sync the folder on your computer with the folder on Box.

## USAGE

If the file is not executable when clones, run:
```
chmod +x box_sync.sh
```

Be certain to change the username inside the script in line 3

```
USER='sdsmith@iastate.edu'
```

If you hack into my Box, you will find only disappontment.

to execute the script:
```
./box_sync.sh <options> [push][pull] <local_directory> <Box_directory>
```


### OPTIONS
the script takes a couple flags and a few other arguments.

		-h	| shows usage on the command-line
		-d 	| this flag will DELETE files that exist in the target directory and not the source. It will result in both directories being identical. ONLY USE THIS IF YOU ARE CERTAIN THERE IS NOTHING YOU NEED IN THE DIRECTORY YOU ARE TRANSFERING TO.
        [operation] |   either 'push' files from your computer to Box, or 'pull' files from Box to your computer.
        [local_folder] |    the directory on your computer that you want to sync with Box. By default this will be the pwd that you are in when the script is executed.
        [Box_folder] |  the directory in Box that you want to sync with the [local_folder], by default this is set to a folder on Box with the same name as the [local_folder]. If this needs to be changed, then [local_folder] also needs to be specified.


**Warning:** I somehow got myself locked-out with it saying I need to fill out a CAPTCHA.. resolution in the works.





