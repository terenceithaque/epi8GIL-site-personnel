#!/bin/bash

#source_file=${1:?Fichier source manquant} # Fichier source

#echo $source_file





function error {

        echo $*
        exit 1

}



#test -f $source || error  "{$source}: fichier inexistant"
test -f layout/before.html || error "layout/before.html: fichier inexistant"
test -f layout/after.html || error "layout/after.html: fichier inexistant"


html_files=$(ls input/ | grep ".html")
css_files=$(ls input/ | grep ".css")

echo "Fichiers html: $html_files"
echo "Fichiers css: $css_files"


for source_file in input/*.html; do
        echo "Chemin relatif du fichier source: $source_file"

        file_name="${source_file#input/}"
      
        echo "Construction du fichier $file_name"
        # Code source du fichier
        source_code=$(cat $source_file)
        title=$(head -1 $source_file)

        echo "Titre du fichier source: $title"



        # Actualiser la date de modification du fichier
        date=$(date)
        #echo $date



        #  Code source du fichier before.html
        before_code=$(cat layout/before.html | sed "s/##TITRE##/$title/g")

        # Code source du fichier after.html
        after_code=$(cat layout/after.html | sed "s/##DATEMODIF##/$date/g")



        # Code final du fichier HTML
        final_code="$before_code$source_code$after_code"
        #echo $final_code





        # Ecrire le code source complet dans le fichier final
        echo $final_code > "output/$file_name"

        echo "Fini de construire output/$file_name"
done


for css_file in input/*.css; do

        echo "Copie de la feuille de style:  ${css_file}"

        file_name="${css_file/input}"

        cp $css_file "output/$file_name"

        echo "Copié la feuille de style dans output/$file_name"


        echo "Terminé la copie des fichiers dans output/"
done
