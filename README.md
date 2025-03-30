<h1 align="center"> Burpsuite Professional v2025 latest </h1>

<p align="center"> Burp Suite Professional is a security tool for testing web applications. It allows users to monitor and modify data traffic between the browser and the server, search for vulnerabilities like SQL injection or XSS, and conduct attacks to test security. Burp Suite Professional includes features like Proxy, Scanner, Intruder, Repeater, and Decoder to analyze and identify security issues. This paid version is more comprehensive than the free version and is widely used by security professionals to secure web applications.</p>

<br>

![Screenshot_2024-09-19_17_45_09](https://github.com/denoyey/BurpsuitePro/blob/49c5bb9d4564464363ae42071cf9042f81c37dec/BurpsuitePro-v2025.png)

 <br>

<h1 align="center">
 <a href="https://portswigger.net/burp/pro">Web BurpsuitePro</a>
</h1>

<br>

![Screenshot_2024-09-19_17_45_09](https://github.com/denoyey/BurpsuitePro/blob/05c541e774b6ee51e0911e3fe5893d029268e905/Web-BurpsuitePro.png)

<br>

<h1 align="center"> Linux Installation </h1>

<br>

### Auto Install
```sh
wget -qO- https://raw.githubusercontent.com/denoyey/BurpsuitePro/main/install.sh | sudo bash
```

### Run
```sh
burpsuitepro
```

### Update
> optional
```sh
cd && rm -rf BurpsuitePro && wget -qO- https://raw.githubusercontent.com/denoyey/BurpsuitePro/refs/heads/main/update.sh | sudo bash
```

### Java Version
> select the default java version
```sh
sudo update-alternatives --config java
```               

- ### Setup Licenses

<div align="center">
 <img src="https://github.com/denoyey/BurpsuitePro/blob/ee5ddaed3df3a206e2587e5e8abd5b538500bbec/Launcher.png" />
</div>
 
Note: Copy the license from loader to the burpsuite > manual activation > copy burpsuite request key to loader request >  copy response key to the burpsuite.

- ### Create a Launcher (xfce)

     right click the desktop -> create a launcher name it Burpsuite Professional, add command `burpsuitepro` and select burpsuite community icon.

<div align="center">
 <img src="https://github.com/denoyey/BurpsuitePro/blob/ee5ddaed3df3a206e2587e5e8abd5b538500bbec/Launcher.png" />
</div>

<br><br>

<h1 align="center"> Windows Installation</h1>

<br>
 
- Make a `Burp` directory name in `C Drive` for faster access.

- Download [install.ps1](https://codeload.github.com/denoyey/BurpsuitePro/zip/refs/heads/main) and extract move the file inside to `C:\Burp`

- Open `Powershell` as administrator and execute below command to set Script Execution Policy.


      Set-ExecutionPolicy -ExecutionPolicy bypass -Scope process

- Inside PowerShell go to `cd C:\Burp`

- Now Execute `install.ps1` file in Powershell to Complete Installation.

      ./install.ps1
 
- Change the icon of `Burp-Suite-Pro.vbs` to the given icon 

- Create a shortcut to Desktop. Right Click over `Burp-Suite-Pro.vbs` Go to Shortcut tab, and below there is `Change Icon` tab

- Click there and choose the `burp-suite.ico` from `C:\Burp\`

   <div align="center">
    
    <img src="https://user-images.githubusercontent.com/29830064/230825172-16c9cfba-4bca-46a4-86df-b352a4330b12.png">
</div>

- For Start Menu Entry, copy `Burp-Suite-Pro.vbs` file to 

      C:\ProgramData\Microsoft\Windows\Start Menu\Programs\

<br>

<h3 align="left" >
 <details><summary>Credits</summary>

#### Loader.jar by - [h3110w0r1d-y](https://github.com/h3110w0r1d-y/BurpLoaderKeygen)
#### Modified by - [denoyey](https://github.com/denoyey/BurpsuitePro)

</details>
</h4>
