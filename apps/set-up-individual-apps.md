# Set Up Individual Apps

## Thunderbird

- Go to `Settings > Add-ons and Themes > Themes`
- Enable `Dark` theme

## KeePassXc

1. Click `Create Database`
2. Set the name to `Passwords`
3. Click `Continue`
4. Set the `Database format` to the recommended option
5. Set the `Encryption Settings` to `Basic`. Do **not** change any `Advanced` settings
6. Set the `Decryption Time` to `1.0 sec`
7. Select `Continue`
8. Set the `Password` to a strong password different to your user password
9. Select `Add additional protection...`
10. Select `Add Key File`
11. Select `Generate`
12. Set it to `~/.config/keepassxc/passwords.keyx`
13. Select `Done`
14. Save the database as `~/.config/keepassxc/Passwords.kdbx`
15. Go to `Settings > Browser integration`
16. Enable `Browser Integration`
17. Enable `Brave`
18. For each website, create a new password. Set the `Title`, `Username`, `Password` and `URL`
19. Press `Ok`
20. Open `Brave browser`
21. Go to the `Extensions` page
22. Install the `KeePassXC-Browser` extension by `https://keepassxc.org/`. The publisher should have a tick before the name. Hovering over the name should reveal the message: `Created by the owner of the listed website. The publisher has a good record with no history of violations.`
23. Click `Add to Brave`
24. Click on the extension
25. Click `Connect`
26. Set the name of the connection to `brave-browser`
27. Open each website
28. This should open `Keepassxc`. Enable `Remember`. Click `Allow Selected`
29. When asked to save the password in Brave browser, select `Never`
