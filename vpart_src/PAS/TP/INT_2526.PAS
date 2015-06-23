unit int_2526;

(*$G+*)

interface

function  sector_size         (drive:byte):word;
function  read_logical_sector (drive:byte;var   sector;sector_number:longint):word;
function  write_logical_sector(drive:byte;const sector;sector_number:longint):word;
function  lock_logical_drive  (drive:byte;var   handle:word):longint;
procedure unlock_logical_drive(drive:byte;const handle:word);

const
  lock_error_taskmgr =$10000000;
  lock_error_os2     =$20000000;


implementation

function  sector_size         (drive:byte):word;assembler;
  asm
    sub ax,ax
    sub cx,cx
    mov ah,$36 (* GET DISK FREE SPACE *)
    mov dl,drive
    inc dl
    int $21    (* CX=BYTE/SECTOR *)

    cmp ax,$ffff
    jne @ret

    sub cx,cx

  @ret:
    mov ax,cx
  end;


function  read_logical_sector (drive:byte;var   sector;sector_number:longint):word;
  var
    int25_tab:
      packed record
        snummer         :longint;
        anzahl          :word;
        puffer          :pointer;
      end;

  begin
    with int25_tab do
      begin
        snummer         :=0;
        anzahl          :=1;
        puffer          :=Addr(sector);
      end;
    asm
      mov ah,0
      mov al,drive
      mov cx,$FFFF (* DOS 4+ *)
      push ds
        mov dx,ss
        mov ds,dx
        lea bx,[int25_tab]
        int $25
        jc @fehler_wert
        sub ah,ah
  @fehler_wert:
        popf
        shr ax,8
        mov @result,ax
      pop ds
    end;
  end;



function  write_logical_sector(drive:byte;const sector;sector_number:longint):word;
  var
    int26_tab:
      packed record
        snummer         :longint;
        anzahl          :word;
        puffer          :pointer;
      end;

  begin
    with int26_tab do
      begin
        snummer:=0;
        anzahl:=1;
        puffer:=Addr(sector);
      end;
    asm
      mov ah,0
      mov al,drive
      mov cx,$FFFF (* DOS 4+ *)
      push ds
        mov dx,ss
        mov ds,dx
        lea bx,[int26_tab]
        int $26
        jc @fehler_wert
        sub ah,ah
@fehler_wert:
        popf
        shr ax,8
        mov @result,ax
      pop ds
    end;

  end;

function os2_aktiv:boolean;assembler;
  asm
    mov ax,$4010
    int $2f
    cmp ax,$4010
    mov al,false
    je @os2_aktiv_ende
    mov al,true
  @os2_aktiv_ende:
  end;

function  lock_logical_drive  (drive:byte;var handle:word):longint;
  var
    taskmgr_anzahl_prozesse     :word;
    laufwerk                    :array[0..2] of char;
    laufwerks_handle            :word;
  begin
    lock_logical_drive:=0;

    (* DR DOS TASKMGR *)
    asm
      mov ax,$2700
      int $2F
      sub cx,cx

      cmp al,$ff
      jnz @kein_taskmgr_installiert

      mov ax,$2701
      int $2f


    @kein_taskmgr_installiert:

      mov taskmgr_anzahl_prozesse,cx
    end;

    if taskmgr_anzahl_prozesse>1 then
      begin
        lock_logical_drive:=lock_error_taskmgr+taskmgr_anzahl_prozesse;
        Exit;
      end;

    if os2_aktiv then
      begin
        laufwerk:='A:'#0;
        Inc(laufwerk[0],drive);
        laufwerks_handle:=0;
        asm
          push ds
            push es

              mov ax,$6c00                (* ™ffen *)
              mov bx,$80c0
              mov cx,$0000
              mov dx,$0001
              push ss
              pop ds
              lea si,laufwerk
              int $21
              jc @ende_lock_laufwerk

              mov bx,ax

              mov ax,cs
              mov ds,ax
              mov es,ax

              mov ax,$440c
              (* mov bx,bx *)
              mov cx,$0800                (* lock *)
              mov dx,offset @x_35e
              mov si,cs
              mov di,offset @x_35f
              int $21
              jc @wieder_schliessen

              mov laufwerks_handle,bx

              jmp @ende_lock_laufwerk

  @wieder_schliessen:
              mov ah,$3e
              (* mov bx,bx *)
              int $21
              jmp @ende_lock_laufwerk


  @x_35e:
              db 0
  @x_35f:
              db 0

  @ende_lock_laufwerk:

            pop es
          pop ds
        end;
        if laufwerks_handle=0 then
          begin
            lock_logical_drive:=lock_error_os2;
            Exit;
          end
        else
          handle:=laufwerks_handle;
      end;

  end;

procedure unlock_logical_drive(drive:byte;const handle:word);
  begin
    
    if os2_aktiv then
      asm
        push ds
          push es

            mov ax,cs
            mov ds,ax
            mov es,ax

            mov ax,$440c                (* Generic I/O *)
            mov bx,handle
            mov cx,$0801                (* Unlock *)
            mov dx,offset @x_35e
            mov si,cs
            mov di,offset @x_35f
            int $21

            mov ah,$3e                  (* Schlieáen *)
            mov bx,handle
            int $21

            jmp @ende_unlock_laufwerk


@x_35e:
            db 0
@x_35f:
            db 0


@ende_unlock_laufwerk:

          pop es
        pop ds

      end;
  end;

end.
