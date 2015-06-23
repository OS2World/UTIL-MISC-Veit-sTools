MAXDEVCLASSNAMELEN	EQU	16      
MAXDEVCLASSTABLES	EQU	2        
MAXDISKDCENTRIES	EQU	32    
MAXMOUSEDCENTRIES	EQU	3    

DevClassTableEntry	STRUC
DCOffset	DW	?
DCSelector	DW	?
DCFlags	DW	?
DCName	DB	MAXDEVCLASSNAMELEN DUP (?)
DevClassTableEntry	ENDS


DevClassTableStruc	STRUC
DCCount	DW	?
DCMaxCount	DW	?
DCTableEntries	DB	SIZE DevClassTableEntry * 1 DUP (?)
DevClassTableStruc	ENDS

