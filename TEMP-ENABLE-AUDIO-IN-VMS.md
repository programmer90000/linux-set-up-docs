1. In the host machine and the VM, run:
```
sudo apt install pipewire pipewire-audio wireplumber
```
2. In the VM, run:
```
sudo apt install labwc alacritty firefox-esr
```
3. In the VM, add the following to `.config/labwc/rc.xml` be able to open Alacritty:
```
<?xml version="1.0"?>
<labwc_config>
  <keyboard>
    <keybind key="W-Return">
      <action name="Execute">
        <command>alacritty</command>
      </action>
    </keybind>
  </keyboard>
</labwc_config>
```
4. Shutdown the VM. NOTE: I DON'T KNOW IF THIS IS REQUIRED BUT IT SHOULD BE DONE ANYWAY FOR SAFETY
5. Run:
```
virt-xml debian-13 --edit --audio type=pipewire,id=1
virt-xml debian-13 --add-device --sound model=ich9,audio.id=1
```
