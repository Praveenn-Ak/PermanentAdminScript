## **Permanent Admin Script for Adding Current User to Local Admin Group**

In this post, I’ll walk you through the permanent admin script I’ve developed, which automates the process of adding the current user (the explorer owner) to the local admin group. The key here is that it’s deployed via SCCM, runs silently, and requires no user interaction.

### **What the Script Does**
The script identifies the user currently running Explorer (essentially, the logged-in user) and automatically adds them to the local administrator group. It’s especially useful for those situations where you need to grant a user permanent administrative rights but don’t want to rely on manual intervention or prompts.

### **How It Works:**
1. **Identifying Explorer Owner:**  
   The script retrieves the current explorer owner by running a PowerShell command that identifies the user running `explorer.exe`, which is typically the logged-in user.

2. **Adding the User to Local Admin Group:**  
   Once the user is identified, the script uses the `Add-LocalGroupMember` cmdlet to add the user to the "Administrators" group. This grants them permanent admin rights on the machine.

3. **Silent SCCM Deployment:**  
   The script is packaged and deployed via SCCM, which allows for large-scale, automated, and silent deployments. Users won’t see any prompts or notifications—everything happens in the background.

### **Steps to Convert PowerShell Script to EXE (Optional)**  
If you want to avoid PowerShell script execution policies or make the deployment simpler, you can convert the script to an EXE using the `ps2exe` module. This is useful when pushing the script through SCCM as an EXE ensures no PowerShell-specific issues arise.

#### **Steps:**
1. **Install the ps2exe Module:**
   ```powershell
   Install-Module -Name ps2exe
   ```
   
2. **Convert the Script to EXE:**
   Run the following command to convert your `.ps1` script to an `.exe` file:
   ```powershell
   ps2exe -inputFile PermanentAdmin.ps1 -outputFile PermanentAdmin.exe
   ```

3. **Deploy EXE via SCCM:**
   Once you have the EXE file, it can be silently pushed via SCCM using the following command:
   ```bash
   cmd.exe /c start "" "PermanentAdmin.exe"
   ```
   This method ensures the script runs silently, with no user prompts or interaction required.

### **Why Use This Approach?**
- **Silent Execution:** The process is completely silent. Users won’t notice the script running, and there are no prompts to click through.
- **SCCM Compatibility:** By deploying through SCCM, this script can be scaled across thousands of devices easily, allowing for mass administration with minimal effort.
- **No User Intervention Needed:** Since it’s a silent deployment, there's no need for users to interact or approve admin access—everything is handled automatically.
  
### **Conclusion**
This permanent admin script is a simple yet powerful tool for automating the process of granting users local admin rights. Its ability to run silently and be deployed through SCCM makes it a scalable solution for IT environments. By converting it to an EXE with `ps2exe`, you can ensure smoother deployments with fewer potential issues.

Let me know if you’ve found this solution useful, and feel free to reach out with any questions or improvements!

