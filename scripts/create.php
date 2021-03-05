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


//$author = $xml->metadata[0]->addChild("author");
//$copyright = $xml->metadata[0]->addChild("copyright");

//$author->addAttribute("text", "geography");

$meta = $xml->getElementsByTagName("metadata");
if (!empty($meta)) {
    /** @var \DOMNodeList $meta */
    $first_meta = $meta->item(0);

    $author = $xml->createElement('author');
    $author_name = $xml->createElement('name');
    $author_email = $xml->createElement('email');
    $author_name->nodeValue = "Antonio Pastorino";
    $author_email->nodeValue = "antonio.pastorino@gmail.com";
    $author->appendChild($author_name);
    $author->appendChild($author_email);
    $first_meta->appendChild($author);

    $copyright = $xml->createElement('copyright');
    $copyright->setAttribute("author", "Antonio Pastorino");
    $copyright_year = $xml->createElement('year');
    $copyright_license = $xml->createElement('license');
    $copyright_year->nodeValue = date("Y");
    $copyright_license->nodeValue = "https://creativecommons.org/licenses/by/4.0/legalcode";
    $copyright->nodeValue = "https://creativecommons.org/licenses/by/4.0/legalcode";
    $copyright->appendChild($copyright_year);
    $copyright->appendChild($copyright_license);
    $first_meta->appendChild($copyright);
}


$xml->save($trackfile);

libxml_clear_errors();
echo "Saved new GPX file in ", $trackfile, "\n";

$markdown = <<<EOD
---
layout: sentiero
title:  "{$trackname}"
date:   2019-06-08 09:05:00 +0100
track:  /assets/tracks/{$pathinfo['basename']}
track_color: green
categories: sentieri
---

Un altro bel sentiero!! :mountain: :snowflake:
EOD;

file_put_contents($mdfile, $markdown);



