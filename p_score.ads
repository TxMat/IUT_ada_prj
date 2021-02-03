with sequential_io;

package p_score is

    -- Représentation des scores
    type TR_Score is record
        defi : integer range 1..20;
        nom : string(1..20);
        temps : float;
        nb_moves : integer;
    end record;

    type TV_Score is array (integer range <>) of TR_Score;

    NB_SCORE_MAX : constant integer := 400; --Nombre de scores différents supportés dans le fichier

    -- Instanciation sequential_io pour stocker les scores
    package p_score_io is new sequential_io(TR_Score); use p_score_io;

    function analyse_fichier(mode,defi : in integer := 0; nom : in string := ""; tableau_score : in out TV_Score; f : in out p_score_io.file_type) return integer;

    -- Écriture du score dans le fichier
    procedure ajout_score(score : in TR_Score; f : in out p_score_io.file_type);

    -- ouverture du fichier score, création sinon
    procedure ouvrir_fichier(name : in string; f : in out p_score_io.file_type);

    -- Recupére les scores enregistrés pour ce défi
    function recup_score(defi : in integer; f : in out p_score_io.file_type) return TV_Score;

    -- Récupére les scores enregistrés pour ce joueur
    function recup_score(nom : in string; f : in out p_score_io.file_type) return TV_Score;

    -- Récupére le score du joueur pour ce défi
    function recup_score(infos : in TR_Score; f : in out p_score_io.file_type) return TR_Score;

end p_score;
