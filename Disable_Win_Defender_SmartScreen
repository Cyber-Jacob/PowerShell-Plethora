$smartscreen_path = 'HKCU:\SOFTWARE\Microsoft\Edge\SmartScreenEnabled' #Reg Value for Edge SmartScreen
$smartscreen_value = (Get-ItemProperty -Path $smartscreen_path).'(default)' #Expands the property to the value (in this case 1 or 0) to make the If statement simple to evaluate

#Evaluate if SmartScreen settings are configured, and set to 0 if it's on.
if ($smartscreen_value -ne 0){
     echo "Setting value for ($smartscreen_path\(default))"
     Set-ItemProperty -Path $smartscreen_path -Name '(default)' -Value 0 -Force
     $smartscreen_value = (Get-ItemProperty -Path $smartscreen_path).'(default)'
     }


#This statement for logging purposes. This is designed with RMM tools in mind, which will often log STD Output     
echo "Smartscreen value is set to $smartscreen_value" 
if ($smartscreen_value -eq 1){
    echo "SmartScreen registry value is $smartscreen_value. SmartScreen has not been disabled."
    }


#This statement fires if our operation works or Smartscreen was already disabled. Again, included so RMM tools will log this information. 
elseif ($smartscreen_value -eq 0){
    echo "SmartScreen registry value is $smartscreen_value. Smartscreen has been disabled."
    }
