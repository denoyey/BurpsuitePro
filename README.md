![Screenshot_2024-09-19_17_45_09](https://github.com/user-attachments/assets/873ef98a-48e0-445b-b5dc-eb5959ad5b34)

# <h1 align="center"> Burpsuite Professional v2025 latest </h1>

<p align="center"> Burp Suite Professional is the web security tester's toolkit of choice. Use it to automate repetitive testing tasks - then dig deeper with its expert-designed manual and semi-automated security testing tools. Burp Suite Professional can help you to test for OWASP Top 10 vulnerabilities - as well as the very latest hacking techniques. Advanced manual and automated features empower users to find lurking vulnerabilities more quickly. Burp Suite is designed and used by the industry's best.</p>

<h1 align="center">

[Overview](https://portswigger.net/burp/pro)
 </h1>
 
<br></br>

<h1 align="center"> Linux Installation </h1>

<br></br>

- ### Auto Install
```sh
wget -qO- https://raw.githubusercontent.com/denoyey/BurpsuitePro/main/install.sh | sudo bash
```
- ### Run
```sh
burpsuitepro
```
<details><summary>

### Update
</summary>

> optional
```sh
cd && rm -rf BurpsuitePro && wget -qO- https://raw.githubusercontent.com/denoyey/BurpsuitePro/refs/heads/main/update.sh | sudo bash
```
</details>

<details><summary>

### Java Version
</summary>

> select the default java version
```sh
sudo update-alternatives --config java
```               
</details>

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

# <h1 align="center"> Windows Installation</h1>

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


<h1 align="center" >


 <details><summary>Credits 👇</summary>


* Loader.jar 👉 [h3110w0r1d-y](https://github.com/h3110w0r1d-y/BurpLoaderKeygen)
* Modified 👉 [cyb3rzest](https://github.com/cyb3rzest/Burp-Suite-Pro)

</details>
</h1>
