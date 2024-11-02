###########################################################################################################################################
# Author:           Jacob Schweyer                                                                                                        #
# Script Name:     Ram_clockspeed_and_ddr_info.ps1                                                                                        #
# Description:     Determine Memory type of remote or local system by DDR schema. May be incomplete.                                      #
###########################################################################################################################################

try {
$memorydetails=(get-ciminstance win32_physicalmemory); 
echo $memorydetails
echo("Configured clock speed by memory slot: 
`t" + $memorydetails.ConfiguredClockSpeed+ "")
echo("SMBIOS Memory type by slot: 
`t" + $memorydetails.SMBIOSMemorytype +"")
echo ("SMBios Memory type key: 
`t 21 = DDR2
`t 24 = DDR3
`t 26 = DDR4)
`t 34 = DDR5"
}

catch {
    echo ("An error has occured.")
    exit 1
	}
