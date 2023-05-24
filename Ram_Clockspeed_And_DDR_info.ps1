try {
$memorydetails=(get-ciminstance win32_physicalmemory); 
echo $memorydetails
echo("Configured clock by memory slot: 
`t" + $memorydetails.ConfiguredClockSpeed+ "")
echo("SMBIOS Memory type by slot: 
`t" + $memorydetails.SMBIOSMemorytype +"")
echo ("SMBios Memory type key: 
`t 21 = DDR2
`t 24 = DDR3
`t 26 = DDR4")
}

catch {
    echo ("An error has occured.")
    exit 1
	}
