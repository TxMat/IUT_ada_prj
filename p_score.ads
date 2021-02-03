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

    NOM_FICHIER : constant string := "score";

    -- Instanciation sequential_io pour stocker les scores
    package p_score_io is new sequential_io(TR_Score); use p_score_io;

    f : p_score_io.file_type;

    -- ouverture du fichier score, création sinon
    procedure ouvrir_fichier(io_type : in integer);

    -- fermeture du fichier
    procedure fermer_fichier;

    -- fonction privée (à rendre privée) Récupère les scores *relevant*
    function analyse_fichier(mode,defi : in integer := 0; nom : in string := ""; tableau_score : in out TV_Score) return integer;

    -- Écriture du score dans le fichier
    procedure ajout_score(score : in TR_Score);

    -- Recupére les scores enregistrés pour ce défi
    function recup_score(defi : in integer) return TV_Score;

    -- Récupére les scores enregistrés pour ce joueur
    function recup_score(nom : in string) return TV_Score;

    -- Récupére le score du joueur pour ce défi
    function recup_score(infos : in TR_Score) return TR_Score;

    -- Pour debug & co
    procedure afficher_scores;

end p_score;
