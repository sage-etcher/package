
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sqlite3.h>

#define SQLITE_PERROR(db) \
    do { \
        fprintf (stderr, "SQLite3 Error: %s\n", sqlite3_errmsg (db)); \
    } while (0)

int
main (int argc, char **argv)
{
    int error_code = 1;

    char *database_file = NULL;
    char *sql_text = NULL;
    char **input_array = NULL;
    int input_count = 0;

    int rc = 0;
    int step_rc = 0;
    sqlite3 *db = NULL;
    sqlite3_stmt *stmt = NULL;
    int bind_count = 0;
    int bind_index = 0;
    int column_count = 0;
    int column_index = 0;
    const unsigned char *column_result = NULL;

    assert (argv != NULL);
    assert (argv[0] != NULL);
    if (argc < 3)
    {
        fprintf (stderr, "Usage: %s DATABASEFILE SQL [BINDS...]\n", argv[0]);
        return 1;
    }

    assert (argv[1] != NULL);
    assert (argv[2] != NULL);

    database_file = argv[1];
    sql_text = argv[2];
    input_array = &argv[3];
    input_count = argc - 3;

    rc = sqlite3_open_v2 (
            database_file, 
            &db, 
            SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE,
            NULL);

    if (rc != SQLITE_OK)
    {
        SQLITE_PERROR (db);
        goto early_exit;
    }

    rc = sqlite3_prepare_v2 (db, sql_text, -1, &stmt, NULL);
    if (rc != SQLITE_OK)
    {
        SQLITE_PERROR (db);
        goto early_exit;
    }

    bind_count = sqlite3_bind_parameter_count (stmt);
    if (bind_count != input_count)
    {
        fprintf (stderr, "error: statment expects %d paramters, but only %d were given\n",
                bind_count, input_count);
        goto early_exit;
    }

    for (bind_index = 1; bind_index <= bind_count; bind_index++)
    {
        if (0 == strcmp  (input_array[bind_index-1], "NULL"))
        {
            rc = sqlite3_bind_null (stmt, bind_index);
        }
        else
        {
            rc = sqlite3_bind_text (stmt, bind_index, input_array[bind_index-1], -1, SQLITE_STATIC);
        }

        if (rc != SQLITE_OK)
        {
            SQLITE_PERROR (db);
            goto early_exit;
        }
    }

    column_count = sqlite3_column_count (stmt);
    while (SQLITE_ROW == (step_rc = sqlite3_step (stmt)))
    {
        for (column_index = 0; column_index < column_count; column_index++)
        {
            column_result = sqlite3_column_text (stmt, column_index);
            if (column_result == NULL)
            {
                column_result = (const unsigned char *)"(null)";
            }

            printf ("%s", column_result);
            if (column_index + 1 != column_count)
            {
                putchar (',');
            }
        }
        putchar ('\n');
    }

    error_code = 0; /* exit successfully */
early_exit:
    (void)sqlite3_reset (stmt);
    (void)sqlite3_finalize (stmt);
    (void)sqlite3_close (db);
    return error_code;
}

/* end of file */
