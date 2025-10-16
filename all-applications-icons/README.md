These files need to be saved in: `home/user/.local/share/applications/`

For the different Microsoft Edge profiles, I will need to specify a different profile directory

To find the correct profile directory, run:
```
ls ~/.config/microsoft-edge/
```

This will display multiple directories and files. Ignore the files

Look at the different directories. Find out which directories correspond to a profile. For example, `Default`, `Profile 1`, `Profile 2`

For each of these directory names, try replacing the `--profile-directory=` value in the desktop file with it. For example:
```
--profile-directory=Default
--profile-directory="Profile 1"
--profile-directory="Profile 2"
```
