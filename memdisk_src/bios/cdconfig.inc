Title   user configuration for filenames

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; directory and filename, upcase!
                        ; directory on cdrom
                        ; and file in that directory (second code part)

cd_boot_directory       equ 'BOOTIMGS'
cd_boot_memboot_bin     equ 'MEMBOOT.BIN'


IFNDEF cdloader

                        ; fixed format (8.3) filenames, upcase!
                        ; these files will not copied from primary source

nocopyfiles_start       label file83

                        file83 <'CDLOADER','BIN'> ; memboot.bin is already loaded
                        file83 <'MEMBOOT ','BIN'> ; memboot.bin is already loaded
                        file83 <'MEMBOOT ','SEK'> ; bootsector for memboot.bin
                        file83 <'MEMBOOT ','SEC'> ; bootsector for memboot.bin
                        file83 <'WBOOT   ','EXE'> ; write boot sector to file tool
                       ;file83 <'BOOTDISK','IMG'> ; 2.88/.. disk image for traditional CD emulation
                        file83 <'BOOT_CAT','BIN'> ; CD boot only
                        file83 <'EA DATA ',' SF'> ; Enhanced Attributes not implemened
                        file83 <'BOOT_UPD','TXT'> ; indicator file
                        file83 <'DISKMAP ','DAT'> ; DRDOS FAT mirror
                        file83 <'WP ROOT ',' SF'> ; EA for drive itself
                        file83 <'MEMTESTP','BIN'> ; memtest+
                        file83 <'MEMTEST ','BIN'> ; memtest
                       ;... add more

nocopyfiles_end         label file83

size_1440               equ 80*2*18*512
size_2880               equ 80*2*36*512
size_4320               equ size_2880+size_1440

extension_img           equ <'I'+'M'*0100h+'G'*010000h>

ENDIF
