WITH NuevoModulo AS (
    INSERT INTO
        usuario.modulo (
            seccion,
            nombre,
            descripcion,
            siglas,
            icono,
            orden,
            activo,
            idpadre,
            fecha_creacion,
            fecha_modificacion
        )
    VALUES
        (
            '',
            'Perfiles',
            NULL,
            'per',
            'mdi-human-capacity-increase',
            NULL,
            '1',
            NULL,
            NOW(),
            NOW()
        ) RETURNING id
)
INSERT INTO
    usuario.permiso (nombre, descripcion, siglas, idmodulo)
VALUES
    (
        'Ver perfil',
        'Ver información del usuario',
        'vepe',
        (
            SELECT
                id
            FROM
                NuevoModulo
        )
    ),
    (
        'Editar perfil',
        'Editar información y configuración del usuario',
        'edpe',
        (
            SELECT
                id
            FROM
                NuevoModulo
        )
    ),
    (
        'Borrar perfil',
        'Activar o desactivar usuario',
        'bope',
        (
            SELECT
                id
            FROM
                NuevoModulo
        )
    ),
    (
        'Crear perfil',
        'Crear nuevo perfil',
        'crpe',
        (
            SELECT
                id
            FROM
                NuevoModulo
        )
    );

WITH module AS (
    SELECT
        id
    FROM
        usuario.modulo
    ORDER BY
        id DESC
    LIMIT
        1
)
INSERT INTO
    usuario.usuario_dominio_modulo(
        idusuario,
        iddominio,
        idmodulo,
        activo,
        fecha_creacion,
        fecha_modificacion
    )
VALUES
    (
        1,
        1,
        (
            SELECT
                id
            FROM
                module
        ),
        '1',
        now(),
        now()
    );

-- PARTE DOS -----------------------
SELECT
    idusuario,
    Json_object_agg(siglas, permisos) AS permisos
FROM
    (
        SELECT
            t.idusuario,
            mod.siglas,
            COALESCE(
                Json_agg(prm.siglas) filter (
                    WHERE
                        prm.siglas IS NOT NULL
                ),
                '[]'
            ) AS permisos
        FROM
            (
                SELECT
                    idusuario,
                    idmodulo
                FROM
                    usuario.usuario_dominio_modulo AS t
                WHERE
                    idusuario = :userId
                    AND iddominio = :domainId
                    AND activo = true
            ) AS t
            LEFT JOIN (
                SELECT
                    siglas,
                    idmodulo
                FROM
                    usuario.permiso AS t
                    INNER JOIN (
                        SELECT
                            idpermiso
                        FROM
                            usuario.usuario_permiso
                        WHERE
                            idusuario = :userId
                    ) AS upr ON upr.idpermiso = t.id
                UNION
                SELECT
                    siglas,
                    idmodulo
                FROM
                    usuario.permiso AS t
                    INNER JOIN (
                        SELECT
                            idpermiso
                        FROM
                            usuario.perfil_permiso AS t
                            INNER JOIN (
                                SELECT
                                    idperfil
                                FROM
                                    usuario.perfil_usuario
                                WHERE
                                    idusuario = :userId
                            ) AS psr ON psr.idperfil = t.idperfil
                    ) AS upr ON upr.idpermiso = t.id
            ) AS prm ON t.idmodulo = prm.idmodulo
            LEFT JOIN (
                SELECT
                    id,
                    siglas
                FROM
                    usuario.modulo
            ) AS mod ON t.idmodulo = mod.id
        GROUP BY
            t.idusuario,
            mod.siglas
    ) AS sq
GROUP BY
    sq.idusuario;