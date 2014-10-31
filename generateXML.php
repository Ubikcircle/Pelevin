<?php
$books = yaml_parse_file('connections.yaml', 0);
$links = yaml_parse_file('connections.yaml', 1);

checkIntegrity($books, $links);

$tags = array('сущность', 'связь');

print array2xml(
	array('пелевин' => sprintf("\n%s%s", array2xml($books, $tags), array2xml($links, $tags))),
	array(), null
);

function array2xml(array $array, $defaultNodes = array(), $indent = '  ', $depth = 1)
{
	foreach ($array as $k => $v) {
		if (true == is_numeric($k))
			$name = $defaultNodes[0];
		else
			$name = $k;

		if (true == is_array($v)) {
			$v = array2xml(
				$v,
				true == is_numeric($k)
					? array_slice($defaultNodes, 1)
					: $defaultNodes,
				$indent,
				$depth + 1
			);

			$pattern = "%s<%s>\n%s%1\$s</%2\$s>\n";
		} else
			$pattern = "%s<%s>%s</%2\$s>\n";

		@$xml .= sprintf($pattern, str_repeat($indent, $depth), $name, $v);
	}

	return $xml;
}

function checkIntegrity($books, $links)
{
	foreach ($books['произведения'] as $book)
		@$bookList[$book['название']]++;

	foreach ($links['связи'] as $link)
		foreach ($link['произведения'] as $p)
			if (false == array_key_exists($p, $bookList)) {
				error_log(sprintf(
					"Ошибка: сущность [%s] ссылатеся на произведение [%s], которого нет в списке произведений.",
					$link['название'], $p
				));

				exit(1);
			}
}
?>
