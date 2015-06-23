{&Use32+}
unit mit;

interface

type
  {$IfNDef VirtualPascal}
  smallword             =word;
  tLongArray            =array[0..$3ffe] of Longint;
  pLongArray            =^tLongArray;
  {$EndIf}

  date211               =
    packed record
      year              :smallword;
      day               :byte;
      month             :byte;
    end;

  microcode_update_block=
    packed record
      update_header_version_number                      :longint;
      revision_number_of_this_microcode_update          :longint;
      update_creation_date                              :date211;
      family_model_stepping_of_processor_to_which_update_applied,
      checksum,
      revision_number_of_loader_needed_to_install_update,
      product                                           :longint;
      (*reserved_for_future_expansion:array[$1c..$2f] of byte;*)
      unknown_1c                                        :longint;
      blocksize                                         :longint;
      reserved_for_future_expansion                     :array[$24..$2f] of byte;
      encrypted_microcode_data                          :array[$30..{ $30+2000-1}$7fff] of byte;
    end;

  Pmicrocode_update_block=^microcode_update_block;

  amd_microcode_update_block=
    packed record
      date              :
        packed record
          year          :smallword;
          day           :byte;
          month         :byte;
        end;
      msr_8b_after_patch:longint; (* 3a/41/..*)
      unknown_08        :longint; (* 00 80 20 00 *)
      checksum          :longint;
      unknown_10        :longint; (* 00 00 00 00 *)
      unknown_14        :longint; (* 00 00 00 00 *)
      modell_series     :longint; (* 040/04a/048/150 derived from cpuid 1 *)
      signature         :longint; (* ?? aa aa aa *)
      unknown_20        :longint; (* 44 06 00 00 *)
      unknown_24        :longint; (* 40 01 00 00 *)
      unused_28         :array[$028..$03f] of byte; (* FF *)
      microcode_data    :array[$040..$3bf] of byte;
      zeroes            :array[$3c0..$7ff] of byte; (* 00 *)
    end;

  Pamd_microcode_update_block=^amd_microcode_update_block;


(* results: -0 no
             0 no (checksum error)
          else yes, blocksize *)

function is_valid_intel_p6_microcode(const a;len_max:word):integer;
function is_valid_amd_k8_microcode(const a;len_max:word):integer;

implementation

uses
  Objects;

function is_valid_intel_p6_microcode(const a;len_max:word):integer;
  var
    block_size          :integer;
    i                   :word;
    sum                 :longint;
  begin
    with microcode_update_block( a ),update_creation_date do
      begin
        is_valid_intel_p6_microcode:=-1;

        (* not even header.. *)
        if len_max<$30 then
          Exit;

        if (update_header_version_number<>1)
        or (revision_number_of_loader_needed_to_install_update<>1)
        or (not (Hi(year) in [$19..$20]))
        or (not (month    in [$01..$09,$10..$12]))
        or (not (day      in [$01..$09,$10..$19,$20..$29,$30..$31]))
         then
          Exit;

        block_size:=blocksize;
        if block_size=0 then block_size:=$800;
        if (block_size<$800) or (block_size>$8000) or (block_size>len_max)
        or ((block_size and $7ff)<>0) then
          Exit;

        is_valid_intel_p6_microcode:=0;

        sum:=0;
        for i:=0 to (block_size div 4)-1 do
          Inc(sum,pLongArray(@a)^[i]);

        if sum=0 then
          is_valid_intel_p6_microcode:=block_size;
      end;
  end;

function is_valid_amd_k8_microcode(const a;len_max:word):integer;
  var
    block_size          :integer;
    i                   :word;
    sum                 :longint;
  begin
    with amd_microcode_update_block(a),date do
      begin
        is_valid_amd_k8_microcode:=-1;

        (* not even header.. *)
        if len_max<$40 then
          Exit;

        if (not (Hi(year) in [$19..$20]))
        or (not (month    in [$01..$09,$10..$12]))
        or (not (day      in [$01..$09,$10..$19,$20..$29,$30..$31]))
        or (signature shr 8<>$aaaaaa)
         then
          Exit;

        is_valid_amd_k8_microcode:=0;

        (* short variant, zeroes not stored.. *)
        block_size:=SizeOf(amd_microcode_update_block)-SizeOf(zeroes);
        sum:=0;
        for i:=($40 div 4) to (block_size div 4)-1 do
          Inc(sum,pLongArray(@a)^[i]);

        (* later version could actualy use more bytes, try $800 blocksize *)
        if sum<>checksum then
          begin
            block_size:=SizeOf(amd_microcode_update_block);
            sum:=0;
            for i:=($40 div 4) to (block_size div 4)-1 do
              Inc(sum,pLongArray(@a)^[i]);

            if sum<>checksum then
              Exit;
          end;

        is_valid_amd_k8_microcode:=block_size;

      end;
  end;


end.

