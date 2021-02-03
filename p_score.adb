with sequential_io;
with p_esiut; use p_esiut;
package body p_score is

    function analyse_fichier(f : in out p_score_io.file_type; mode,defi : in integer := 0; nom : in string := ""; tableau_score : in out TV_Score) return integer is
        --nom param => val
        tmp : TR_Score;
        i : integer := 0;
        f_nom : string := name(f);
    begin
        close(f);
        open(f,in_file,f_nom);
        while not end_of_file(f) loop
            read(f,tmp);
            if  (mode = 1 and then ((tmp.nom /= nom) and (tmp.defi /= defi))) or -- ajout_score
            (mode = 2 and then (tmp.defi = defi)) or --Tous scores pour défi
            (mode = 3 and then (tmp.nom = nom)) or --Tous scores pour joueur
            (mode = 4 and then ((tmp.nom = nom) and (tmp.defi = defi))) then -- score du joueur pour ce défi
                i := i + 1;
                tableau_score(i) := tmp;
            end if;
        end loop;
        close(f);
        open(f,append_file,f_nom);
        return i;
    end analyse_fichier;

    -- Écriture du score dans le fichier
    procedure ajout_score(f : in out p_score_io.file_type; score : in TR_Score) is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin

        i := analyse_fichier(f, 1, 0, "", scores_existants);

        -- Ajoute le nouveau score ------------------------------------
        i := i + 1;
        scores_existants(i) := score;
        reset(f, out_file);

        for j in 1..i loop
            write(f, scores_existants(j));
        end loop;
        ---------------------------------------------------------------

    exception
        when CONSTRAINT_ERROR => null; --Histoire d'acknolwedge la possibilité, même si le fichier sera jamais plein, en théorie.
    end ajout_score;

    -- ouverture du fichier score, création sinon inexsitant
    procedure ouvrir_fichier(f : in out p_score_io.file_type; file_name : in string) is
    begin
        open(f, append_file, file_name);
    exception
        when NAME_ERROR => -- Si le fichier n'existe pas
            create(f, out_file, file_name);
    end ouvrir_fichier;

    -- Recupére les scores enregistrés pour ce défi
    function recup_score(f : in out p_score_io.file_type; defi : in integer) return TV_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(f,2,defi,"",scores_existants);
        return scores_existants(1..NB_SCORE_MAX);
    end recup_score;

    -- Récupére les scores enregistrés pour ce joueur
    function recup_score(f : in out p_score_io.file_type; nom : in string) return TV_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(f,3,0,nom,scores_existants);
        return scores_existants;
    end recup_score;

    -- Récupére le score du joueur pour ce défi
    function recup_score(f : in out p_score_io.file_type; infos : in TR_Score) return TR_Score is
        scores_existants : TV_Score(1..NB_SCORE_MAX);
        i : integer := 0;
    begin
        i := analyse_fichier(f,4,infos.defi,infos.nom,scores_existants);
        return scores_existants(1);
    end recup_score;

    procedure afficher_scores(scores : in TV_Score) is
    begin
    end afficher_scores;

end p_score;
