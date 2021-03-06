<?php
echo "Creating...\n";

$trackfile = (isset($argv[1]) && !empty($argv[1])) ? $argv[1] : false;

if (!isset($trackfile) || empty($trackfile)) {
    die("Which is the GPX file?\n");
}

if (!file_exists($trackfile)) {
    die("GPX file {$trackfile} not found...\n");
}

echo "Processing {$trackfile}", "\n";

$pathinfo = pathinfo($trackfile);
$filename = $pathinfo['filename'];
$expl_filename = explode("-", $filename);

$path_dirs = explode("/", $pathinfo['dirname']);
array_pop($path_dirs);
array_pop($path_dirs);
array_push($path_dirs, "_sentieri");
$mdfile = sprintf("%s/%s.markdown", implode("/", $path_dirs), $filename);

list($year, $month, $day, $trackname_dashed) = explode("-", $filename);
$trackname = str_replace("_", " ", $trackname_dashed);
echo "Using ", $trackname, " as track name", "\n";

libxml_use_internal_errors(true);
@$xml = new DOMDocument('1.0', 'UTF-8');
$xml->preserveWhiteSpace = TRUE;

@$xml->load($trackfile);

$trk = $xml->getElementsByTagName("trk");
if (!empty($trk)) {
    foreach ($trk as $row) {
        /** @var \DOMElement $row */
        $names = $row->getElementsByTagName("name");
        if (!empty($names)) {
            foreach ($names as $name) {
                /** @var \DOMElement $name */
                echo "Changing from {$name->nodeValue} to {$trackname}", "\n";
                $name->nodeValue = $trackname;
            }
        }
    }
}

$meta = $xml->getElementsByTagName("metadata");
if (!empty($meta)) {
    /** @var \DOMNodeList $meta */
    $first_meta = $meta->item(0);
    /** @var \DOMNode $first_meta */
    if (!empty($first_meta->childNodes)) {
        $nodes_to_remove = $nodes_to_mantain = [];
        foreach ($first_meta->childNodes as $childNode) {
            /** @var \DOMNode $childNode */
            if (
                $childNode->nodeName == 'author' ||
                $childNode->nodeName == 'copyright' ||
                $childNode->nodeName == 'name'
            ) {
                $nodes_to_remove[] = $childNode;
            } else {
                $nodes_to_mantain[] = $childNode;
            }
        }
        if (!empty($nodes_to_remove)) {
            foreach ($nodes_to_remove as $node_to_remove) {
                echo "-> Removing: ", $node_to_remove->nodeName, "\n";
                $oldChild = $first_meta->removeChild($node_to_remove);
                echo "-> Removed: ", $oldChild->nodeName, "\n";
            }
        }
        if (!empty($nodes_to_mantain)) {
            foreach ($nodes_to_mantain as $node_to_mantain) {
                echo "-> Removing: ", $node_to_mantain->nodeName, "\n";
                $oldChild = $first_meta->removeChild($node_to_mantain);
                echo "-> Removed: ", $oldChild->nodeName, "\n";
            }
        }
    }


    $track_name = $xml->createElement('name');
    $track_name->nodeValue = $trackname;
    $first_meta->appendChild($track_name);
    echo "-> Adding: ", $track_name->nodeName, " - ", $track_name->nodeValue, "\n";

    if (!empty($nodes_to_mantain)) {
        foreach ($nodes_to_mantain as $node_to_mantain) {
            echo "-> Adding: ", $node_to_mantain->nodeName, "\n";
            $first_meta->appendChild($node_to_mantain);
        }
    }

    $author = $xml->createElement('author');
    $author_name = $xml->createElement('name');
    $author_email = $xml->createElement('email');
    $author_name->nodeValue = "Antonio Pastorino";
    $author_email->nodeValue = "antonio.pastorino@gmail.com";
    $author->appendChild($author_name);
    echo "-> Adding: ", $author_name->nodeName, " - ", $author_name->nodeValue, "\n";
    $author->appendChild($author_email);
    echo "-> Adding: ", $author_email->nodeName, " - ", $author_email->nodeValue, "\n";
    $first_meta->appendChild($author);

    $copyright = $xml->createElement('copyright');
    $copyright->setAttribute("author", "Antonio Pastorino");
    $copyright_year = $xml->createElement('year');
    $copyright_license = $xml->createElement('license');
    $copyright_year->nodeValue = date("Y");
    $copyright_license->nodeValue = "https://creativecommons.org/licenses/by/4.0/legalcode";
    $copyright->nodeValue = "https://creativecommons.org/licenses/by/4.0/legalcode";
    $copyright->appendChild($copyright_year);
    echo "-> Adding: ", $copyright_year->nodeName, " - ", $copyright_year->nodeValue, "\n";
    $copyright->appendChild($copyright_license);
    echo "-> Adding: ", $copyright_year->nodeName, " - ", $copyright_year->nodeValue, "\n";
    $first_meta->appendChild($copyright);
    echo "-> Adding: ", $copyright->nodeName, "\n";


}


$xml->save($trackfile);

libxml_clear_errors();
echo "Saved new GPX file in ", $trackfile, "\n";

$markdown = <<<EOD
---
layout: sentiero
title:  "{$trackname}"
date:   {$year}-{$month}-{$day} 09:05:00 +0100
track:  /assets/tracks/{$pathinfo['basename']}
track_color: green
categories: sentieri
---

Un altro bel sentiero!! :mountain: :snowflake:
EOD;

file_put_contents($mdfile, $markdown);



