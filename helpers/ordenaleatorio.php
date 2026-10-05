<?php
declare(strict_types=1);

final class OrdenAleatorio
{
    /** Mezcla sin repetir la presentación anterior, si hay más de un elemento. */
    public static function mezclar(array $items, array $anterior = [], int $limite = 0): array
    {
        $items = array_values($items);
        if (count($items) > 1) {
            do {
                shuffle($items);
                $visible = $limite > 0 ? array_slice($items, 0, $limite) : $items;
            } while ($visible === $anterior);
        }
        return $items;
    }
}
