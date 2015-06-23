unit i1587;

interface

var
  i1587_fehler:byte;

procedure bios_kopiere(quelle,ziel:longint;anzahl_word:word);


implementation

procedure bios_kopiere(quelle,ziel:longint;anzahl_word:word);
  var
    gdt:
      record
        bios_null_1             :array[1..16] of byte;
        quell_segment_laenge    :word;
        quelle_a                :array[0..2] of byte;
        quell_rechte            :byte;
        quell_null              :byte;
        quelle_b                :array[3..3] of byte;
        ziel_segment_laenge     :word;
        ziel_a                  :array[0..2] of byte;
        ziel_rechte             :byte;
        ziel_null               :byte;
        ziel_b                  :array[3..3] of byte;
        bios_null_2             :array[1..18] of byte;
      end;
  begin
    with gdt do
      begin
        fillchar(bios_null_1,sizeof(bios_null_1),0);

        quell_segment_laenge    :=$ffff;
        quelle_a[0]             :=(quelle shr  0) and $ff;
        quelle_a[1]             :=(quelle shr  8) and $ff;
        quelle_a[2]             :=(quelle shr 16) and $ff;
        quell_rechte            :=$93;
        quell_null              :=0;
        quelle_b[3]             :=(quelle shr 24) and $ff;

        ziel_segment_laenge    :=$ffff;
        ziel_a[0]              :=(ziel shr  0) and $ff;
        ziel_a[1]              :=(ziel shr  8) and $ff;
        ziel_a[2]              :=(ziel shr 16) and $ff;
        ziel_rechte            :=$93;
        ziel_null              :=0;
        ziel_b[3]              :=(ziel shr 24) and $ff;

        fillchar(bios_null_2,sizeof(bios_null_2),0);
      end;

    asm
      mov ah,$87
      mov cx,anzahl_word
      lea si,gdt
      push ss
      pop es
      int $15
      jc @ende

      mov ah,0

    @ende:
      mov di,seg i1587_fehler
      mov es,di
      mov di,offset i1587_fehler
      mov es:[di],al
    end;
  end;
  
end.
