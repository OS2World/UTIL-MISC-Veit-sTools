const

(* this file is to associate
  - link values in table
  - link value to call BIOS internal procedure
  - config space offset and shift used in BIOS internal procedure

  example:

  BIOS uses Link values 1,2,3 and 5.
  BIOS internal procedure uses 1,2,3 and 4.
  1 -> 1 -> offset 55 high 4 bit
  2 -> 2 -> offset 56 low  4 bit
  3 -> 3 -> offset 56 high 4 bit
  5 -> 4 -> offset 57 high 4 bit *)

(* on changes to this file, run via_bios.cmd
   to copy the changes to the basedev code! *)

(********************************************************)
(* Zucker                                               *)
(* VIA Apollo (M)VP3 Chipset; SOYO(S2)                  *)
(* Bus 0 (PCI), Device Number 7, Device Function 0      *)
(* Vendor 1106h VIA Technologies Inc                    *)
(* Device 0586h VT82C586B PCI to ISA Bridge             *)

AWARD_0_VP3_586B_8669_2A5LES2AC_00_translation
        =#$01#$56#$04
        +#$02#$56#$00
        +#$03#$57#$04
        +#$05#$55#$04;

AWARD_0_VP3_586B_8669_2A5LES2AC_00    (* F000:B0DB      *)
        =#$2E#$3B#$1C         (* cmp     bx, cs:[si]    *)
        +#$75#$31             (* jnz     loc_0_B111     *)
        +#$8B#$DA             (* mov     bx, dx         *)
        +#$2E#$8A#$20         (* mov     ah, cs:[bx+si] *)
        +#$0A#$E4             (* or      ah, ah         *)
        +#$74#$31             (* jz      Set_PIRQ_fail  *)
        +#$B0#$01             (* mov     al, 1          *)
        +#$80#$FC#$01         (* cmp     ah, 1          *)
        +#$74#$17             (* jz      loc_0_B107     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$02         (* cmp     ah, 2          *)
        +#$74#$10             (* jz      loc_0_B107     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$03         (* cmp     ah, 3          *)
        +#$74#$09             (* jz      loc_0_B107     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$05         (* cmp     ah, 5          *)
        +#$74#$02             (* jz      loc_0_B107     *)
        +#$8A#$C4             (* mov     al, ah         *)
                              (* loc_0_B107:            *)
        +#$8A#$E5             (* mov     ah, ch         *)
        +#$B5#$FF             (* mov     ch, 0FFh       *)
        +#$E8'??'             (* call    ct_Set_PciIrq  *)
        +#$F8;                (* clc                    *)

(* same as above, only use DS instead CS to access table *)
AWARD_0_VP3_586B_8669_2A5LES2AC_00_opt (* derived       *)
        =    #$3B#$1C         (* cmp     bx,    [si]    *)
        +#$75'?'              (* jnz                    *)
        +#$8B#$DA             (* mov     bx, dx         *)
        +    #$8A#$20         (* mov     ah,    [bx+si] *)
        +#$0A#$E4             (* or      ah, ah         *)
        +#$74#$31             (* jz      Set_PIRQ_fail  *)
        +#$B0#$01             (* mov     al, 1          *)
        +#$80#$FC#$01         (* cmp     ah, 1          *)
        +#$74#$17             (* jz                     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$02         (* cmp     ah, 2          *)
        +#$74#$10             (* jz                     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$03         (* cmp     ah, 3          *)
        +#$74#$09             (* jz                     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$05         (* cmp     ah, 5          *)
        +#$74#$02             (* jz                     *)
        +#$8A#$C4             (* mov     al, ah         *)
                              (*           :            *)
        +#$8A#$E5             (* mov     ah, ch         *)
        +#$B5#$FF             (* mov     ch, 0FFh       *)
        +#$E8'??'             (* call    ct_Set_PciIrq  *)
        +#$F8;                (* clc                    *)


AWARD_0_VP3_586B_8669_2A5LES2AC_00set  (* F000:B6FD     *)
        =#$B9#$56'?'          (* mov     cx, 3856h      *)
        +#$3C#$02             (* cmp     al, 2          *)
        +#$76#$02             (* jbe     loc_0_B706     *) (* al=1,2 -> cx=??56 *)
        +#$B1#$57             (* mov     cl, 57h        *) (* al=3,4 -> cx=??57 *)
                              (* loc_0_B706:            *)
        +#$A8#$01             (* test    al, 1          *)
        +#$74#$17             (* jz      loc_0_B721     *)
                              (* loc_0_B70A:            *)
        +#$C0#$E4#$04         (* shl     ah, 4          *) (* al=1,3,4 -> shift 4 *)
        +#$51                 (* push    cx             *)
        +#$50                 (* push    ax             *)
        +#$E8'??'             (* call    lies_pci_al    *)
        +#$24#$0F             (* and     al, 0Fh        *)
        +#$8A#$C8             (* mov     cl, al         *)
        +#$58                 (* pop     ax             *)
        +#$8A#$C1             (* mov     al, cl         *)
        +#$0A#$C4             (* or      al, ah         *)
        +#$59                 (* pop     cx             *)
        +#$E8'??'             (* call    schreibe_pci_al *)
        +#$EB#$1A             (* jmp     short loc_0_B73B *)
                              (* loc_0_B721:            *)
        +#$3C#$04             (* cmp     al, 4          *)
        +#$75#$04             (* jnz     loc_0_B729     *)
        +#$B1#$55             (* mov     cl, 55h        *) (* al=4 -> cx=??55 *)
        +#$EB#$E1             (* jmp     short loc_0_B70A *)
                              (* loc_0_B729:            *) (* al=2 -> shift 0 *)
        +#$51                 (* push    cx             *)
        +#$50                 (* push    ax             *)
        +#$E8'??'             (* call    lies_pci_al    *)
        +#$24#$F0             (* and     al, 0F0h       *)
        +#$8A#$C8             (* mov     cl, al         *)
        +#$58                 (* pop     ax             *)
        +#$8A#$C1             (* mov     al, cl         *)
        +#$0A#$C4             (* or      al, ah         *)
        +#$59                 (* pop     cx             *)
        +#$E8'??';            (* call    schreibe_pci_al *)
                              (* loc_0_B73B:            *)

(********************************************************)
(* unbekannt(Matra?), vermutlich aus flash-BIOS entpackt *)
AWARD_3_VT8623_8235_CLE26M02C_00_translation
        =#$01#$55#$04
        +#$02#$56#$00
        +#$03#$56#$04
        +#$04#$57#$04;

AWARD_3_VT8623_8235_CLE26M02C_00      (* F000:AF3B      *)
        =#$2E#$3B#$1C         (* cmp     bx, cs:[si]    *)
        +#$75#$31             (* jnz     loc_0_AF71     *)
        +#$8B#$DA             (* mov     bx, dx         *)
        +#$2E#$8A#$20         (* mov     ah, cs:[bx+si] *)
        +#$0A#$E4             (* or      ah, ah         *)
        +#$74#$31             (* jz      loc_0_AF7A     *)
        +#$B0#$01             (* mov     al, 1          *)
        +#$80#$FC#$01         (* cmp     ah, 1          *)
        +#$74#$17             (* jz      loc_0_AF67     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$02         (* cmp     ah, 2          *)
        +#$74#$10             (* jz      loc_0_AF67     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$03         (* cmp     ah, 3          *)
        +#$74#$09             (* jz      loc_0_AF67     *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$04         (* cmp     ah, 4          *)
        +#$74#$02             (* jz      loc_0_AF67     *)
        +#$8A#$C4             (* mov     al, ah         *)
                              (* loc_0_AF67:            *)
        +#$8A#$E5             (* mov     ah, ch         *)
        +#$B5#$FF             (* mov     ch, 0FFh       *)
        +#$E8'??'             (* call    sub_0_B540     *)
        +#$F8;                (* clc                    *)

AWARD_3_VT8623_8235_CLE26M02C_00_opt   (* derived       *)
        =    #$3B#$1C
        +#$75'?'
        +#$8B#$DA
        +    #$8A#$20
        +#$0A#$E4
        +#$74#$31
        +#$B0#$01
        +#$80#$FC#$01
        +#$74#$17
        +#$FE#$C0
        +#$80#$FC#$02
        +#$74#$10
        +#$FE#$C0
        +#$80#$FC#$03
        +#$74#$09
        +#$FE#$C0
        +#$80#$FC#$04
        +#$74#$02
        +#$8A#$C4

        +#$8A#$E5
        +#$B5#$FF
        +#$E8'??'
        +#$F8;


AWARD_3_VT8623_8235_CLE26M02C_00set   (* F000:B594      *)
        =#$B9#$55'?'          (* mov     cx, 8855h      *) (* al=1->55+0/4 *)
        +#$8A#$D8             (* mov     bl, al         *) (* al=2->55+1/0 *)
        +#$D0#$EB             (* shr     bl, 1          *) (* al=3->55+1/4 *)
        +#$02#$CB             (* add     cl, bl         *) (* al=4->55+2/4 *)
        +#$3C#$02             (* cmp     al, 2          *)
        +#$74#$07             (* jz      loc_0_B5A8     *)
        +#$C0#$E4#$04         (* shl     ah, 4          *)
        +#$B0#$0F             (* mov     al, 0Fh        *)
        +#$EB#$02             (* jmp     short loc_0_B5AA *)
                              (* loc_0_B5A8:            *)
        +#$B0#$F0             (* mov     al, 0F0h       *)
                              (* loc_0_B5AA:            *)
        +#$8B#$D8             (* mov     bx, ax         *)
        +#$E8'??';            (* call    maske_pci      *)

(********************************************************)
(* 6a6s7pa9.BIN:                                        *)
(* 2-AMD762-W83627-6A6S7PA9C-00 -> Epox & 2TheMax       *)
(* Bus 0 (PCI), Device Number 0, Device Function 0      *)
(* Vendor 1022h Advanced Micro Devices (AMD)            *)
(* Device 700Ch AMD-762 CPU to PCI Bridge (SMP Chipset) *)
(* Bus 0 (PCI), Device Number 7, Device Function 3      *)
(* Vendor 1022h Advanced Micro Devices (AMD)            *)
(* Device 7413h AMD-766 Power Management Controller     *)

AWARD_2_AMD762_W83627_6A6S7PA9C_00_translation
        =#$01#$56#$00
        +#$02#$56#$04
        +#$03#$57#$00
        +#$04#$57#$04;

AWARD_2_AMD762_W83627_6A6S7PA9C_00
        =AWARD_3_VT8623_8235_CLE26M02C_00;
AWARD_2_AMD762_W83627_6A6S7PA9C_00_opt
        =AWARD_3_VT8623_8235_CLE26M02C_00_opt;

AWARD_2_AMD762_W83627_6A6S7PA9C_00set  (* F000:B7E9     *)
        =#$B9#$56'?'          (* mov     cx, 3B56h      *) (* al=1,2->56 *)
        +#$3C#$02             (* cmp     al, 2          *)
        +#$76#$03             (* jbe     loc_0_B7F3     *)
        +#$B9#$57'?'          (* mov     cx, 3B57h      *) (* al=3,4->57 *)
                              (* loc_0_B7F3:            *)
        +#$A8#$01             (* test    al, 1          *) (* al=1,3->shift 0 *)
        +#$75#$11             (* jnz     loc_0_B808     *) (* al=2,4->shift 4 *)
        +#$C0#$E4#$04         (* shl     ah, 4          *)
        +#$50                 (* push    ax             *)
        +#$E8'??'             (* call    lies_pci       *)
        +#$5B                 (* pop     bx             *)
        +#$24#$0F             (* and     al, 0Fh        *)
        +#$0A#$C7             (* or      al, bh         *)
        +#$E8'??'             (* call    schreibe_pci   *)
        +#$EB#$0C             (* jmp     short loc_0_B814 *)
                              (* loc_0_B808:            *)
        +#$50                 (* push    ax             *)
        +#$E8'??'             (* call    lies_pci       *)
        +#$5B                 (* pop     bx             *)
        +#$24#$F0             (* and     al, 0F0h       *)
        +#$0A#$C7             (* or      al, bh         *)
        +#$E8'??';            (* call    schreibe_pci   *)


(********************************************************)
(* Daniela Engert                                       *)
(* Vendor 1106h VIA Technologies Inc                    *)
(* Device 3227h VT8237 PCI to ISA Bridge                *)
(* Subsystem Vendor 1458h Giga-Byte Technology          *)

(* also 3-KT400A-8235-6A6LYJ19C-00                      *)
(* also 3-KT600-8237-6A6LYE1FC-00                       *)

AWARD_4_K8T800_8237_6A7L0G02C_00_translation
        =#$01#$55#$04
        +#$02#$56#$00
        +#$03#$56#$04
        +#$05#$57#$04
        +#$06#$57#$04 {?}
        +#$07#$58#$04 {?}
        +#$08#$58#$04 {?}
        +#$09#$59#$04;{?}

AWARD_4_K8T800_8237_6A7L0G02C_00 (* F000:A53B           *)
        =#$2E#$3B#$1C         (* cmp     bx, cs:[si]    *)
        +#$75#$4D             (* jnz     loc_0_A58D     *)
        +#$8B#$DA             (* mov     bx, dx         *)
        +#$2E#$8A#$20         (* mov     ah, cs:[bx+si] *)
        +#$0A#$E4             (* or      ah, ah         *)
        +#$74#$4D             (* jz      loc_0_A596     *)
        +#$B0#$01             (* mov     al, 1     1->1 *)
        +#$80#$FC#$01         (* cmp     ah, 1          *)
        +#$74#$33             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$02         (* cmp     ah, 2     2->2 *)
        +#$74#$2C             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$03         (* cmp     ah, 3     3->3 *)
        +#$74#$25             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$05         (* cmp     ah, 5     5->4 *)
        +#$74#$1E             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$06         (* cmp     ah, 6     6->5 *)
        +#$74#$17             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$07         (* cmp     ah, 7     7->6 *)
        +#$74#$10             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$08         (* cmp     ah, 8     8->7 *)
        +#$74#$09             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$09         (* cmp     ah, 9     9->8 *)
        +#$74#$02             (* jz      set_router_al  *)
        +#$8A#$C4             (* mov     al, ah         *)
                              (* set_router_al:         *)
        +#$8A#$E5             (* mov     ah, ch         *)
        +#$B5#$FF             (* mov     ch, 0FFh       *)
        +#$E8'??'             (* call    set_router_al_ *)
        +#$F8;                (* clc                    *)

(* this in an optimized version of the above,           *)
(* the code now use DS to access the routing table      *)
(* release "K8VNXP F7" 2004.08.03                       *)
AWARD_4_K8T800_8237_6A7L0G02C_00_F7 (* F000:A3BC        *)
        =    #$3B#$1C         (* cmp     bx,    [si]    *)
        +#$75#$4C             (* jnz     loc_0_a40c     *)
        +#$8B#$DA             (* mov     bx, dx         *)
        +    #$8A#$20         (* mov     ah,    [bx+si] *)
        +#$0A#$E4             (* or      ah, ah         *)
        +#$74#$4D             (* jz      loc_0_a415     *)
        +#$B0#$01             (* mov     al, 1     1->1 *)
        +#$80#$FC#$01         (* cmp     ah, 1          *)
        +#$74#$33             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$02         (* cmp     ah, 2     2->2 *)
        +#$74#$2C             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$03         (* cmp     ah, 3     3->3 *)
        +#$74#$25             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$05         (* cmp     ah, 5     5->4 *)
        +#$74#$1E             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$06         (* cmp     ah, 6     6->5 *)
        +#$74#$17             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$07         (* cmp     ah, 7     7->6 *)
        +#$74#$10             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$08         (* cmp     ah, 8     8->7 *)
        +#$74#$09             (* jz      set_router_al  *)
        +#$FE#$C0             (* inc     al             *)
        +#$80#$FC#$09         (* cmp     ah, 9     9->8 *)
        +#$74#$02             (* jz      set_router_al  *)
        +#$8A#$C4             (* mov     al, ah         *)
                              (* set_router_al:         *)
        +#$8A#$E5             (* mov     ah, ch         *)
        +#$B5#$FF             (* mov     ch, 0FFh       *)
        +#$E8'??'             (* call    set_router_al_ *)
        +#$F8;                (* clc                    *)


(* sets
     al=1->index 55/4
     al=2->index 56/0
     al=3->index 56/4
     al=4->index 57/4 *)
AWARD_4_K8T800_8237_6A7L0G02C_00set        (* F000:AB88 *)
        =#$51                 (* push    cx             *)
        +#$50                 (* push    ax             *)
        +#$B9#$55'?'          (* mov     cx, 8855h      *)
        +#$8A#$D8             (* mov     bl, al         *)
        +#$D0#$EB             (* shr     bl, 1          *)
        +#$02#$CB             (* add     cl, bl         *)
        +#$3C#$02             (* cmp     al, 2          *)
        +#$74#$07             (* jz      loc_0_AB9E     *)
        +#$C0#$E4#$04         (* shl     ah, 4          *)
        +#$B0#$0F             (* mov     al, 0Fh        *)
        +#$EB#$02             (* jmp     short loc_0_ABA0 *)
                              (* loc_0_AB9E:            *)
        +#$B0#$F0             (* mov     al, 0F0h       *)
                              (* loc_0_ABA0:            *)
        +#$8B#$D8             (* mov     bx, ax         *)
        +#$E8'??';            (* call    pci_maske      *)




(********************************************************)
(* a7m266-1004a.zip\AM26104A.awd Award/ASUS             *)
(* ASUS A7M266 ACPI BIOS Revision 1004A                 *)

asus_1_AMD_760_A7M266_translation
        =#$01#$55#$04
        +#$02#$56#$00
        +#$03#$56#$04
        +#$05#$57#$04;

asus_1_AMD_760_A7M266         (* F000:17C7              *)
        =#$80#$E9#$0A         (* sub     cl, 0Ah        *)
        +#$B8#$03#$00         (* mov     ax, 3          *)
        +#$F6#$E1             (* mul     cl             *)
        +#$03#$F0             (* add     si, ax         *)
        +#$8A#$4C#$02         (* mov     cl, [si+2]     *)
        +#$80#$FD#$06         (* cmp     ch, 6          *)
        +#$74'?'              (* jz      loc_0_182D     *)
        +#$80#$FD#$07         (* cmp     ch, 7          *)
        +#$74'?'              (* jz      loc_0_182D     *)
        +#$66#$60             (* pushad                 *)
        +#$8A#$DD             (* mov     bl, ch         *)
        +#$F6#$C1#$01         (* test    cl, 1          *)
        +#$74#$03             (* jz      loc_0_17EA     *)
        +#$C0#$E3#$04         (* shl     bl, 4          *)
                              (* loc_0_17EA:            *)
        +#$8A#$F9             (* mov     bh, cl         *)
        +#$66#$B9#$55'??'#$80 (* mov     ecx, 80002055h *)
        +#$8A#$C7             (* mov     al, bh         *)
        +#$D0#$E8             (* shr     al, 1          *)
        +#$02#$C8             (* add     cl, al         *)
        +#$51                 (* push    cx             *)
        +#$66#$8B#$C1         (* mov     eax, ecx       *)
        +#$BA#$F8#$0C         (* mov     dx, 0CF8h      *)
        +#$66#$EF;            (* out     dx, eax        *)


(********************************************************)

phoenix_AMD_768_ACPI_Controller_translation
        =#$01#$56#$00
        +#$02#$56#$04
        +#$03#$57#$00
        +#$04#$57#$04;

phoenix_AMD_768_ACPI_Controller (* F000:DE3B            *)
        =#$56#$00#$0f
        +#$56#$04#$f0
        +#$57#$00#$0f
        +#$57#$04#$f0;



(********************************************************)
(* Gigabyte Technology Co., LTD 7DXR                    *)
AWARD_3_7DXR_6A6S6G0AC_00       (* F000:B55B            *)
        =AWARD_0_VP3_586B_8669_2A5LES2AC_00;

AWARD_3_7DXR_6A6S6G0AC_00_opt
        =AWARD_0_VP3_586B_8669_2A5LES2AC_00_opt;


AWARD_3_7DXR_6A6S6G0AC_00set    (* F000:BB5C            *)
        =#$B9#$55'?'            (* mov     cx, 3855h    *)
        +#$8A#$D8               (* mov     bl, al       *)
        +#$D0#$EB               (* shr     bl, 1        *)
        +#$02#$CB               (* add     cl, bl       *)
        +#$3C#$02               (* cmp     al, 2        *)
        +#$74#$0C               (* jz      set_low      *)
        +#$C0#$E4#$04           (* shl     ah, 4        *)
        +#$B0#$0F               (* mov     al, 0Fh      *)
        +#$8B#$D8               (* mov     bx, ax       *)
        +#$E8'??'               (* call    write_pci    *)
        +#$EB#$07               (* jmp     short done_set *)
                                (* set_low:             *)
        +#$B0#$F0               (* mov     al, 0F0h     *)
        +#$8B#$D8               (* mov     bx, ax       *)
        +#$E8'??';              (* call    write_pci    *)
                                (* done_set:            *)

AWARD_3_7DXR_6A6S6G0AC_00_translation
        =#$01#$55#$04
        +#$02#$56#$00
        +#$03#$56#$04
        +#$05#$57#$04;


(********************************************************)
(* 3-KT333-8235-6A6LVJ19C-00   J1=Jetway                *)
AWARD_3_KT333_8235_6A6LVJ19C_00            (* F000:B94A *)
        =AWARD_0_VP3_586B_8669_2A5LES2AC_00;
AWARD_3_KT333_8235_6A6LVJ19C_00set         (* F000:B94A *)
        =AWARD_3_VT8623_8235_CLE26M02C_00set;
AWARD_3_KT333_8235_6A6LVJ19C_00_translation
        =#$01#$55#$04 (* 1->1 -> $55, !* *)
        +#$02#$56#$00 (* 2->2 -> $56, *! *)
        +#$03#$56#$04 (* 3->3 -> $56, !* *)
        +#$05#$57#$04;(* 5->4 -> $57, !* *)
(********************************************************)
(* 62-0617-001131-00101111-040201-VIA_K7                *)
AMI_VIA_K7_00                              (* F000:7A71 *)
        =#$9C                   (* pushf                *)
        +#$0A#$C0               (* or      al, al       *)
        +#$74#$4B               (* jz      @@exit       *)
        +#$66#$60               (* pushad               *)
        +#$50                   (* push    ax           *)
        +#$50                   (* push    ax           *)
        +#$BF#$54#$00           (* mov     di, 54h      *)
        +#$BB'??'               (* mov     bx, 88h      *)
        +#$E8'??'               (* call    pci_0a       *)
        +#$58                   (* pop     ax           *)
        +#$8A#$D0               (* mov     dl, al       *)
        +#$C0#$E2#$02           (* shl     dl, 2        *)
        +#$66#$C1#$C9#$08       (* ror     ecx, 8       *)
        +#$66#$87#$D1           (* xchg    edx, ecx     *)
        +#$66#$D3#$CA           (* ror     edx, cl      *)
        +#$80#$E2#$F0           (* and     dl, 0F0h     *)
        +#$0A#$D4               (* or      dl, ah       *)
        +#$66#$D3#$C2           (* rol     edx, cl      *)
        +#$66#$87#$D1           (* xchg    edx, ecx     *)
        +#$66#$C1#$C1#$08       (* rol     ecx, 8       *)
        +#$E8'??';              (* call    pci_0d       *)

AMI_VIA_K7_00_translation
        =#$01#$55#$04
        +#$02#$56#$00
        +#$03#$56#$04
        +#$04#$57#$00
        +#$05#$57#$04;

(********************************************************)

const
  via_string_table      :array[1..14] of
    record
      s1,
      s2                :string;
      tr                :string;
    end=
  ((s1:AWARD_0_VP3_586B_8669_2A5LES2AC_00;
    s2:AWARD_0_VP3_586B_8669_2A5LES2AC_00set;
    tr:AWARD_0_VP3_586B_8669_2A5LES2AC_00_translation),

   (s1:AWARD_0_VP3_586B_8669_2A5LES2AC_00_opt;
    s2:AWARD_0_VP3_586B_8669_2A5LES2AC_00set;
    tr:AWARD_0_VP3_586B_8669_2A5LES2AC_00_translation),

   (s1:AWARD_3_VT8623_8235_CLE26M02C_00;
    s2:AWARD_3_VT8623_8235_CLE26M02C_00set;
    tr:AWARD_3_VT8623_8235_CLE26M02C_00_translation),

   (s1:AWARD_3_VT8623_8235_CLE26M02C_00_opt;
    s2:AWARD_3_VT8623_8235_CLE26M02C_00set;
    tr:AWARD_3_VT8623_8235_CLE26M02C_00_translation),

   (s1:AWARD_2_AMD762_W83627_6A6S7PA9C_00;
    s2:AWARD_2_AMD762_W83627_6A6S7PA9C_00set;
    tr:AWARD_2_AMD762_W83627_6A6S7PA9C_00_translation),

   (s1:AWARD_2_AMD762_W83627_6A6S7PA9C_00_opt;
    s2:AWARD_2_AMD762_W83627_6A6S7PA9C_00set;
    tr:AWARD_2_AMD762_W83627_6A6S7PA9C_00_translation),

   (s1:AWARD_4_K8T800_8237_6A7L0G02C_00;
    s2:AWARD_4_K8T800_8237_6A7L0G02C_00set;
    tr:AWARD_4_K8T800_8237_6A7L0G02C_00_translation),

   (s1:AWARD_4_K8T800_8237_6A7L0G02C_00_F7;
    s2:AWARD_4_K8T800_8237_6A7L0G02C_00set;
    tr:AWARD_4_K8T800_8237_6A7L0G02C_00_translation),

   (s1:asus_1_AMD_760_A7M266;
    s2:'';
    tr:asus_1_AMD_760_A7M266_translation),

   (s1:phoenix_AMD_768_ACPI_Controller;
    s2:'';
    tr:phoenix_AMD_768_ACPI_Controller_translation),

   (s1:AWARD_3_7DXR_6A6S6G0AC_00;
    s2:AWARD_3_7DXR_6A6S6G0AC_00set;
    tr:AWARD_3_7DXR_6A6S6G0AC_00_translation),

   (s1:AWARD_3_7DXR_6A6S6G0AC_00_opt;
    s2:AWARD_3_7DXR_6A6S6G0AC_00set;
    tr:AWARD_3_7DXR_6A6S6G0AC_00_translation),

   (s1:AWARD_3_KT333_8235_6A6LVJ19C_00;
    s2:AWARD_3_KT333_8235_6A6LVJ19C_00set;
    tr:AWARD_3_KT333_8235_6A6LVJ19C_00_translation),

   (s1:AMI_VIA_K7_00;
    s2:'';
    tr:AMI_VIA_K7_00_translation)

  );
(* when you change this table, please run via_bios.cmd,
   to copy the changes to the spciirq.sys/snp source,
   then rebuild spciirq.sys/snp..                        *)

(********************************************************)


const
  via_translation       :string='';

procedure search_via_translation;

  function search_bios(const s:string):boolean;
    type
      {$IfDef VirtualPascal}
      tByteArray=array[$0000..High(word)] of byte;
      {$Else VirtualPascal}
      tByteArray=array[$0000..$fffe] of byte;
      {$EndIf VirtualPascal}
      pByteArray=^tByteArray;

    var
      i,j               :word;
      p                 :pByteArray;
      equal             :boolean;

    begin

      if s='' then
        begin
          search_bios:=true;
          Exit;
        end;

      p:=Ptr_F000(0);
      for i:=0 to $ff00 do
        if p^[i]=Ord(s[1]) then
          begin
            equal:=true;
            for j:=2 to Length(s) do
              if (p^[i+j-1]<>Ord(s[j])) and (s[j]<>'?') then
                begin
                  equal:=false;
                  Break;
                end;
            if equal then
              begin
                search_bios:=true;
                Exit;
              end;
          end;
      search_bios:=false;
    end;

  var
    i                   :word;
  begin
    for i:=Low(via_string_table) to High(via_string_table) do
      with via_string_table[i] do
        if search_bios(s1) and search_bios(s2) then
          begin
            via_translation:=tr;
            Break;
          end;
  end;

function translate_via_link(const link:byte;var register_index,shift:byte):boolean;
  var
    i:word;
  begin

    if via_translation='' then
      search_via_translation;

    i:=1;
    while i+3-1<=Length(via_translation) do
      if Ord(via_translation[i])=link then
        begin
          register_index:=Ord(via_translation[i+1]);
          shift         :=Ord(via_translation[i+2]);
          translate_via_link:=true;
          Exit;
        end
      else
        Inc(i,3);
    translate_via_link:=false;
  end;

