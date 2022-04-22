with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
with p_vuetxt; use p_vuetxt;
with text_io; use text_io;


procedure extract_defis is
    f : p_piece_io.file_type;
begin
    open(f, in_file, "Defis.bin");
    PrintAllFromFile(f);
end extract_defis;
